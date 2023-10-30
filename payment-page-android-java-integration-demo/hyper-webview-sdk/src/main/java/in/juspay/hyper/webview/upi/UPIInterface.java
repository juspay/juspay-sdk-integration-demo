package in.juspay.hyper.webview.upi;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.net.Uri;
import android.webkit.JavascriptInterface;

import androidx.annotation.NonNull;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Collections;
import java.util.List;

final class UPIInterface {

    @NonNull
    private final Activity activity;

    UPIInterface(@NonNull Activity activity) {
        this.activity = activity;
    }

    @JavascriptInterface
    public String findApps(String payload) {
        PackageManager pm = activity.getPackageManager();
        Intent upiApps = new Intent();
        upiApps.setData(Uri.parse(payload));
        List<ResolveInfo> resolveInfoList;
        resolveInfoList = pm.queryIntentActivities(upiApps, 0);
        Collections.sort(resolveInfoList, new ResolveInfo.DisplayNameComparator(pm));

        JSONArray apps = new JSONArray();

        for (ResolveInfo resolveInfo : resolveInfoList) {
            JSONObject jsonObject = new JSONObject();
            try {
                ApplicationInfo ai = pm.getApplicationInfo(resolveInfo.activityInfo.packageName, 0);
                jsonObject.put("packageName", ai.packageName);
                jsonObject.put("appName", pm.getApplicationLabel(ai));

                apps.put(jsonObject);
            } catch (JSONException | PackageManager.NameNotFoundException ignored) {
            }
        }

        return apps.toString();
    }

    @JavascriptInterface
    public void openApp(String packageName, String payload, String action, int flag) {
        Intent i = new Intent();
        i.setPackage(packageName);
        i.setAction(action);
        i.setData(Uri.parse(payload));
        i.setFlags(flag);
        activity.startActivityForResult(i, HyperWebViewServices.UPI_REQUEST_CODE);
    }

    @JavascriptInterface
    public String getResourceByName(String resName) {
        return getResourceById(activity.getResources().getIdentifier(resName, "string", activity.getPackageName()));
    }

    private String getResourceById(int resId) {
        return activity.getResources().getString(resId);
    }

}
