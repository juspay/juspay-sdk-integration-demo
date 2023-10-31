package in.juspay.devtools;

import androidx.appcompat.app.AppCompatActivity;
import androidx.coordinatorlayout.widget.CoordinatorLayout;

import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import in.juspay.hypersdk.data.JuspayResponseHandler;
import in.juspay.hypersdk.ui.HyperPaymentsCallbackAdapter;

import org.json.JSONException;
import org.json.JSONObject;
import okhttp3.*;
import java.io.IOException;
import in.juspay.hyperinteg.HyperServiceHolder;

public class CheckoutActivity extends AppCompatActivity {

    private Button processButton;
    private HyperServiceHolder hyperServicesHolder;
    private CoordinatorLayout coordinatorLayout;
    private ProgressDialog dialog;
    private String amountString;
    private int item1Price, item2Price, item1Count, item2Count;
    private TextView item1PriceTv, item2PriceTv, item1CountTv, item2CountTv, totalAmountTv, taxTv, totalPayableTv;
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

        hyperServicesHolder = new HyperServiceHolder(this);
        hyperServicesHolder.setCallback(createHyperPaymentsCallbackAdapter());
        processButton = findViewById(R.id.rectangle_9);
        processButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dialog.show();
                try{
                    openPaymentPage();
                } catch (Exception e){

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

        long randomOrderId = (long) (Math.random()*Math.pow(10,12));
        String order_id = "test-" + Long.toString(randomOrderId);    // Put you own order id here
        try{
            // You can put your payload details here
            payload.put("order_id", order_id);    // OrderID should be unique
            payload.put("amount", amountString);    // Amount should be in strings e.g. "100.00"
            payload.put("customer_id", "testing-customer-one");    // Customer ID should be unique for each user and should be a string
            payload.put("customer_email", "test@mail.com");
            payload.put("customer_phone", "9876543201");
            payload.put("action", "paymentPage");

            // For other payload params you can refer to the integration doc shared with you
        } catch (Exception e){
            Log.d("Juspay",e.toString());
        }

        ApiClient.sendPostRequest("http://10.0.2.2:5000/initiateJuspayPayment", payload, new ApiClient.ApiResponseCallback() {
            @Override
            public void onResponseReceived(String response) throws JSONException {
                try{
                    JSONObject sdkPayload = new JSONObject(response).getJSONObject("sdkPayload");
                    CheckoutActivity.this.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            new Helper().showSnackbar("Opening Payment Page", coordinatorLayout);
                            hyperServicesHolder.process(sdkPayload);
                        }
                    });
                } catch (Exception e){

                }
            }

            @Override
            public void onFailure(Exception e) {

            }
        });

        OkHttpClient client = new OkHttpClient();
        MediaType mediaType = MediaType.parse("application/json");
        RequestBody requestBody = RequestBody.create(payload.toString(), mediaType);
        Request request =
                new Request.Builder()
                        .url("http://10.0.2.2:5000/initiateJuspayPayment") //10.0.2.2 Works only on emulator
                        .method("POST", requestBody)
                        .build();
        client.newCall(request).enqueue(new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {
                call.cancel();
            }

            @Override
            public void onResponse(Call call, Response response) throws IOException {
                try{
                    //Fetching response from API Call
                    String processResponse = response.body().string();
                    JSONObject sdkPayload = new JSONObject(processResponse).getJSONObject("sdkPayload");
                    CheckoutActivity.this.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            new Helper().showSnackbar("Opening Payment Page", coordinatorLayout);
                            //block:start:process-sdk
                            hyperServicesHolder.process(sdkPayload);
                            //block:end:process-sdk
                        }
                    });
                } catch (Exception e){

                }
            }
        });
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
                        dialog.hide();
                    }
                    else if (event.equals("process_result")) {
                        String orderId = jsonObject.getString("orderId");
                        redirect.putExtra("orderId", orderId);
                        startActivity(redirect);
                    }
                    // block:end:handle-process-result
                } catch (Exception e) {
                    // merchant code...
                }
            }
        };
    }
    // block:end:create-hyper-callback



    //block:start:onBackPressed
    @Override
    public void onBackPressed() {
        boolean handleBackpress = hyperServicesHolder.onBackPressed();
        if(!handleBackpress) {
            super.onBackPressed();
        }
    }
    //block:end:onBackPressed



    private void updatingUI(){
        coordinatorLayout = findViewById(R.id.coordinatorLayout);
        dialog = new ProgressDialog(CheckoutActivity.this);
        dialog.setMessage("Processing...");

        Intent i = getIntent();
        item1Count = i.getIntExtra("item1Count", 1);
        item2Count = i.getIntExtra("item2Count", 1);
        item1Price = i.getIntExtra("item1Price", 1);
        item2Price = i.getIntExtra("item2Price", 1);

        item1PriceTv = findViewById(R.id.some_id1);
        item2PriceTv = findViewById(R.id.some_id2);
        item1CountTv = findViewById(R.id.x2);
        item2CountTv = findViewById(R.id.x3);

        item1CountTv.setText("x"+Integer.toString(item1Count));
        item2CountTv.setText("x"+Integer.toString(item2Count));
        int item1Amount = item1Price*item1Count;
        int item2Amount = item2Price*item2Count;
        item1PriceTv.setText("₹ "+Integer.toString(item1Amount));
        item2PriceTv.setText("₹ "+Integer.toString(item2Amount));

        totalAmountTv = findViewById(R.id.some_id);
        taxTv = findViewById(R.id.some_id3);
        totalPayableTv = findViewById(R.id.some_id5);

        int totalAmount = item1Amount + item2Amount;
        double tax = totalAmount * taxPercent;
        double totalPayable = totalAmount + tax;
        Helper helper = new Helper();
        amountString = Double.toString(helper.round(totalPayable, 2));
        String taxString = Double.toString(helper.round(tax, 2));
        totalAmountTv.setText("₹ "+Integer.toString(totalAmount));
        taxTv.setText("₹ "+taxString);
        totalPayableTv.setText("₹ "+amountString);
    }

    /*
    Optional Block
    These functions are only supposed to be implemented in case if you are overriding
    onActivityResult or onRequestPermissionsResult Life cycle hooks


    - onActivityResult
    - Handling onActivityResult hook and passing data to HyperServices Instance, to handle App Switch
    @Override
    public void onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        // block:start:onActivityResult

        // If super.onActivityResult is available use following:
        // super.onActivityResult(requestCode, resultCode, data);

        // In case super.onActivityResult is NOT available please use following:
        // if (data != null) {
        //    hyperServices.onActivityResult(requestCode, resultCode, data);
        // }

        // block:end:onActivityResult

        // Rest of your code.
    }


    - onRequestPermissionsResult
    - Handling onRequestPermissionsResult hook and passing data to HyperServices Instance, to OTP reading permissions
    @Override
    public void onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        // block:start:onRequestPermissionsResult

        //  If super.onRequestPermissionsResult is available use following:
        // super.onRequestPermissionsResult(requestCode, permissions, grantResults);

        // In case super.onActivityResult is NOT available please use following:
        // hyperServices.onRequestPermissionsResult(requestCode, permissions, grantResults);

        // block:end:onRequestPermissionsResult
    }
     */
}
