package in.juspay.hypersdk;

import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.widget.LinearLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.FragmentActivity;

import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.PluginResult;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.ref.WeakReference;

import in.juspay.hypersdk.core.PaymentConstants;
import in.juspay.hypersdk.core.SdkTracker;
import in.juspay.hypersdk.data.JuspayResponseHandler;
import in.juspay.hypersdk.ui.HyperPaymentsCallbackAdapter;
import in.juspay.services.HyperServices;
import ${mypackage}.ProcessActivity;

/**
 * Module that exposes Hyper SDK to Cordova bridge JavaScript code.
 */
public class HyperSDKPlugin extends CordovaPlugin {

    private final static String LOG_TAG = "HYPERSDK_CORDOVA_PLUGIN";

    private static final String INITIATE = "initiate";
    private static final String PROCESS = "process";
    private static final String PREFETCH = "prefetch";
    private static final String isINITIALISED = "isInitialised";
    private static final String TERMINATE = "terminate";
    private static final String isNULL = "isNull";
    private static final String onBACKPRESS = "backPress";

    public static final String SDK_TRACKER_LABEL = "hyper_sdk_cordova";
    public static final String PROCESS_PAYLOAD_ARG = "processPayload";

    /**
     * All the React methods in here should be synchronized on this specific object because there
     * was no guarantee that all React methods will be called on the same thread, and can cause
     * concurrency issues.
     */
    private static final Object lock = new Object();
    private static final RequestPermissionsResultDelegate requestPermissionsResultDelegate = new RequestPermissionsResultDelegate();

    public static CordovaInterface cordova = null;
    CallbackContext cordovaCallBack;
    @Nullable
    private static HyperServices hyperServices;
    private static ProcessCallback processCallback;

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        super.initialize(cordova, webView);
        Log.i(LOG_TAG, "Initializing HyperSDK cordova plugin.");
        this.cordova = cordova;
        synchronized (lock) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    FragmentActivity activity = (FragmentActivity) cordova.getActivity();

                    if (activity == null) {
                        SdkTracker.trackBootLifecycle(
                            PaymentConstants.SubCategory.LifeCycle.HYPER_SDK,
                            PaymentConstants.LogLevel.ERROR,
                            SDK_TRACKER_LABEL,
                            "createHyperServices",
                            "activity is null");
                        return;
                    }
                    Context context = activity.getApplicationContext();
                    LinearLayout parent = new LinearLayout(context);
                    parent.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT));
                    hyperServices = new HyperServices((FragmentActivity) cordova.getActivity());
                    requestPermissionsResultDelegate.set(hyperServices);
                }
            });

        }
    }

    @Override
    public boolean execute(final String action, final JSONArray args, final CallbackContext callbackContext){

        if (onBACKPRESS.equalsIgnoreCase(action)) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                public void run() {
                    onBackPressed(args, callbackContext);
                }
            });
            return true;
        }

        this.cordovaCallBack = callbackContext;

        if (PREFETCH.equalsIgnoreCase(action)) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                public void run() {
                    preFetch(args);
                }
            });
            return true;
        }

        if (INITIATE.equalsIgnoreCase(action)) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                public void run() {
                    initiate(args);
                }
            });
            return true;
        }

        if (PROCESS.equalsIgnoreCase(action)) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                public void run() {
                    process(args);
                }
            });
            return true;
        }

        if (isINITIALISED.equalsIgnoreCase(action)) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                public void run() {
                    isInitialised();
                }
            });
            return true;
        }

        if (TERMINATE.equalsIgnoreCase(action)) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                public void run() {
                    terminate();
                }
            });
            return true;
        }

        if (isNULL.equalsIgnoreCase(action)) {
            cordova.getActivity().runOnUiThread(new Runnable() {
                public void run() {
                    isNull();
                }
            });
            return true;
        }

        return false;
    }

    public void preFetch(JSONArray args) {
        try{
            JSONObject params = new JSONObject(String.valueOf(args.get(0)));
            Log.d(LOG_TAG,params.toString());
            HyperServices.preFetch(cordova.getActivity().getApplicationContext(), params);
            sendJSCallback(PluginResult.Status.OK, "success");
        } catch (Exception e){
            sendJSCallback(PluginResult.Status.ERROR, e.getMessage());
        }
    }

    private void initiate(JSONArray args) {
        synchronized (lock) {
            try{
                FragmentActivity activity = (FragmentActivity) cordova.getActivity();
                JSONObject params = new JSONObject(String.valueOf(args.get(0)));
                Log.d(LOG_TAG,params.toString());
                if (activity == null) {
                    SdkTracker.trackBootLifecycle(
                        PaymentConstants.SubCategory.LifeCycle.HYPER_SDK,
                        PaymentConstants.LogLevel.ERROR,
                        SDK_TRACKER_LABEL,
                        "initiate",
                        "activity is null");
                    return;
                }
                if (this.hyperServices == null) {
                    SdkTracker.trackBootLifecycle(
                        PaymentConstants.SubCategory.LifeCycle.HYPER_SDK,
                        PaymentConstants.LogLevel.ERROR,
                        SDK_TRACKER_LABEL,
                        "initiate",
                        "hyperServices is null");
                    return;
                }
                this.hyperServices.initiate(activity, params, new HyperPaymentsCallbackAdapter() {
                    @Override
                    public void onEvent(JSONObject data, JuspayResponseHandler handler) {
                        Log.d("Callback onEvent", data.toString());
                        if ("process_result".equals(data.optString("event"))) {
                            processCallback.onResult();
                        }
                        try {
                            sendJSCallback(PluginResult.Status.OK, data.toString());
                        } catch (Exception e) {
                            sendJSCallback(PluginResult.Status.ERROR, e.getMessage());
                        }
                    }
                });
            } catch (Exception e){
                sendJSCallback(PluginResult.Status.ERROR, e.getMessage());
            }
        }
    }

    private void sendJSCallback(PluginResult.Status status, String data) {
        PluginResult pluginResult = new PluginResult(status, data);
        pluginResult.setKeepCallback(true); // keep callback
        cordovaCallBack.sendPluginResult(pluginResult);
    }

    private void process(JSONArray args) {
        synchronized (lock) {
            try{
                FragmentActivity activity = (FragmentActivity) cordova.getActivity();
                String params = String.valueOf(args.get(0));
                Log.d(LOG_TAG,params.toString());
                if (activity == null) {
                    SdkTracker.trackBootLifecycle(
                        PaymentConstants.SubCategory.LifeCycle.HYPER_SDK,
                        PaymentConstants.LogLevel.ERROR,
                        SDK_TRACKER_LABEL,
                        "process",
                        "activity is null");
                    return;
                }

                if (hyperServices == null) {
                    SdkTracker.trackBootLifecycle(
                        PaymentConstants.SubCategory.LifeCycle.HYPER_SDK,
                        PaymentConstants.LogLevel.ERROR,
                        SDK_TRACKER_LABEL,
                        "process",
                        "hyperServices is null");
                    return;
                }

                Intent i = new Intent(activity, ProcessActivity.class);
                i.putExtra(PROCESS_PAYLOAD_ARG, params);
                activity.startActivity(i);

            } catch (Exception e){
                sendJSCallback(PluginResult.Status.ERROR, e.getMessage());
            }
        }
    }

    public static void processWithActivity(FragmentActivity activity, JSONObject params, ProcessCallback processCallback) {
        if (hyperServices == null) {
            SdkTracker.trackBootLifecycle(
                    PaymentConstants.SubCategory.LifeCycle.HYPER_SDK,
                    PaymentConstants.LogLevel.ERROR,
                    SDK_TRACKER_LABEL,
                    "process",
                    "hyperServices is null");
            return;
        }
        HyperSDKPlugin.processCallback = processCallback;
        hyperServices.process(activity, params);
    }

    public void terminate() {
        synchronized (lock) {
            if (hyperServices != null) {
                hyperServices.terminate();
            }

            hyperServices = null;
        }
    }

    public void isNull() {
        boolean nullStatus = hyperServices == null;
        sendJSCallback(PluginResult.Status.OK, nullStatus?"true":"false");
    }

    public void isInitialised() {
        boolean isInitialized = false;

        synchronized (lock) {
            if (hyperServices != null) {
                try {
                    isInitialized = hyperServices.isInitialised();
                    sendJSCallback(PluginResult.Status.OK, isInitialized?"true":"false");
                } catch (Exception e) {
                    sendJSCallback(PluginResult.Status.ERROR, e.getMessage());
                }
            }
        }
    }

    public static boolean onBackPressed () {
        return hyperServices != null && hyperServices.onBackPressed();
    }

    public static void resetActivity(FragmentActivity activity) {
        if (hyperServices != null) {
            hyperServices.resetActivity(activity);
        }
    }

    /**
     * Notifies HyperSDK that a backPress event is triggered.
     * Merchants are required to call this method from their
     * activity as by default activity will not forward any backPress
     * calls to the fragments running inside it.
     *
     * @param args  The arguments that was received from js plugin
     *                     {@code onBackPressed} method.
     * @param callbackContext  Callback to be triggered for response
     *                     {@code onBackPressed} method.
     */
    public void onBackPressed(final JSONArray args, final CallbackContext callbackContext) {
        try {
            boolean backPressHandled = hyperServices.onBackPressed();
            PluginResult pluginResult = new PluginResult(PluginResult.Status.OK, backPressHandled?"true":"false");
            callbackContext.sendPluginResult(pluginResult);
        } catch (Exception e) {
            sendJSCallback(PluginResult.Status.ERROR, e.getMessage());
        }
    }

    /**
     * Notifies HyperSDK that a response for permissions is here. Merchants are required to call
     * this method from their activity as by default activity will
     * not forward any results to the fragments running inside it.
     *
     * @param requestCode  The requestCode that was received in your activity's
     *                     {@code onRequestPermissionsResult} method.
     * @param permissions  The set of permissions received in your activity's
     *                     {@code onRequestPermissionsResult} method.
     * @param grantResults The results of each permission received in your activity's
     *                     {@code onRequestPermissionsResult} method.
     */
    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) throws JSONException  {
        synchronized (lock) {
            requestPermissionsResultDelegate.onRequestPermissionsResult(requestCode, permissions, grantResults);
        }
    }

    @Override
    public void onNewIntent(Intent intent) {
    }


    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        synchronized (lock) {
            if (hyperServices == null) {
                SdkTracker.trackBootLifecycle(
                    PaymentConstants.SubCategory.LifeCycle.HYPER_SDK,
                    PaymentConstants.LogLevel.ERROR,
                    SDK_TRACKER_LABEL,
                    "onActivityResult",
                    "hyperServices is null");
                return;
            }

            hyperServices.onActivityResult(requestCode, resultCode, data);
        }
    }

    /**
     * A holder class that allows us to maintain HyperServices instance statically without causing a
     * memory leak. This was required because HyperServices class maintains a reference to the
     * activity internally.
     */
    private static class RequestPermissionsResultDelegate {
        @NonNull private WeakReference<HyperServices> hyperServicesHolder = new WeakReference<>(null);

        synchronized void set(@NonNull HyperServices hyperServices) {
            this.hyperServicesHolder = new WeakReference<>(hyperServices);
        }

        void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
            HyperServices hyperServices = hyperServicesHolder.get();

            if (hyperServices == null) {
                SdkTracker.trackBootLifecycle(
                    PaymentConstants.SubCategory.LifeCycle.HYPER_SDK,
                    PaymentConstants.LogLevel.ERROR,
                    SDK_TRACKER_LABEL,
                    "onRequestPermissionsResult",
                    "hyperServices is null");
                return;
            }

            hyperServices.onRequestPermissionsResult(requestCode, permissions, grantResults);
        }
    }

    public interface ProcessCallback {
        void onResult();
    }
}
