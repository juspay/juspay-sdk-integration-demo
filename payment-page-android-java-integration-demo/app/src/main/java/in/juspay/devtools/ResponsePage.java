package in.juspay.devtools;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import org.json.JSONException;
import org.json.JSONObject;

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
        String orderId = i.getStringExtra("orderId");
        Button okay = findViewById(R.id.rectangle_12);

        ApiClient.sendGetRequest("http://10.0.2.2:5000/handleJuspayResponse?order_id="+orderId, new ApiClient.ApiResponseCallback() {
            @Override
            public void onResponseReceived(String response) throws JSONException {
                Log.d("RESPP>>>", response);
                JSONObject orderStatusJsonObject = new JSONObject(response);
                String orderStatus = orderStatusJsonObject.getString("order_status");
                Log.d("STATUS>>>", orderStatus);
                String message = orderStatusJsonObject.getString("message");
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        TextView statusText = findViewById(R.id.payment_suc);
                        statusText.setText(message);
                        ImageView statusIcon = findViewById(R.id.checked_1);

                        switch (orderStatus) {
                            case "CHARGED":
                                statusIcon.setImageDrawable(getResources().getDrawable(R.drawable.payment_success));
                                break;
                            case "PENDING":
                                statusIcon.setImageDrawable(getResources().getDrawable(R.drawable.pending));
                                break;
                            default:
                                statusIcon.setImageDrawable(getResources().getDrawable(R.drawable.payment_failed));
                                break;
                        }
                    }
                });
            }

            @Override
            public void onFailure(Exception e) {
                // Handle the failure here, e contains information about the error
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

        okay.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finishAffinity();
                System.exit(0);
            }
        });
    }
}