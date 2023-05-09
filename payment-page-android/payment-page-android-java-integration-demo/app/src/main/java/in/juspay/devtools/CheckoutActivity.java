package in.juspay.devtools;

import androidx.appcompat.app.AppCompatActivity;
import androidx.coordinatorlayout.widget.CoordinatorLayout;

import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import in.juspay.hypersdk.data.JuspayResponseHandler;
import in.juspay.hypersdk.ui.HyperPaymentsCallbackAdapter;
import org.json.JSONObject;
import okhttp3.*;
import java.io.IOException;
import java.util.Base64;
import android.webkit.WebView;

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

        updatingUI();

        hyperServicesHolder = new HyperServiceHolder(this);
        hyperServicesHolder.setCallback(createHyperPaymentsCallbackAdapter());
        processButton = findViewById(R.id.rectangle_9);
        processButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                dialog.show();
                try{
                    run();
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

    //block:start:process-sdk
    private void startPayments(JSONObject sdk_payload) {
        // Make sure to use the same hyperServices instance which was created in
        // ProductsActivity.java

        Helper helper = new Helper();
        helper.showSnackbar("Process Called!", coordinatorLayout);
        hyperServicesHolder.process(sdk_payload);

    }
    //block:end:process-sdk

    // block:start:fetch-process-payload
    // Note: Session API should only be called from merchant's server. Don't call it from client app
    private void run() throws IOException {
        JSONObject payload = new JSONObject();
        String apiKey = "<API_KEY>";  //Put your API Key Here
        String clientId = "<CLIENT_ID";  // Put your clientID here 
        String merchantId = "<MERCHANT_ID>";   // Put your merchant ID here

        long randomOrderId = (long) (Math.random()*Math.pow(10,12)); 
        String order_id = "test-" + Long.toString(randomOrderId);    // Put you own order id here
        try{
            // You can put your payload details here
            payload.put("order_id", order_id);    // OrderID should be unique
            payload.put("amount", amountString);    // Amount should be in strings e.g. "100.00"
            payload.put("customer_id", "9876543201");    // Customer ID should be unique for each user and should be a string
            payload.put("customer_email", "test@mail.com");
            payload.put("customer_phone", "9876543201");
            payload.put("payment_page_client_id", clientId);
            payload.put("action", "paymentPage");
            payload.put("first_name", "john");
            payload.put("last_name", "wick");
            payload.put("description", "Order Description");

            // For other payload params you can refer to the integration doc shared with you
        } catch (Exception e){

        }


        OkHttpClient client = new OkHttpClient();

        MediaType mediaType = MediaType.parse("application/json");
        RequestBody requestBody = RequestBody.create(mediaType, payload.toString());
        String authorization = "Basic " + Base64.getEncoder().encodeToString(apiKey.getBytes());
        Request request =
                new Request.Builder()
                        .url("https://api.juspay.in/session")
                        .method("POST", requestBody)
                        .addHeader("x-merchantid", merchantId)
                        .addHeader("Authorization", authorization)
                        .addHeader("Content-Type", "application/json")
                        .build();

        // Note: Session API should only be called from merchant's server. Don't call it from client app
        client.newCall(request).enqueue(new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {
                call.cancel();
            }

            @Override
            public void onResponse(Call call, Response response) throws IOException {
                try{
                    String processResponse = response.body().string();

                    JSONObject jsonObj = new JSONObject(processResponse);
                    JSONObject sdkPayload = jsonObj.getJSONObject("sdk_payload");

                    CheckoutActivity.this.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            startPayments(sdkPayload);
                        }
                    });
                } catch (Exception e){

                }
            }
        });
    }
    // block:end:fetch-process-payload

    // block:start:create-hyper-callback
    private HyperPaymentsCallbackAdapter createHyperPaymentsCallbackAdapter() {
        return new HyperPaymentsCallbackAdapter() {
            @Override
            public void onEvent(JSONObject jsonObject, JuspayResponseHandler responseHandler) {
                Intent redirect = new Intent(CheckoutActivity.this, ResponsePage.class);
                redirect.putExtra("responsePayload", jsonObject.toString());
                System.out.println(jsonObject);
                try {
                    String event = jsonObject.getString("event");
                    if (event.equals("hide_loader")) {
                        // Hide Loader
                        dialog.hide();
                    }
                    // Handle Process Result
                    // This case will reach once payment page closes
                    // block:start:handle-process-result
                    else if (event.equals("process_result")) {
                        boolean error = jsonObject.optBoolean("error");
                        JSONObject innerPayload = jsonObject.optJSONObject("payload");
                        String status = innerPayload.optString("status");

                        if (!error) {
                            switch (status) {
                                case "charged":
                                    // Successful Transaction
                                    // check order status via S2S API
                                    redirect.putExtra("status", "OrderSuccess");
                                    startActivity(redirect);
                                    break;
                                case "cod_initiated":
                                    redirect.putExtra("status", "CODInitiated");
                                    startActivity(redirect);
                                    break;
                            }
                        } else {
                            switch (status) {
                                case "backpressed":
                                    // user back-pressed from PP without initiating transaction

                                    break;
                                case "user_aborted":
                                    // user initiated a txn and pressed back
                                    // check order status via S2S API
                                    Intent successIntent = new Intent(CheckoutActivity.this, ResponsePage.class);
                                    redirect.putExtra("status", "UserAborted");
                                    startActivity(redirect);
                                    break;
                                case "pending_vbv":
                                    redirect.putExtra("status", "PendingVBV");
                                    startActivity(redirect);
                                    break;
                                case "authorizing":
                                    // txn in pending state
                                    // check order status via S2S API
                                    redirect.putExtra("status", "Authorizing");
                                    startActivity(redirect);
                                    break;
                                case "authorization_failed":
                                    redirect.putExtra("status", "AuthorizationFailed");
                                    startActivity(redirect);
                                    break;
                                case "authentication_failed":
                                    redirect.putExtra("status", "AuthenticationFailed");
                                    startActivity(redirect);
                                    break;
                                case "api_failure":
                                    redirect.putExtra("status", "APIFailure");
                                    startActivity(redirect);
                                    break;
                                    // txn failed
                                    // check order status via S2S API
                            }
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



    //block:start:onBackPressed
    @Override
    public void onBackPressed() {
        boolean handleBackpress = hyperServicesHolder.handleBackPress();
        if(handleBackpress) {
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
