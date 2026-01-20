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
        } else {
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
}