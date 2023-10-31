package in.juspay.devtools;

import androidx.appcompat.app.AppCompatActivity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;



public class ProductsActivity extends AppCompatActivity {
    private Button proceedButton;
    private TextView itemCountTv1, itemCountTv2;
    private int item1Count = 1, item2Count = 0, item1Price = 1, item2Price = 1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_products);
    }

    @Override
    protected void onStart() {
        super.onStart();
        prepareUI();
    }
    private void prepareUI(){
        proceedButton = findViewById(R.id.rectangle_8);
        itemCountTv1 = findViewById(R.id.some_id);
        itemCountTv2 = findViewById(R.id.some_id2);
        proceedButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(item1Count>=1 || item2Count >=1){
                    Intent intent = new Intent(ProductsActivity.this, CheckoutActivity.class);
                    intent.putExtra("item1Count", item1Count);
                    intent.putExtra("item2Count", item2Count);
                    intent.putExtra("item1Price", item1Price);
                    intent.putExtra("item2Price", item2Price);
                    startActivity(intent);
                } else {
                    Toast.makeText(ProductsActivity.this, "You should add atlease one item", Toast.LENGTH_SHORT).show();
                }
            }
        });
    }
    public void add1Clicked(View v){
        item1Count += 1;
        itemCountTv1.setText(Integer.toString(item1Count));
    }
    public void add2Clicked(View v){
        item2Count += 1;
        itemCountTv2.setText(Integer.toString(item2Count));

    }
    public void remove1Clicked(View v){
        if(item1Count<1){
            Toast.makeText(this, "Cannot remove as item count is already 0.", Toast.LENGTH_SHORT).show();
        } else {
            item1Count -= 1;
            itemCountTv1.setText(Integer.toString(item1Count));
        }
    }
    public void remove2Clicked(View v){
        if(item2Count<1){
            Toast.makeText(this, "Cannot remove as item count is already 0.", Toast.LENGTH_SHORT).show();
        } else {
            item2Count -= 1;
            itemCountTv2.setText(Integer.toString(item2Count));
        }
    }
}
