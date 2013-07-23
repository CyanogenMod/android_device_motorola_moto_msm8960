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

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.DataOutputStream;

import android.util.Log;

public class Utils {
    public static final String TAG="PerformanceHelper";

    public static boolean fileExists(String filename) {
        return new File(filename).exists();
    }

    public static String fileReadOneLine(String fname) {
        BufferedReader br;
        String line = null;

        try {
            br = new BufferedReader(new FileReader(fname), 512);
            try {
                line = br.readLine();
            } finally {
                br.close();
            }
        } catch (Exception e) {
            Log.e(TAG, "IO Exception when reading /sys/ file", e);
        }
        return line;
    }

    public static boolean fileWriteOneLine(String fname, String value,Process su) {
        try {
            DataOutputStream out = new DataOutputStream(su.getOutputStream());
            out.writeBytes("echo "+value+" > "+fname+"\n");
        } catch (Exception e) {
            String Error = "Error writing to " + fname + ". Exception: ";
            Log.e(TAG, Error, e);
            return false;
        }
        return true;
    }

    public static boolean restartThermald(Process su) {
        try {
            DataOutputStream out = new DataOutputStream(su.getOutputStream());
            out.writeBytes("stop thermald\n");
            try {
                Thread.sleep(1000);
            } catch(Exception e) {
            }
            out.writeBytes("start thermald\n");
        } catch (Exception e) {
            String Error = "Error restarting thermald. Exception: ";
            Log.e(TAG, Error, e);
            return false;
        }
        return true;
    }
}

