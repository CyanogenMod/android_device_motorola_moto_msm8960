/*
 * Copyright (C) 2008 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#define LOG_TAG "bluedroid"

#include <errno.h>
#include <fcntl.h>
#include <stdlib.h>
#include <sys/ioctl.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/stat.h>

#include <cutils/log.h>
#include <cutils/properties.h>

#include <bluetooth/bluetooth.h>
#include <bluetooth/hci.h>
#include <bluetooth/hci_lib.h>

#include <bluedroid/bluetooth.h>

#ifndef HCI_DEV_ID
#define HCI_DEV_ID 0
#endif

#define HCID_STOP_DELAY_USEC 500000
#define DELAY_USEC 2000000

#define MIN(x,y) (((x)<(y))?(x):(y))
#define HCISMD_MOD_PARAM "/sys/module/hci_smd/parameters/hcismd_set"

/*Variables to identify the transport using msm type*/
static char transport_type[PROPERTY_VALUE_MAX];
static char bt_soc_type[PROPERTY_VALUE_MAX];
static int is_transportSMD = -1;
static char hciattach_serv[20];

static int rfkill_id = -1;
static char *rfkill_state_path = NULL;

static void get_hci_trasport() {

    int ret = -1;
    ret = property_get("ro.qualcomm.bt.hci_transport", transport_type, NULL);
    if(ret == 0)
        ALOGI("ro.qualcomm.bt.hci_transport not set\n");
    else
        ALOGI("ro.qualcomm.bt.hci_transport %s \n", transport_type);

    if (!strcasecmp(transport_type, "smd"))
        is_transportSMD = 1;
    else
        is_transportSMD = 0;

}

static int init_rfkill() {
    char path[64];
    char buf[16];
    int fd;
    int sz;
    int id;
    for (id = 0; ; id++) {
        snprintf(path, sizeof(path), "/sys/class/rfkill/rfkill%d/type", id);
        fd = open(path, O_RDONLY);
        if (fd < 0) {
            ALOGW("open(%s) failed: %s (%d)\n", path, strerror(errno), errno);
            return -1;
        }
        sz = read(fd, &buf, sizeof(buf));
        close(fd);
        if (sz >= 9 && memcmp(buf, "bluetooth", 9) == 0) {
            rfkill_id = id;
            break;
        }
    }

    asprintf(&rfkill_state_path, "/sys/class/rfkill/rfkill%d/state", rfkill_id);
    return 0;
}

static int check_bluetooth_power() {
    int sz;
    int fd = -1;
    int ret = -1;
    char buffer;

    if (rfkill_id == -1) {
        if (init_rfkill()) goto out;
    }

    fd = open(rfkill_state_path, O_RDONLY);
    if (fd < 0) {
        ALOGE("open(%s) failed: %s (%d)", rfkill_state_path, strerror(errno),
             errno);
        goto out;
    }
    sz = read(fd, &buffer, 1);
    if (sz != 1) {
        ALOGE("read(%s) failed: %s (%d)", rfkill_state_path, strerror(errno),
             errno);
        goto out;
    }

    switch (buffer) {
    case '1':
        ret = 1;
        break;
    case '0':
        ret = 0;
        break;
    }

out:
    if (fd >= 0) close(fd);
    return ret;
}

static int set_bluetooth_power(int on) {
    int sz;
    int fd = -1;
    int ret = -1;
    const char buffer = (on ? '1' : '0');

    if (rfkill_id == -1) {
        if (init_rfkill()) goto out;
    }

    fd = open(rfkill_state_path, O_WRONLY);
    if (fd < 0) {
        ALOGE("open(%s) for write failed: %s (%d)", rfkill_state_path,
             strerror(errno), errno);
        goto out;
    }
    sz = write(fd, &buffer, 1);
    if (sz < 0) {
        ALOGE("write(%s) failed: %s (%d)", rfkill_state_path, strerror(errno),
             errno);
        goto out;
    }
    ret = 0;

out:
    if (fd >= 0) close(fd);
    return ret;
}

static int set_hci_smd_transport(int on) {
    int sz;
    int fd = -1;
    int ret = -1;
    const char buffer = (on ? '1' : '0');

    fd = open(HCISMD_MOD_PARAM, O_WRONLY);
    if (fd < 0) {
        ALOGE("open(%s) for write failed: %s (%d)", HCISMD_MOD_PARAM,
             strerror(errno), errno);
        goto out;
    }
    sz = write(fd, &buffer, 1);
    if (sz < 0) {
        ALOGE("write(%s) failed: %s (%d)", HCISMD_MOD_PARAM, strerror(errno),
             errno);
        goto out;
    }
    ret = 0;

out:
    if (fd >= 0) close(fd);
    return ret;
}
static inline int create_hci_sock() {
    int sk = socket(AF_BLUETOOTH, SOCK_RAW, BTPROTO_HCI);
    if (sk < 0) {
        ALOGE("Failed to create bluetooth hci socket: %s (%d)",
             strerror(errno), errno);
    }
    return sk;
}

static int is_bt_soc_ath() {
    int ret = 0;

    ret = property_get("qcom.bluetooth.soc", bt_soc_type, NULL);

    if (ret != 0) {
        ALOGI("qcom.bluetooth.soc set to %s\n", bt_soc_type);
        if (!strncasecmp(bt_soc_type, "ath3k", sizeof("ath3k")))
            return 1;
    } else {
        ALOGI("qcom.bluetooth.soc not set, so using default.\n");
    }

    return 0;
}

int bt_enable() {
    ALOGV(__FUNCTION__);

    int ret = -1;
    int hci_sock = -1;
    int attempt;
    static int bt_on_once;

    if(-1 == is_transportSMD)
      get_hci_trasport();

    if (is_bt_soc_ath()) {
        strlcpy(hciattach_serv, "hciattach_ath3k", sizeof(hciattach_serv));
        is_transportSMD = 0;
    } else
        strlcpy(hciattach_serv, "hciattach", sizeof(hciattach_serv));

    if (!is_transportSMD)
        if (set_bluetooth_power(1) < 0)
            goto out;

    ALOGI("Starting hciattach daemon with service %s", hciattach_serv);
    if (property_set("ctl.start", hciattach_serv) < 0) {
        ALOGE("Failed to start hciattach service %s", hciattach_serv);
        if (!is_transportSMD)
            set_bluetooth_power(0);
        goto out;
    }

    // Try for 10 seconds, this can only succeed once hciattach has sent the
    // firmware and then turned on hci device via HCIUARTSETPROTO ioctl
    for (attempt = 1000; attempt > 0;  attempt--) {
        hci_sock = create_hci_sock();
        if (hci_sock < 0) goto out;

        ret = ioctl(hci_sock, HCIDEVUP, HCI_DEV_ID);

        ALOGI("bt_enable: ret: %d, errno: %d", ret, errno);
        if (!ret) {
            break;
        } else if (errno == EALREADY) {
            ALOGW("Bluetoothd already started, unexpectedly!");
            break;
        }

        close(hci_sock);
        usleep(100000);  // 100 ms retry delay
    }
    if (attempt == 0) {
        ALOGE("%s: Timeout waiting for HCI device to come up, error- %d, ",
            __FUNCTION__, ret);
        if (!is_transportSMD) {
            if (property_set("ctl.stop", hciattach_serv) < 0) {
                ALOGE("Error stopping hciattach");
            }
            set_bluetooth_power(0);
        }
        goto out;
    }

    ALOGI("Starting bluetoothd deamon");
    if (property_set("ctl.start", "bluetoothd") < 0) {
        ALOGE("Failed to start bluetoothd");
        if (!is_transportSMD)
            set_bluetooth_power(0);
        goto out;
    }

    ret = 0;

out:
    if (hci_sock >= 0) close(hci_sock);
    return ret;
}

int bt_disable() {
    ALOGV(__FUNCTION__);

    int ret = -1;
    int hci_sock = -1;

    if (-1 == is_transportSMD)
       get_hci_trasport();

    if (is_bt_soc_ath()) {
        strlcpy(hciattach_serv, "hciattach_ath3k", sizeof(hciattach_serv));
        is_transportSMD = 0;
    } else
        strlcpy(hciattach_serv, "hciattach", sizeof(hciattach_serv));

    ALOGI("Stopping bluetoothd deamon");
    if (property_set("ctl.stop", "bluetoothd") < 0) {
        ALOGE("Error stopping bluetoothd");
        goto out;
    }
    usleep(HCID_STOP_DELAY_USEC);

    hci_sock = create_hci_sock();
    if (hci_sock < 0) goto out;
    ioctl(hci_sock, HCIDEVDOWN, HCI_DEV_ID);
    if (!is_transportSMD) {
        ALOGI("Stopping hciattach deamon %s", hciattach_serv);
        if (property_set("ctl.stop", hciattach_serv) < 0) {
            ALOGE("Error stopping hciattach");
            goto out;
        }
    }

    if (!is_transportSMD) {
        if (set_bluetooth_power(0) < 0)
            goto out;
    } else {
        set_hci_smd_transport(0);
    }

    ret = 0;

out:
    if (hci_sock >= 0) close(hci_sock);
    return ret;
}

int bt_is_enabled() {
    ALOGV(__FUNCTION__);

    int hci_sock = -1;
    int ret = -1;
    struct hci_dev_info dev_info;

    if (-1 == is_transportSMD)
       get_hci_trasport();

    // Check power first
    if (!is_transportSMD) {
        ret = check_bluetooth_power();
        if (ret == -1 || ret == 0) goto out;
    }
    ret = -1;

    // Power is on, now check if the HCI interface is up
    hci_sock = create_hci_sock();
    if (hci_sock < 0) goto out;

    dev_info.dev_id = HCI_DEV_ID;
    if (ret = ioctl(hci_sock, HCIGETDEVINFO, (void *)&dev_info) < 0) {
        ALOGE("ioctl error: ret=%d", ret);
        ret = 0;
        goto out;
    }

    if (dev_info.flags & (1 << (HCI_UP & 31))) {
        ret = 1;
    } else {
        ret = 0;
    }

out:
    if (hci_sock >= 0) close(hci_sock);
    return ret;
}

int ba2str(const bdaddr_t *ba, char *str) {
    return sprintf(str, "%2.2X:%2.2X:%2.2X:%2.2X:%2.2X:%2.2X",
                ba->b[5], ba->b[4], ba->b[3], ba->b[2], ba->b[1], ba->b[0]);
}

int str2ba(const char *str, bdaddr_t *ba) {
    int i;
    for (i = 5; i >= 0; i--) {
        ba->b[i] = (uint8_t) strtoul(str, (char **) &str, 16);
        str++;
    }
    return 0;
}
