package in.juspay.hyper.webview.upi;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Base64;
import android.webkit.WebView;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import org.json.JSONArray;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Set;

public final class HyperWebViewServices {

    @Keep
    public static final int UPI_REQUEST_CODE = 19;

    @NonNull
    private final UPIInterface upiInterface;
    @NonNull
    private final WebView webView;

    @Keep
    public HyperWebViewServices(@NonNull Activity activity, @NonNull WebView webView) {
        this.upiInterface = new UPIInterface(activity);
        this.webView = webView;
    }

    @Keep
    public void attach() {
        webView.addJavascriptInterface(upiInterface, "HyperWebViewBridge");
    }

    @Keep
    public void onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        if (data != null) {
            JSONObject jsonObject = toJSON(data.getExtras());
            String encoded = Base64.encodeToString(jsonObject.toString().getBytes(), Base64.NO_WRAP);

            addJsToWebView("window.onActivityResult('" + requestCode + "', '" + resultCode + "', atob('" + encoded + "'))");
        } else {
            addJsToWebView("window.onActivityResult('" + requestCode + "', '" + resultCode + "', '{}')");
        }
    }

    private void addJsToWebView(@NonNull String command) {
        runOnMainThread(() -> webView.evaluateJavascript(command, null));
    }

    private void runOnMainThread(@NonNull Runnable task) {
        if (Looper.myLooper() != Looper.getMainLooper()) {
            Handler handler = new Handler(Looper.getMainLooper());
            handler.post(task);
        } else {
            task.run();
        }
    }

    @NonNull
    private JSONObject toJSON(Bundle bundle) {
        JSONObject json = new JSONObject();

        try {
            if (bundle != null) {
                Set<String> keys = bundle.keySet();

                for (String key : keys) {
                    Object value = bundle.get(key);

                    if (value == null) {
                        json.put(key, JSONObject.NULL);
                    } else if (value instanceof ArrayList) {
                        json.put(key, toJSONArray((ArrayList<?>) value));
                    } else if (value instanceof Bundle) {
                        json.put(key, toJSON((Bundle) value));
                    } else {
                        json.put(key, String.valueOf(value));
                    }
                }
            }
        } catch (Exception ignored) {
        }
        return json;
    }

    @NonNull
    private JSONArray toJSONArray(@NonNull ArrayList<?> array) {
        JSONArray jsonArray = new JSONArray();
        for (Object obj : array) {
            if (obj instanceof ArrayList) {
                jsonArray.put(toJSONArray((ArrayList<?>) obj));
            } else if (obj instanceof JSONObject) {
                jsonArray.put(obj);
            } else {
                jsonArray.put(String.valueOf(obj));
            }
        }
        return jsonArray;
    }
}
