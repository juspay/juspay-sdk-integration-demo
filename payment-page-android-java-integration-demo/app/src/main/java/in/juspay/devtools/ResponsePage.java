package in.juspay.devtools;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

public class ResponsePage extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_response_page);
    }

    @Override
    protected void onStart() {
        super.onStart();
        Intent i = getIntent();
        String status = i.getStringExtra("status");


        ImageView statusIcon = findViewById(R.id.checked_1);
        TextView statusText = findViewById(R.id.payment_suc);
        Button okay = findViewById(R.id.rectangle_12);
        if(status.equals("OrderSuccess")){
            statusIcon.setImageDrawable(getResources().getDrawable(R.drawable.payment_success));
            statusText.setText("Payment Successful!");
        } else if (status.equals("CODInitiated")){
            statusIcon.setImageDrawable(getResources().getDrawable(R.drawable.cod_initiated));
            statusText.setText("COD Initiated!");
        } else if(status.equals("PendingVBV")) {
            statusIcon.setImageDrawable(getResources().getDrawable(R.drawable.pending));
            statusText.setText("Payment Pending...");
        }
        else {
            statusIcon.setImageDrawable(getResources().getDrawable(R.drawable.payment_failed));
            statusText.setText("Payment Failed!");
            okay.setText("Retry");
        }


        okay.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(status.equals("OrderSuccess") || status.equals("CODInitiated")) {
                    finishAffinity();
                    System.exit(0);
                } else {
                    finish();
                }
            }
        });

        ImageView back = findViewById(R.id.imageView1);
        back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
                Intent i = new Intent(ResponsePage.this, ProductsActivity.class);
                startActivity(i);
            }
        });
    }


//    private void getOrderStatus() throws IOException {
//        JSONObject payload = new JSONObject();
//        // API Key Should never be used from client side, it should always be stored securely on server.
//        // And all the API calls requiring API key should always be done from server
//        String apiKey = "<YOUR_API_KEY>";  //Put your API Key Here
//        String clientId = "<CLIENT_ID>";  // Put your clientID here
//        String merchantId = "<MERCHANT_ID>";   // Put your merchant ID here
//
//        long randomOrderId = (long) (Math.random()*Math.pow(10,12));
//        String order_id = "test-" + Long.toString(randomOrderId);    // Put you own order id here
//        try{
//            // You can put your payload details here
//            payload.put("order_id", order_id);    // OrderID should be unique
//            payload.put("amount", amountString);    // Amount should be in strings e.g. "100.00"
//            payload.put("customer_id", "9876543201");    // Customer ID should be unique for each user and should be a string
//            payload.put("customer_email", "test@mail.com");
//            payload.put("customer_phone", "9876543201");
//            payload.put("payment_page_client_id", clientId);
//            payload.put("action", "paymentPage");
//            payload.put("first_name", "john");
//            payload.put("last_name", "wick");
//            payload.put("description", "Order Description");
//            payload.put("return_url", "<REDIRECT_URL>");
//
//            // For other payload params you can refer to the integration doc shared with you
//        } catch (Exception e){
//
//        }
//
//
//        OkHttpClient client = new OkHttpClient();
//
//        MediaType mediaType = MediaType.parse("application/json");
//        RequestBody requestBody = RequestBody.create(mediaType, payload.toString());
//        String authorization = "Basic " + Base64.getEncoder().encodeToString(apiKey.getBytes());
//        Request request =
//                new Request.Builder()
//                        .url("https://api.juspay.in/orders/"+ orderId)
//                        .method("GET", requestBody)
//                        .addHeader("x-merchantid", merchantId)
//                        .addHeader("Authorization", authorization)
//                        .addHeader("Content-Type", "application/x-www-form-urlencoded")
//                        .build();
//
//        // Note: Session API should only be called from merchant's server. Don't call it from client app
//        client.newCall(request).enqueue(new Callback() {
//            @Override
//            public void onFailure(Call call, IOException e) {
//                call.cancel();
//            }
//
//            @Override
//            public void onResponse(Call call, Response response) throws IOException {
//                try{
//                    String processResponse = response.body().string();
//
//                    JSONObject jsonObj = new JSONObject(processResponse);
//                    JSONObject sdkPayload = jsonObj.getJSONObject("sdk_payload");
//
//                    CheckoutActivity.this.runOnUiThread(new Runnable() {
//                        @Override
//                        public void run() {
//                            startPayments(sdkPayload);
//                        }
//                    });
//                } catch (Exception e){
//
//                }
//            }
//        });
//    }
}