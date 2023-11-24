package in.juspay.devtools;

import androidx.appcompat.app.AppCompatActivity;
import androidx.constraintlayout.widget.ConstraintLayout;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.google.android.material.snackbar.Snackbar;

import org.json.JSONException;
import org.json.JSONObject;

public class ResponsePage extends AppCompatActivity {
    private ConstraintLayout constraintLayout;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_response_page);
        constraintLayout = findViewById(R.id.responsePageLayout);
    }

    @Override
    protected void onStart() {
        super.onStart();
        Intent i = getIntent();
        String orderId = i.getStringExtra("orderId");
        Button okay = findViewById(R.id.rectangle_12);

        // block:start:sendGetRequest
        ApiClient.sendGetRequest("http://10.0.2.2:5000/handleJuspayResponse?order_id="+orderId, new ApiClient.ApiResponseCallback() {
            @Override
            public void onResponseReceived(String response) throws JSONException {
                JSONObject orderStatusJsonObject = new JSONObject(response);
                String orderStatus = orderStatusJsonObject.getString("order_status");
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
                            case "PENDING_VBV":
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
                Log.d("EXCEPTATION: ", e.toString());
                Snackbar.make(constraintLayout, "Order Status API Failed", Snackbar.LENGTH_SHORT)
                        .show();
            }
        });
        // block:end:sendGetRequest

        ImageView back = findViewById(R.id.imageView1);
        back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
                Intent i = new Intent(ResponsePage.this, CheckoutActivity.class);
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
