# Copyright (C) 2012 The Android Open Source Project
# Copyright (C) 2014 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Custom OTA commands for Motorola msm8960 devices"""

def FullOTA_InstallEnd(info):
	info.script.AppendExtra('ifelse(is_substring("XT90", getprop("ro.boot.modelno")), run_program("/sbin/sh", "-c", "busybox mv /system/etc/media_profiles_xt90x.xml /system/etc/media_profiles.xml"));')
	info.script.AppendExtra('ifelse(is_substring("XT90", getprop("ro.product.device")), run_program("/sbin/sh", "-c", "busybox mv /system/etc/media_profiles_xt90x.xml /system/etc/media_profiles.xml"));')
	info.script.AppendExtra('ifelse(is_substring("MB886", getprop("ro.boot.modelno")), run_program("/sbin/sh", "-c", "busybox rm /system/etc/nfc* /system/etc/permissions/*nfc* /system/etc/permissions/*nxp* /system/lib/libnfc* /system/lib/hw/nfc* /system/framework/com.android.nfc_extras.jar /system/app/Nfc.apk /system/priv-app/Tag.apk"));')
	info.script.AppendExtra('ifelse(is_substring("att", getprop("ro.boot.carrier")), run_program("/sbin/sh", "-c", "busybox rm /system/etc/nfc* /system/etc/permissions/*nfc* /system/etc/permissions/*nxp* /system/lib/libnfc* /system/lib/hw/nfc* /system/framework/com.android.nfc_extras.jar /system/app/Nfc.apk /system/priv-app/Tag.apk"));')
	info.script.AppendExtra('delete("/system/etc/media_profiles_xt90x.xml");')
	info.script.AppendExtra('ifelse(is_substring("sprint", getprop("ro.boot.carrier")), run_program("/sbin/sh", "-c", "busybox cp -R /system/xt897/* /system/"));')
	info.script.AppendExtra('ifelse(is_substring("240", getprop("ro.sf.lcd_density")), run_program("/sbin/sh", "-c", "busybox mv /system/media/540.zip /system/media/bootanimation.zip"));')
	info.script.AppendExtra('delete("/system/media/540.zip");')
	info.script.AppendExtra('ifelse(is_substring("XT901", getprop("ro.boot.modelno")), run_program("/sbin/sh", "-c", "busybox cp -R /system/xt901/* /system/"));')
	info.script.AppendExtra('ifelse(is_substring("vanquish", getprop("ro.product.device")), run_program("/sbin/sh", "-c", "busybox mv /system/etc/snd_soc_msm/snd_soc_msm_2x_xt92x /system/etc/snd_soc_msm/snd_soc_msm_2x"));')
	info.script.AppendExtra('ifelse(is_substring("xt92", getprop("ro.product.device")), run_program("/sbin/sh", "-c", "busybox mv /system/etc/snd_soc_msm/snd_soc_msm_2x_xt92x /system/etc/snd_soc_msm/snd_soc_msm_2x"));')
	info.script.AppendExtra('delete("/system/etc/snd_soc_msm/snd_soc_msm_2x_xt92x");')
