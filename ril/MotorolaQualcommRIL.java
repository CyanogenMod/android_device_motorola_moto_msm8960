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

package com.android.internal.telephony;

import static com.android.internal.telephony.RILConstants.*;

import android.content.Context;
import android.os.AsyncResult;
import android.os.Message;
import android.os.Parcel;
import android.text.TextUtils;
import android.telephony.Rlog;
import android.telephony.SignalStrength;

import java.util.ArrayList;

/*
 * Custom Qualcomm RIL for Motorola MSM8960 phones
 *
 * {@hide}
 */
public class MotorolaQualcommRIL extends RIL implements CommandsInterface {
    public MotorolaQualcommRIL(Context context, int networkMode, int cdmaSubscription) {
        super(context, networkMode, cdmaSubscription);
        mQANElements = 5; // fifth element is network generation - 2G/3G/(4G?)
    }

    @Override
    protected Object
    responseOperatorInfos(Parcel p) {
        String strings[] = (String [])responseStrings(p);
        ArrayList<OperatorInfo> ret;
        ArrayList<String> mccmnc;

        if (strings.length % mQANElements != 0) {
            throw new RuntimeException(
                "RIL_REQUEST_QUERY_AVAILABLE_NETWORKS: invalid response. Got "
                + strings.length + " strings, expected multiple of " + mQANElements);
        }

        ret = new ArrayList<OperatorInfo>();
        mccmnc = new ArrayList<String>();

        for (int i = 0 ; i < strings.length ; i += mQANElements) {
            /* add each operator only once - the parcel contains separate entries
               for 2G and 3G networks, we need just the list of available operators */
            if (!mccmnc.contains(strings[i+2])) {
                ret.add (
                    new OperatorInfo(
                        strings[i+0],
                        strings[i+1],
                        strings[i+2],
                        strings[i+3]));
                mccmnc.add(strings[i+2]);
            }
        }

        return ret;
    }

    @Override
    protected Object
    responseSignalStrength(Parcel p) {

        int parcelSize = p.dataSize();
        int gsmSignalStrength = p.readInt();
        int gsmBitErrorRate = p.readInt();
        int cdmaDbm = p.readInt();
        int cdmaEcio = p.readInt();
        int evdoDbm = p.readInt();
        int evdoEcio = p.readInt();
        int evdoSnr = p.readInt();
        int lteSignalStrength = p.readInt();
        int lteRsrp = p.readInt();
        int lteRsrq = p.readInt();
        int lteRssnr = p.readInt();
        int lteCqi = p.readInt();
        boolean isGsm = (mPhoneType == RILConstants.GSM_PHONE);

        SignalStrength signalStrength = new SignalStrength(gsmSignalStrength,
                gsmBitErrorRate, cdmaDbm, cdmaEcio, evdoDbm, evdoEcio, evdoSnr,
                lteSignalStrength, lteRsrp, lteRsrq, lteRssnr, lteCqi, isGsm);

        return signalStrength;
    }
}
