package in.juspay.devtools;

import androidx.appcompat.app.AppCompatActivity;
import androidx.coordinatorlayout.widget.CoordinatorLayout;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ProgressBar;
import in.juspay.hypercheckoutlite.HyperCheckoutLite;
import in.juspay.hypersdk.data.JuspayResponseHandler;
import in.juspay.hypersdk.ui.HyperPaymentsCallbackAdapter;
import org.json.JSONException;
import org.json.JSONObject;
import java.io.IOException;

public class CheckoutActivity extends AppCompatActivity {
    private Button processButton;
    private CoordinatorLayout coordinatorLayout;
    private ProgressBar progressBar;
    private ImageView backImage;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_checkout);
    }

    @Override
    protected void onStart() {
        super.onStart();
        updatingUI(); //This is relevant only for sample project
        processButton = findViewById(R.id.rectangle_9);
        processButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                runOnUiThread(() -> {
                    progressBar.setVisibility(View.VISIBLE);
                });
                try {
                    startPayment();
                } catch (Exception e) {

                }
            }
        });
        backImage = findViewById(R.id.imageView);
        backImage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                onBackPressed();
            }
        });
    }

    // block:start:startPayment
    private void startPayment() throws IOException {
        JSONObject payload = new JSONObject();

        // block:start:sendPostRequest
        ApiClient.sendPostRequest("http://10.0.2.2:5000/initiateJuspayPayment", payload, new ApiClient.ApiResponseCallback() {
            @Override
            public void onResponseReceived(String response) throws JSONException {
                try {
                    JSONObject sdkPayload = new JSONObject(response).getJSONObject("sdkPayload");
                    CheckoutActivity.this.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            // block:start:openPaymentPage
                            HyperCheckoutLite.openPaymentPage(CheckoutActivity.this, sdkPayload, createHyperPaymentsCallbackAdapter());
                            // block:end:openPaymentPage
                            new Helper().showSnackbar("Opening Payment Page", coordinatorLayout);
                        }
                    });
                } catch (Exception e) {
                    Log.d("EXCEPTATION:", e.toString());
                    new Helper().showSnackbar("Unable to parse sdkPayload from response", coordinatorLayout);
                }
            }

            @Override
            public void onFailure(Exception e) {
                Log.d("EXCEPTATION: ", e.toString());
                new Helper().showSnackbar("Payment Initiation API Failed", coordinatorLayout);
            }
        });
        // block:end:sendPostRequest
    }
    // block:end:startPayment

    @Override
    protected void onPause() {
        super.onPause();
    }

    // block:start:create-hyper-callback
    private HyperPaymentsCallbackAdapter createHyperPaymentsCallbackAdapter() {
        return new HyperPaymentsCallbackAdapter() {
            @Override
            public void onEvent(JSONObject jsonObject, JuspayResponseHandler responseHandler) {
                Intent redirect = new Intent(CheckoutActivity.this, ResponsePage.class);
                try {
                    String event = jsonObject.getString("event");
                    if (event.equals("hide_loader")) {
                        // Hide Loader
                        runOnUiThread(() -> {
                            progressBar.setVisibility(View.GONE);
                        });
                    } else if (event.equals("process_result")) {
                        JSONObject innerPayload = jsonObject.optJSONObject("payload");
                        String status = innerPayload.optString("status");
                        switch (status) {
                            case "backpressed":
                            case "user_aborted":
                                // handle back

                                new Helper().showSnackbar("User Aborted", coordinatorLayout);
                                break;
                            default:
                                String orderId = jsonObject.getString("orderId");
                                redirect.putExtra("orderId", orderId);
                                startActivity(redirect);
                        }
                    }
                    // block:end:handle-process-result
                } catch (Exception e) {
                    // merchant code...
                }
            }
        };
    }
    // block:end:create-hyper-callback


    //    block:start:onBackPressed
    @Override
    public void onBackPressed() {
        if (!HyperCheckoutLite.onBackPressed()) {
            // Handle Backpress Here
            super.onBackPressed();
        }
    }
    //block:end:onBackPressed


    private void updatingUI() {
        coordinatorLayout = findViewById(R.id.coordinatorLayout);
        progressBar = findViewById(R.id.progressBar);
    }
}
