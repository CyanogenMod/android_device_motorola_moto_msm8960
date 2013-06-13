/*
 * Copyright (C) 2013 The CyanogenMod Project
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

/*
 * Created on 12/06/2013 by epinter
 *
 */
package com.android.settings.cyanogenmod.DevicePerformanceSettingsHelper;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.util.Log;

import java.util.Arrays;
import java.util.List;

public class BootReceiver extends BroadcastReceiver {
    public static final String TAG="PerformanceHelper";
    public static final String FREQ_MIN_PREF = "pref_cpu_freq_min";
    public static final String FREQ_MAX_PREF = "pref_cpu_freq_max";
    public static final String GOV_PREF = "pref_cpu_gov";
    public static final String FREQ_LIST_FILE = "/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies";
    public static final String GOV_LIST_FILE = "/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors";
    public static final String SOB_PREF = "pref_cpu_set_on_boot";

    public String CPU_ONLINE_FILES[] = null;
    public String CPU_GOV_FILES[] = null;
    public String FREQ_MAX_FILES[] = null;
    public String FREQ_MIN_FILES[] = null;
    public String THERMAL_MAX = null;

    public BootReceiver() {
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        Context friendContext=null;
        try {
            friendContext = context.createPackageContext( "com.android.settings",Context.CONTEXT_IGNORE_SECURITY);
            if(friendContext==null) return;
        } catch(Exception e) {
            e.printStackTrace();
        }
        SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(friendContext);
        if (prefs.getBoolean(SOB_PREF, false) == false) {
            Log.i(TAG, "Restore disabled by user preference.");
            return;
        }

        Process suproc=null;
        try {
            suproc = Runtime.getRuntime().exec(new String[]{"su", "-c", "/system/bin/sh"});
        } catch (Exception e) {
            Log.i(TAG, "Error executing 'su', aborting.");
            e.printStackTrace();
            return;
        }

        String governor = prefs.getString(GOV_PREF, null);
        String minFrequency = prefs.getString(FREQ_MIN_PREF, null);
        String maxFrequency = prefs.getString(FREQ_MAX_PREF, null);
        String availableFrequenciesLine = Utils.fileReadOneLine(FREQ_LIST_FILE);
        String availableGovernorsLine = Utils.fileReadOneLine(GOV_LIST_FILE);

        CPU_GOV_FILES= context.getResources().getStringArray(R.array.cpu_gov_files);
        CPU_ONLINE_FILES= context.getResources().getStringArray(R.array.cpu_online_files);
        FREQ_MAX_FILES = context.getResources().getStringArray(R.array.max_cpu_freq_files);
        FREQ_MIN_FILES = context.getResources().getStringArray(R.array.min_cpu_freq_files);
        THERMAL_MAX = context.getResources().getString(R.string.thermal_max_freq);

        boolean noSettings = ((availableGovernorsLine == null) || (governor == null)) &&
                             ((availableFrequenciesLine == null) || ((minFrequency == null) && (maxFrequency == null)));
        List<String> frequencies = null;
        List<String> governors = null;

        if (noSettings) {
            Log.d(TAG, "No CPU settings saved. Nothing to restore.");
        } else {
            if (availableGovernorsLine != null){
                governors = Arrays.asList(availableGovernorsLine.split(" "));
            }
            if (availableFrequenciesLine != null){
                frequencies = Arrays.asList(availableFrequenciesLine.split(" "));
            }

            //bring up all cpus
            for(String cpu_online_file:CPU_ONLINE_FILES) {
                if(Utils.fileExists(cpu_online_file)) {
                    Log.i(TAG,"Bring up "+cpu_online_file);
                    Utils.fileWriteOneLine(cpu_online_file, "1",suproc);
                }
            }

            if (maxFrequency != null && frequencies != null && frequencies.contains(maxFrequency)) {
                for(String max_freq_file:FREQ_MAX_FILES) {
                    if(Utils.fileExists(max_freq_file)) {
                        Log.i(TAG,"Setting "+max_freq_file+" to "+maxFrequency);
                        Utils.fileWriteOneLine(max_freq_file, maxFrequency,suproc);
                    }
                }

                if(Utils.fileExists(THERMAL_MAX)) {
                    Log.i(TAG,"Configuring thermal max to "+maxFrequency);
                    Utils.fileWriteOneLine(THERMAL_MAX, maxFrequency,suproc);
                    Log.i(TAG,"Restarting thermald");
                    Utils.restartThermald(suproc);
                }
            }

            if (minFrequency != null && frequencies != null && frequencies.contains(minFrequency)) {
                for(String min_freq_file:FREQ_MIN_FILES) {
                    if(Utils.fileExists(min_freq_file)) {
                        Log.i(TAG,"Setting "+min_freq_file+" to "+minFrequency);
                        Utils.fileWriteOneLine(min_freq_file, minFrequency,suproc);
                    }
                }
            }
            if (governor != null && governors != null && governors.contains(governor)) {
                for(String cpu_gov_file:CPU_GOV_FILES) {
                    if(Utils.fileExists(cpu_gov_file)) {
                        Log.i(TAG,"Setting governor "+cpu_gov_file+" to "+governor);
                        Utils.fileWriteOneLine(cpu_gov_file, governor,suproc);
                    }
                }
            }
        }

    }
}
