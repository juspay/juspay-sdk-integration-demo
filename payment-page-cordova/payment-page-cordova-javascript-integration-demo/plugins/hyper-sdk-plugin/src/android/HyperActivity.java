package ${mypackage};

import org.apache.cordova.*;
import in.juspay.hypersdk.HyperSDKPlugin;

public class HyperActivity extends CordovaActivity {
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
        super.onDestroy();
    }
}
