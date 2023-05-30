package `in`.juspay.devtools

import `in`.juspay.hypersdk.data.JuspayResponseHandler
import `in`.juspay.hypersdk.ui.HyperPaymentsCallbackAdapter
import android.app.ProgressDialog
import android.content.Intent
import android.os.Bundle
import android.view.View
import android.webkit.WebView
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.coordinatorlayout.widget.CoordinatorLayout
import com.google.android.material.snackbar.Snackbar
import `in`.juspay.hyperinteg.HyperServiceHolder
import okhttp3.*
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import org.json.JSONObject
import java.io.IOException
import java.util.*

class CheckoutActivity : AppCompatActivity() {
    var processButton: Button? = null
    var hyperServicesHolder: HyperServiceHolder? = null
    var coordinatorLayout: CoordinatorLayout? = null
    var dialog: ProgressDialog? = null
    var amountString: String? = null
    var item1Price = 0
    var item2Price = 0
    var item1Count = 0
    var item2Count = 0
    var item1PriceTv: TextView? = null
    var item2PriceTv: TextView? = null
    var item1CountTv: TextView? = null
    var item2CountTv: TextView? = null
    var totalAmountTv: TextView? = null
    var taxTv: TextView? = null
    var totalPayableTv: TextView? = null
    var taxPercent = 0.18
    var backImage: ImageView? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_checkout)
    }

    override fun onStart() {
        super.onStart()
        updatingUI()
        hyperServicesHolder = HyperServiceHolder(this)
        hyperServicesHolder!!.setCallback(createHyperPaymentsCallbackAdapter())
        processButton = findViewById(R.id.rectangle_9)
        processButton?.setOnClickListener(View.OnClickListener {
            dialog!!.show()
            try {
                run()
            } catch (e: Exception) {
            }
        })
        backImage = findViewById(R.id.imageView)
        backImage?.setOnClickListener(View.OnClickListener { onBackPressed() })
    }
    
    // Calling process on hyperService to open the Hypercheckout screen
    // block:start:process-sdk
    fun startPayments(sdk_payload: JSONObject?) {
        // Make sure to use the same hyperServices instance which was created in
        // ProductsActivity.java
        showSnackbar("Process Called!")
        hyperServicesHolder?.process(sdk_payload)
    }
    // block:end:process-sdk

    //block:start:fetch-process-payload

    //Note: Session API must be called from merchant's server
    @Throws(IOException::class)
    fun run() {
        val payload = JSONObject()
        val apiKey = "<API_KEY>"     //Put your API Key Here
        val clientId = "<CLIENT_ID>"    //Put your Client ID here
        val merchantId = "<MERCHANT_ID>"     // Put your Merchant ID here
        val randomOrderId = (Math.random() * Math.pow(10.0, 12.0)).toLong()
        val order_id = "test-" + java.lang.Long.toString(randomOrderId)
        try {
            payload.put("order_id", order_id)
            payload.put("amount", amountString)          // Amount must be in string
            payload.put("customer_id", "9876543201")        //Customer id should be in string
            payload.put("customer_email", "test@mail.com")
            payload.put("customer_phone", "9876543201")     //Mobile number should be in string
            payload.put("payment_page_client_id", clientId)
            payload.put("action", "paymentPage")
            payload.put("offer_code", "testingCode")
            payload.put("first_name", "john")
            payload.put("last_name", "wick")
            payload.put("description", "Order Description")
        } catch (e: Exception) {
        }
        val client = OkHttpClient()
        val mediaType: MediaType? = "application/json".toMediaTypeOrNull()
        val requestBody: RequestBody = RequestBody.create(mediaType, payload.toString())
        val authorization = "Basic " + Base64.getEncoder().encodeToString(apiKey.toByteArray())
        val request: Request = Request.Builder()
            .url("https://api.juspay.in/session")
            .method("POST", requestBody)
            .addHeader("x-merchantid", merchantId)
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
                    val sdkPayload = jsonObj.getJSONObject("sdk_payload")
                    runOnUiThread { startPayments(sdkPayload) }
                } catch (e: Exception) {
                }
            }
        })
    }
    //block:end:fetch-process-payload

    //block:start:create-hyper-callback
    private fun createHyperPaymentsCallbackAdapter(): HyperPaymentsCallbackAdapter {
        return object : HyperPaymentsCallbackAdapter() {
            override fun onEvent(jsonObject: JSONObject, responseHandler: JuspayResponseHandler?) {
                val redirect = Intent(this@CheckoutActivity, ResponsePage::class.java)
                redirect.putExtra("responsePayload", jsonObject.toString())
                try {
                    val event = jsonObject.getString("event")
                    if (event == "hide_loader") {
                        // Hide Loader
                        dialog!!.hide()
                    } else if (event == "process_result") {
                        //block:start:handle-process-result
                        val error = jsonObject.optBoolean("error")
                        val innerPayload = jsonObject.optJSONObject("payload")
                        val status = innerPayload.optString("status")
                        if (!error) {
                            when (status) {
                                "charged" -> {
                                    // Successful Transaction
                                    // check order status via S2S API
                                    redirect.putExtra("status", "OrderSuccess")
                                    startActivity(redirect)
                                }
                                "cod_initiated" -> {
                                    redirect.putExtra("status", "CODInitiated")
                                    startActivity(redirect)
                                }
                            }
                        } else {
                            when (status) {
                                "backpressed" -> {
                                }
                                "user_aborted" -> {
                                    // user initiated a txn and pressed back
                                    // check order status via S2S API
                                    val successIntent = Intent(
                                        this@CheckoutActivity,
                                        ResponsePage::class.java
                                    )
                                    redirect.putExtra("status", "UserAborted")
                                    startActivity(redirect)
                                }
                                "pending_vbv" -> {
                                    redirect.putExtra("status", "PendingVBV")
                                    startActivity(redirect)
                                }
                                "authorizing" -> {
                                    // txn in pending state
                                    // check order status via S2S API
                                    redirect.putExtra("status", "Authorizing")
                                    startActivity(redirect)
                                }
                                "authorization_failed" -> {
                                    redirect.putExtra("status", "AuthorizationFailed")
                                    startActivity(redirect)
                                }
                                "authentication_failed" -> {
                                    redirect.putExtra("status", "AuthenticationFailed")
                                    startActivity(redirect)
                                }
                                "api_failure" -> {
                                    redirect.putExtra("status", "APIFailure")
                                    startActivity(redirect)
                                }
                            }
                        }
                        // block:end:handle-process-result
                    }
                } catch (e: Exception) {
                    // merchant code...
                }
            }
        }
    }

    // block:end:create-hyper-callback
    fun showSnackbar(message: String?) {
        coordinatorLayout = findViewById(R.id.coordinatorLayout)
        val snackbar = Snackbar.make(coordinatorLayout!!, message!!, Snackbar.LENGTH_LONG)
        snackbar.show()
    }

    //block:start:onBackPressed
    override fun onBackPressed() {
        val handleBackpress: Boolean = hyperServicesHolder?.onBackPressed() == true
        if (handleBackpress) {
            super.onBackPressed()
        }
    }

    //block:end:onBackPressed
    
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

    fun updatingUI() {
        dialog = ProgressDialog(this@CheckoutActivity)
        dialog!!.setMessage("Processing...")
        val i = intent
        item1Count = i.getIntExtra("item1Count", 1)
        item2Count = i.getIntExtra("item2Count", 1)
        item1Price = i.getIntExtra("item1Price", 1)
        item2Price = i.getIntExtra("item2Price", 1)
        item1PriceTv = findViewById(R.id.some_id1)
        item2PriceTv = findViewById(R.id.some_id2)
        item1CountTv = findViewById(R.id.x2)
        item2CountTv = findViewById(R.id.x3)
        item1CountTv?.setText("x" + Integer.toString(item1Count))
        item2CountTv?.setText("x" + Integer.toString(item2Count))
        val item1Amount = item1Price * item1Count
        val item2Amount = item2Price * item2Count
        item1PriceTv?.setText("₹ " + Integer.toString(item1Amount))
        item2PriceTv?.setText("₹ " + Integer.toString(item2Amount))
        totalAmountTv = findViewById(R.id.some_id)
        taxTv = findViewById(R.id.some_id3)
        totalPayableTv = findViewById(R.id.some_id5)
        val totalAmount = item1Amount + item2Amount
        val tax = totalAmount * taxPercent
        val totalPayable = totalAmount + tax
        amountString = java.lang.Double.toString(round(totalPayable, 2))
        val taxString = java.lang.Double.toString(round(tax, 2))
        totalAmountTv?.setText("₹ " + Integer.toString(totalAmount))
        taxTv?.setText("₹ $taxString")
        totalPayableTv?.setText("₹ $amountString")
    }

    companion object {
        fun round(value: Double, places: Int): Double {
            var value = value
            require(places >= 0)
            val factor = Math.pow(10.0, places.toDouble()).toLong()
            value = value * factor
            val tmp = Math.round(value)
            return tmp.toDouble() / factor
        }
    }
}
