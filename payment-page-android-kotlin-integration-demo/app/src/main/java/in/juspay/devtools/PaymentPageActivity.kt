package `in`.juspay.devtools

import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.ImageView
import android.widget.TextView
import androidx.annotation.RequiresApi
import androidx.appcompat.app.AppCompatActivity
import androidx.constraintlayout.widget.ConstraintLayout
import okhttp3.*
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import org.json.JSONObject
import java.io.IOException
import java.time.Instant
import java.util.*

class PaymentPageActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_payment_page);
    }

    @RequiresApi(Build.VERSION_CODES.O)
    override fun onStart() {
        super.onStart();
        val i = intent;
        val amount = i.getStringExtra("amount") as String;


        val sharedPref = applicationContext.getSharedPreferences("secrets", Context.MODE_PRIVATE)
        val currentTime: Instant = Instant.now()

        val clientAuthTokenExpiry = sharedPref.getString("clientAuthTokenExpiry", null);

        if(clientAuthTokenExpiry.isNullOrEmpty() || Instant.parse(clientAuthTokenExpiry).isBefore(currentTime)){
            createOrder(amount, sharedPref);
        }

        var backImage: ImageView = findViewById(R.id.imageView)
        backImage?.setOnClickListener(View.OnClickListener { onBackPressed() });


        var amountText: TextView = findViewById(R.id.amount_value)
        amountText.text = "₹ " + amount;

        var cardButton: ConstraintLayout = findViewById(R.id.cards_button)
        val function: (View) -> Unit = {
            val clientAuthToken = sharedPref.getString("clientAuthToken", "");
            if (clientAuthToken != null) {
                Log.d("ANURAG GOT SHARED", clientAuthToken)
            };
            if(clientAuthToken?.isNotEmpty() == true) {
                var i = Intent(this@PaymentPageActivity, CardsActivity::class.java)
                i.putExtra("clientAuthToken", clientAuthToken)
                startActivity(i);
            }
        }
        cardButton.setOnClickListener(function)

    }

        //Note: Session API must be called from merchant's server
        @RequiresApi(Build.VERSION_CODES.O)
        @Throws(IOException::class)
        fun createOrder(amountString: String, sharedPref: SharedPreferences) {
            val payload = JSONObject()
            val apiKey = "9E8BE20E66349BCA430C6FAC272B39"     //Put your API Key Here
            val merchantId = "picasso"     // Put your Merchant ID here
            val randomOrderId = (Math.random() * Math.pow(10.0, 12.0)).toLong()
            val orderId = "test-" + java.lang.Long.toString(randomOrderId)
            try {
                payload.put("order_id", orderId)
                payload.put("amount", amountString)          // Amount must be in string
                payload.put("options.get_client_auth_token", "true")
                payload.put("customer_id", "9876543201")        //Customer id should be in string
                payload.put("customer_email", "test@juspay.in")
                payload.put("customer_phone", "9876543201")     //Mobile number should be in string
            } catch (e: Exception) {
            }
            val client = OkHttpClient()
            val mediaType: MediaType? = "application/json".toMediaTypeOrNull()
            val requestBody: RequestBody = RequestBody.create(mediaType, payload.toString())
            val authorization = "Basic " + Base64.getEncoder().encodeToString(apiKey.toByteArray())
            val request: Request = Request.Builder()
                .url("https://sandbox.juspay.in/orders")
                .method("POST", requestBody)
                .addHeader("x-merchantid", merchantId)
                .addHeader("version", "2018-10-25")
                .addHeader("Authorization", authorization)
                .addHeader("Content-Type", "application/json")
                .build()
            // NOTE: DON'T COPY THIS CODE IN YOUR CLIENT APP
            // Juspay API should be called from your server, client app should only fetch the sdk_payload from your server
            client.newCall(request).enqueue(object : Callback {


                override fun onFailure(call: Call, e: IOException) {
                    call.cancel()
                }
                @Throws(IOException::class)
                override fun onResponse(call: Call, response: Response) {
                    try {
                        val processResponse: String = response.body?.string() ?: ""
                        val jsonObj = JSONObject(processResponse)
                        val juspayObj = jsonObj.getJSONObject("juspay")
                        val clientAuthToken = juspayObj.get("client_auth_token") as String;
                        val clientAuthTokenExpiry = juspayObj.get("client_auth_token_expiry") as String;

                        val editor = sharedPref.edit()
                        editor.putString("clientAuthToken", clientAuthToken);
                        editor.putString("clientAuthTokenExpiry", clientAuthTokenExpiry);
                        editor.apply()
                    } catch (e: Exception) {
                    }
                }
            })

    }
}