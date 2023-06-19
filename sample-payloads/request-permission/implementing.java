import android.app.Activity;
import android.os.Build;

import androidx.annotation.NonNull;
import java.lang.ref.WeakReference;

import in.juspay.hypersdk.ui.RequestPermissionDelegate;

public class ReactRequestDelegate implements RequestPermissionDelegate {

    @NonNull private final WeakReference<Activity> activity;

    public ReactRequestDelegate(Activity activity) {
        this.activity = new WeakReference<>(activity);
    }

    @Override
    public void requestPermission(String[] permissions, int requestCode) {
        Activity activity = this.activity.get();
        if (activity != null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            activity.requestPermissions(permissions, requestCode);
        }
    }
}