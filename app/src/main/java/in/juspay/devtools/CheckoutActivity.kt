package `in`.juspay.devtools

import android.app.ProgressDialog
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity
import androidx.coordinatorlayout.widget.CoordinatorLayout
import `in`.juspay.hypercheckoutlite.HyperCheckoutLite
import `in`.juspay.hypersdk.data.JuspayResponseHandler
import `in`.juspay.hypersdk.ui.HyperPaymentsCallbackAdapter
import org.json.JSONObject

class CheckoutActivity : AppCompatActivity() {
    private lateinit var proceedButton: Button
    private lateinit var dialog: ProgressDialog
    private lateinit var coordinatorLayout: CoordinatorLayout
    private var orderId: String? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_products)
    }

    override fun onStart() {
        super.onStart()
        coordinatorLayout = findViewById(R.id.coordinatorLayout2)
        dialog = ProgressDialog(this@CheckoutActivity)
        dialog.setMessage("Processing...")
        proceedButton = findViewById(R.id.rectangle_8)
        proceedButton.setOnClickListener {
            dialog.show()
            try {
                startPayment()
            } catch (e: Exception) {
            }
        }
    }

    override fun onBackPressed() {
        val handleBackpress = HyperCheckoutLite.onBackPressed()
        if (!handleBackpress) {
            super.onBackPressed()
        }
    }

    private fun startPayment() {
        var payload = JSONObject();
        var itemDetail1 = JSONObject();
        itemDetail1.put("item_id", "12345");
        itemDetail1.put("quantity", 2);

        var itemDetail2 = JSONObject();
        itemDetail2.put("item_id", "54321");
        itemDetail2.put("quantity", 2);

        val itemDetails = arrayOf(itemDetail1, itemDetail2);
        payload.put("item_details", itemDetails);


        ApiClient.sendPostRequest("http://10.0.2.2:5000/initiateJuspayPayment", payload, object : ApiClient.ApiResponseCallback {
            override fun onResponseReceived(response: String?) {
                try {
                    val sdkPayload = JSONObject(response).getJSONObject("sdkPayload")
                    try {
                        orderId = JSONObject(response).getString("orderId")
                    }catch (e: Exception) {
                        Log.d("ERROR>>>", e.toString())
                    }
                    orderId = JSONObject(response).getString("orderId")
                    runOnUiThread {
                        HyperCheckoutLite.openPaymentPage(this@CheckoutActivity, sdkPayload, createHyperPaymentsCallbackAdapter())
                    }
                } catch (e: Exception) {
                    Log.d("ERROR>>>", e.toString())
                }
            }

            override fun onFailure(e: Exception?) {

            }
        })
    }

    private fun createHyperPaymentsCallbackAdapter(): HyperPaymentsCallbackAdapter {
        return object : HyperPaymentsCallbackAdapter() {
            override fun onEvent(jsonObject: JSONObject, responseHandler: JuspayResponseHandler) {
                val redirect = Intent(this@CheckoutActivity, ResponsePage::class.java)
                try {
                    val event = jsonObject.getString("event")
                    when (event) {
                        "hide_loader" -> {
                            // Hide Loader
                            dialog.hide()
                        }
                        "process_result" -> {
                            val innerPayload = jsonObject.optJSONObject("payload")
                            val status = innerPayload?.optString("status")
                            when (status) {
                                "backpressed", "user_aborted" -> {
                                    redirect.putExtra("orderId", orderId)
                                    startActivity(redirect)
                                }
                                else -> {
                                    redirect.putExtra("orderId", orderId)
                                    startActivity(redirect)
                                }
                            }
                        }
                    }
                } catch (e: Exception) {
                    // merchant code...
                }
            }
        }
    }
}
