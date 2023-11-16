/*
 * Copyright (c) Juspay Technologies.
 *
 * This source code is licensed under the AGPL 3.0 license found in the
 * LICENSE file in the root directory of this source tree.
 */

package ${mypackage};

import android.os.Bundle;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;

import org.json.JSONException;
import org.json.JSONObject;

import in.juspay.hyper.constants.LogLevel;
import in.juspay.hyper.constants.LogSubCategory;
import in.juspay.hypersdk.HyperSDKPlugin;
import in.juspay.hypersdk.core.SdkTracker;

public class ProcessActivity extends AppCompatActivity {
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);

        try {
            JSONObject payload = new JSONObject(getIntent().getStringExtra(HyperSDKPlugin.PROCESS_PAYLOAD_ARG));
            HyperSDKPlugin.processWithActivity(this, payload, new HyperSDKPlugin.ProcessCallback() {
                @Override
                public void onResult() {
                    finish();
                }
            });
        } catch (JSONException e) {
            SdkTracker.trackAndLogBootException(
                    LogSubCategory.LifeCycle.HYPER_SDK,
                    LogLevel.ERROR,
                    HyperSDKPlugin.SDK_TRACKER_LABEL,
                    "process",
                    "error while parsing string to JSON",
                    e);
        }
    }

    @Override
    public void onBackPressed() {
        boolean backPressHandled = HyperSDKPlugin.onBackPressed();
        if (!backPressHandled) {
            super.onBackPressed();
        }
    }

    @Override
    public void onDestroy() {
        HyperSDKPlugin.resetActivity(this);
        HyperSDKPlugin.notifyMerchantOnActivityRecreate(true);
        super.onDestroy();
    }
}
