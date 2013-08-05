package com.cyanogenmod.settings.device;

import java.util.ArrayList;

import android.app.AlertDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.PowerManager;
import android.os.SystemProperties;
import android.preference.CheckBoxPreference;
import android.preference.ListPreference;
import android.preference.Preference;
import android.preference.Preference.OnPreferenceChangeListener;
import android.preference.PreferenceActivity;
import android.preference.PreferenceCategory;
import android.preference.PreferenceScreen;
import android.provider.Settings;

public class DeviceSettings extends PreferenceActivity implements
        OnPreferenceChangeListener {

    private static final String REPORT_GPRS_AS_EDGE_PREF = "pref_report_gprs_as_edge";
    private static final String REPORT_GPRS_AS_EDGE_PROP = "persist.sys.report_gprs_as_edge";
    private static final String REPORT_GPRS_AS_EDGE_DEFAULT = "0";

    private static CheckBoxPreference mReportGprsAsEdgePref;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        addPreferencesFromResource(R.xml.settings);

        PreferenceScreen prefSet = getPreferenceScreen();

        mReportGprsAsEdgePref = (CheckBoxPreference) prefSet.findPreference(REPORT_GPRS_AS_EDGE_PREF);
        String reportGprsAsEdgeVal = SystemProperties.get(REPORT_GPRS_AS_EDGE_PROP, REPORT_GPRS_AS_EDGE_DEFAULT);
        mReportGprsAsEdgePref.setChecked(reportGprsAsEdgeVal.equals("1"));
        mReportGprsAsEdgePref.setOnPreferenceChangeListener(this);

        if ((SystemProperties.get("ro.product.device","").equals("xt907")) &&
            (SystemProperties.get("ro.product.device","").equals("xt926"))) {
            mReportGprsAsEdgePref.setEnabled(false);
        }

    }

    public boolean onPreferenceChange(Preference preference, Object newValue) {
        if (preference == mReportGprsAsEdgePref) {
            Boolean checked = (Boolean) newValue;
            if (checked) {
                SystemProperties.set(REPORT_GPRS_AS_EDGE_PROP, "1");
            } else {
                SystemProperties.set(REPORT_GPRS_AS_EDGE_PROP, "0");
            }
            return true;
        }
        return false;
    }
}
