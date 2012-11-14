#include <stdio.h>    // fopen()
#include <stdlib.h>    // fopen()
#include <unistd.h>   // exec()
#include <sys/types.h>// wait()
#include <sys/wait.h> // wait()
#include <sys/stat.h> // mkdir()
#include <dirent.h>


//#include <private/android_filesystem_config.h> // AID_MOT_*

#define LOGE printf
#define LOGV
//#define LOGV printf

#define OSHPATH "/osh"
#define RO_MODE "ro"
#define RW_MODE "rw"

#define OSH_UID_GID  (5000)
#define OSH_UID_ROOT (0)

#define DEVICE_DEFAULT  0
const char *DEVICE_LIST[] = {
    "/dev/block/mmcblk0p12",
    "/dev/block/mmcblk0p13",
    "/dev/block/webtop",
    NULL
};

void oshmount(char * rw, char *device);
void remount_rootfs(char * rw);
void create_link(char *target, char *filename);
void copy_to_osh(char *filename);
void symlink_directory(char *source, char *dest);

int main(int argc, char *argv[])
{
    struct stat stat_p;
    int ch, index;
    char *device = NULL;

    /* Only mount input device when it is in device list */
    while ((ch = getopt(argc, argv, "d:")) != EOF) {
        switch(ch){
            case 'd':
                index = 0;
                do{
                    device = (char *)DEVICE_LIST[index++];
                    if(device != NULL && strcasecmp(optarg, device) == 0)
                        break;
                } while (device != NULL);
                break;
            default:
                break;
        }
    }

    if(device == NULL)
    {
        device = (char *)DEVICE_LIST[DEVICE_DEFAULT];
    }

    oshmount((char *)RW_MODE, device);

    if ((stat(OSHPATH "/etc", &stat_p)==0) && S_ISDIR(stat_p.st_mode))
    {

        remove("/etc");

        LOGV("mountosh: Copy adbd to osh\n");
        if (stat(OSHPATH "/sbin", &stat_p) != 0)
        {
            mkdir(OSHPATH "/sbin", 0755);
        }
        copy_to_osh((char *) "/sbin/adbd");
        copy_to_osh((char *) "/bin/CameraCal");
        copy_to_osh((char *) "/bin/qe");
        create_link((char *) "/init", (char *) "/osh/sbin/ueventd");

        remove("/sbin/adbd");
        remove("/sbin/ueventd");
        remove("/sbin");

        remove("/bin/CameraCal");
        remove("/bin/qe");
        remove("/bin");

        if (stat("/data/home/adas/tmp", &stat_p) != 0)
        {
            LOGV("mountosh: Creating home structure\n");
            mkdir("/data/home", 0755);
            mkdir("/data/home/adas", 0755);
            mkdir("/data/home/adas/tmp", 0755);
            mkdir("/data/home/adas/Desktop", 0755);
            chown("/data/home/adas", OSH_UID_GID, OSH_UID_GID);
            chown("/data/home/adas/tmp", OSH_UID_GID, OSH_UID_GID);
            chown("/data/home/adas/Desktop", OSH_UID_GID, OSH_UID_GID);
        }
        create_link((char *) "/data/home", (char *) "/home");

        if (stat("/root", &stat_p) == 0)
        {
            remove("/root");
        }

        symlink_directory(OSHPATH, NULL);
        symlink_directory("/system/etc", OSHPATH "/etc");
        symlink_directory("/system/etc/security", OSHPATH "/etc/security");

        if (stat("/data/var", &stat_p) != 0)
        {
            LOGV("mountosh: Creating /var tree\n");
            mkdir("/data/var", 0755);
            mkdir("/data/var/log", 0755);
            mkdir("/data/var/log/apt", 0755);
            mkdir("/data/var/log/ConsoleKit", 0755);
            mkdir("/data/var/log/cups", 0755);
            mkdir("/data/var/log/fsck", 0755);
            mkdir("/data/var/log/news", 0755);
            chown("/data/var", OSH_UID_ROOT, OSH_UID_ROOT);
            chown("/data/var/log", OSH_UID_ROOT, OSH_UID_ROOT);
            remove("/var/log");
        } else {
            LOGV("mountosh: Using existing /data/var/log tree\n");
        }
        create_link((char *) "/data/var/log", (char *) "/var/log");

    }
    else
    {
        LOGE("mountosh: /etc not found on OSH partition\n");
    }

    return 0;
}

void symlink_directory(char *source, char *dest)
{
    DIR *d;
    struct dirent *de;
    struct stat stat_p;

    if ((d = opendir(source)) != NULL)
    {
        while ((de = readdir(d)))
        {
            if (de->d_name[0] == '.')
            {
                continue;
            }
            if (stat(de->d_name, &stat_p) != 0)
            {
                char file[255];
                char link[255];

                memset(file,0,255);
                strcat(file, source);
                strcat(file, "/");
                strcat(file, de->d_name);

                memset(link,0,255);
                if (dest != NULL)
                {
                    strcat(link, dest);
                    strcat(link, "/");
                }
                strcat(link, de->d_name);

                create_link(file, link);
            }
        }
        closedir(d);
    }
}

void remount_rootfs(char * rw)
{
    char * args[6];
    char option[20];
    int status;

    memset(option,0,20);
    strcat(option,"remount,");
    strcat(option,rw);

    args[0] = (char *)"/system/bin/mount";
    args[1] = (char *)"-o";
    args[2]=option;
    args[3]=(char *)"rootfs";
    args[4]=(char *)"/";
    args[5]=(char *)0;
    if(!fork())
    {
        execv("/system/bin/mount", args);
        //execv does not return
    }
    wait(&status);
}

void oshmount(char * rw, char *device)
{
    char * args[7];
    int status;

    args[0] = (char *)"/system/bin/mount";
    args[1] = (char *)"-w";
    args[2] = (char *)"-t";
    args[3] = (char *)"ext3";
    args[4] = device;
    args[5] = (char *)OSHPATH;
    args[6] = (char *)0;
    if(!fork())
    {
        execv("/system/bin/mount", args);
        //execv does not return
    }
    wait(&status);
}

void create_link(char *target, char *filename)
{
    char * args[5];
    int status;

    args[0] = (char *)"/system/bin/ln";
    args[1] = (char *)"-s";
    args[2] = target;
    args[3] = filename;
    args[4] = (char *)0;
    if(!fork())
    {
        execv("/system/bin/ln", args);
        //execv does not return
    }
    wait(&status);
}

void copy_to_osh(char *filename)
{
    char * args[4];
    char busybox_cmd[50];
    char target[255];
    int status;

    memset(busybox_cmd,0,50);
    strcat(busybox_cmd, "/system/bin/motobox");
    strcat(busybox_cmd, "");

    memset(target,0,255);
    strcat(target, OSHPATH);
    strcat(target, filename);

    args[0] = busybox_cmd;
    args[1] = (char *)"cp";
    args[2] = filename;
    args[3] = target;
    args[4] = (char *)0;

    if(!fork())
    {
        execv(busybox_cmd, args);
        //execv does not return
    }
    wait(&status);
}

