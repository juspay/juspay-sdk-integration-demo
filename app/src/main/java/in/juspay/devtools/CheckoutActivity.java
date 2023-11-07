package in.juspay.devtools;

import androidx.appcompat.app.AppCompatActivity;
import androidx.coordinatorlayout.widget.CoordinatorLayout;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;

import in.juspay.hypercheckoutlite.HyperCheckoutLite;
import in.juspay.hypersdk.data.JuspayResponseHandler;
import in.juspay.hypersdk.ui.HyperPaymentsCallbackAdapter;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;

public class CheckoutActivity extends AppCompatActivity {
    private Button processButton;
    private CoordinatorLayout coordinatorLayout;
    private String amountString;
    private int item1Price, item2Price, item1Count, item2Count;
    private TextView item1PriceTv, item2PriceTv, item1CountTv, item2CountTv, totalAmountTv, taxTv, totalPayableTv;
    private ProgressBar progressBar;
    private double taxPercent = 0.18;
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
                    openPaymentPage();
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

    private void openPaymentPage() throws IOException {
        JSONObject payload = new JSONObject();

        long randomOrderId = (long) (Math.random() * Math.pow(10, 12));
        String order_id = "test-" + randomOrderId;    // Put you own order id here
        try {
            // You can put your payload details here
            payload.put("order_id", order_id);    // OrderID should be unique
            payload.put("amount", amountString);    // Amount should be in strings e.g. "100.00"

            // For other payload params you can refer to the integration doc shared with you
        } catch (Exception e) {
            Log.d("EXCEPTATION: ", e.toString());
        }

        ApiClient.sendPostRequest("http://10.0.2.2:5000/initiateJuspayPayment", payload, new ApiClient.ApiResponseCallback() {
            @Override
            public void onResponseReceived(String response) throws JSONException {
                try {
                    JSONObject sdkPayload = new JSONObject(response).getJSONObject("sdkPayload");
                    CheckoutActivity.this.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            HyperCheckoutLite.openPaymentPage(CheckoutActivity.this, sdkPayload, createHyperPaymentsCallbackAdapter());
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
    }

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
        Intent i = getIntent();
        item1Count = i.getIntExtra("item1Count", 1);
        item2Count = i.getIntExtra("item2Count", 1);
        item1Price = i.getIntExtra("item1Price", 1);
        item2Price = i.getIntExtra("item2Price", 1);

        item1PriceTv = findViewById(R.id.some_id1);
        item2PriceTv = findViewById(R.id.some_id2);
        item1CountTv = findViewById(R.id.x2);
        item2CountTv = findViewById(R.id.x3);


        item1CountTv.setText("x" + Integer.toString(item1Count));
        item2CountTv.setText("x" + Integer.toString(item2Count));
        int item1Amount = item1Price * item1Count;
        int item2Amount = item2Price * item2Count;
        item1PriceTv.setText("₹ " + Integer.toString(item1Amount));
        item2PriceTv.setText("₹ " + Integer.toString(item2Amount));

        totalAmountTv = findViewById(R.id.some_id);
        taxTv = findViewById(R.id.some_id3);
        totalPayableTv = findViewById(R.id.some_id5);

        int totalAmount = item1Amount + item2Amount;
        double tax = totalAmount * taxPercent;
        double totalPayable = totalAmount + tax;
        Helper helper = new Helper();
        amountString = Double.toString(helper.round(totalPayable, 2));
        String taxString = Double.toString(helper.round(tax, 2));
        totalAmountTv.setText("₹ " + Integer.toString(totalAmount));
        taxTv.setText("₹ " + taxString);
        totalPayableTv.setText("₹ " + amountString);
    }
}
