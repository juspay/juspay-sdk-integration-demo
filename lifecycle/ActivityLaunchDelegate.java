import com.facebook.react.bridge.ReactApplicationContext;

import in.juspay.hypersdk.ui.ActivityLaunchDelegate;

public final class ReactLaunchDelegate implements ActivityLaunchDelegate {

    private final ReactApplicationContext context;

    public ReactLaunchDelegate(ReactApplicationContext context) {
        this.context = context;
    }

    @Override
    public void startActivityForResult(Intent intent, int requestCode, Bundle bundle) {
        context.startActivityForResult(intent, requestCode, bundle);
    }
}