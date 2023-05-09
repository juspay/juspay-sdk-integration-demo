
package in.juspay.devtools;

import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebViewClient;
import androidx.annotation.Keep;
import androidx.annotation.Nullable;
import androidx.fragment.app.FragmentActivity;
import org.json.JSONObject;
import java.util.LinkedList;
import java.util.Queue;
import in.juspay.hypersdk.data.JuspayResponseHandler;
import in.juspay.hypersdk.ui.HyperPaymentsCallback;
import in.juspay.services.HyperServices;
import in.juspay.hypersdk.core.MerchantViewType;


@Keep
public class HyperServiceHolder implements HyperPaymentsCallback {

    public enum EventsType{onEvent, onStartWaitingDialogCreated, getMerchantView};

    static HyperServices hyperServices;
    FragmentActivity fragmentActivity;
    static boolean initiated = false;
    static HyperPaymentsCallback callback;

    private final Queue<QueuedEvents> queue = new LinkedList<>();

    @Keep
    public HyperServiceHolder(FragmentActivity activity){
        fragmentActivity = activity;
    }

    @Keep
    public HyperServices getHyperServices(){
        if(hyperServices == null && fragmentActivity !=null){
            hyperServices = new HyperServices(fragmentActivity);
        }
        return hyperServices;
    }

    @Keep
    public void initiate(JSONObject json){
        getHyperServices().initiate(fragmentActivity, json, this);
    }

    @Keep
    public void process(ViewGroup viewGroup,JSONObject json){
        getHyperServices().process(fragmentActivity, viewGroup, json);
    }

    @Keep
    public void process(JSONObject json){
        getHyperServices().process(fragmentActivity, json);
    }

    @Keep
    public void setCallback(HyperPaymentsCallback callback){
        this.callback = callback;
        runQueueEvents();
    }

    @Keep
    public boolean isInitiated(){
        return getHyperServices().isInitialised();
    }

    @Override
    public void onStartWaitingDialogCreated(@Nullable View parent) {
        if(callback != null)
            callback.onStartWaitingDialogCreated(parent);
        else {
            QueuedEvents qEvent = new QueuedEvents();
            qEvent.eventType = EventsType.onStartWaitingDialogCreated;
            qEvent.parent = parent;
            queue.add(qEvent);
        }
    }

    @Override
    public void onEvent(JSONObject event, JuspayResponseHandler handler) {
        String event1 = event.optString("event", "");
        if(event1.equals("initiate_result")){
            initiated = true;
        }
        if(callback != null){
            callback.onEvent(event,handler);
        } else {
            QueuedEvents qEvent = new QueuedEvents();
            qEvent.event = event;
            qEvent.handler = handler;
            qEvent.eventType = EventsType.onEvent;
            queue.add(qEvent);
        }
    }

    @Nullable
    @Override
    public View getMerchantView(ViewGroup parent, MerchantViewType viewType ) {
        if(callback != null)
            callback.getMerchantView(parent, viewType);
        else {
            QueuedEvents qEvent = new QueuedEvents();
            queue.add(qEvent);
            qEvent.eventType = EventsType.getMerchantView;
            qEvent.viewGroup = parent;
            qEvent.viewType = viewType;

        }
        return null;
    }

    @Nullable
    @org.jetbrains.annotations.Nullable
    @Override
    public WebViewClient createJuspaySafeWebViewClient() {
        return null;
    }

    private void runQueueEvents(){
        QueuedEvents head = queue.poll();
        if (head != null) {
            switch (head.eventType){
                case onEvent:
                    if(callback != null)
                        callback.onEvent(head.event, head.handler);
                    break;
                case onStartWaitingDialogCreated:
                    if(callback != null)
                        callback.onStartWaitingDialogCreated(head.parent);
                    break;
                case getMerchantView:
                    if(callback != null)
                        callback.getMerchantView(head.viewGroup, head.viewType);
                    break;
                default:
                    break;
            }
            runQueueEvents();
        }
    }

    public boolean handleBackPress() {
        if(getHyperServices().isInitialised()) {
            // returns not of
            // if hyper-services is handling backPress
            return !getHyperServices().onBackPressed();
        }
        return true;
    }
}

class QueuedEvents {
    JSONObject event;
    JuspayResponseHandler handler;
    HyperServiceHolder.EventsType eventType;
    ViewGroup viewGroup;
    View parent;
    MerchantViewType viewType;
    QueuedEvents(){}
}
