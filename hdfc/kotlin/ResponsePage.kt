package `in`.juspay.devtools

import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import org.json.JSONObject
import androidx.appcompat.app.AppCompatActivity
import androidx.constraintlayout.widget.ConstraintLayout
import com.google.android.material.snackbar.Snackbar

class ResponsePage : AppCompatActivity() {
    private lateinit var constraintLayout: ConstraintLayout
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_response_page)
        constraintLayout = findViewById(R.id.responsePageLayout);
    }

    override fun onStart() {
        super.onStart()
        val i = intent
        val orderId = i.getStringExtra("orderId")
        val okay = findViewById<Button>(R.id.rectangle_12)
        
        // block:start:sendGetRequest
        ApiClient.sendGetRequest("http://10.0.2.2:5000/handleJuspayResponse?order_id=$orderId", object : ApiClient.ApiResponseCallback {
            override fun onResponseReceived(response: String?) {
                val orderStatusJsonObject = JSONObject(response)
                val orderStatus = orderStatusJsonObject.getString("order_status")
                val message = orderStatusJsonObject.getString("message")

                    when (orderStatus) {
                        "CHARGED" -> // Create and Display UI for Payment Success Screen
                        "PENDING_VBV" -> // Create and Display UI for Payment Pending Screen
                        else -> // Create and Display UI for Payment Failure Screen
                    }
                }
            }
            // block:end:sendGetRequest
            
            override fun onFailure(e: Exception?) {
                // Handle the failure here, e contains information about the error
                Log.d("EXCEPTION: ", e.toString())
                Snackbar.make(constraintLayout, "Order Status API Failed", Snackbar.LENGTH_LONG)
            }
        })
        

        val back = findViewById<ImageView>(R.id.imageView1)
        back.setOnClickListener {
            finish()
            val i = Intent(this@ResponsePage, ProductsActivity::class.java)
            startActivity(i)
        }

        okay.setOnClickListener {
            finishAffinity()
            System.exit(0)
        }
    }
}
