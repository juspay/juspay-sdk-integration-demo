package `in`.bharatpex.devtools

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.coordinatorlayout.widget.CoordinatorLayout
import com.google.android.material.snackbar.Snackbar
import `in`.bharatpex.hyperinteg.BharatPeXPaymentServiceHolder
import `in`.bharatpex.bharatpexpaymentsdksdk.data.BharatPeXResponseHandler
import `in`.bharatpex.bharatpexpaymentsdksdk.ui.BharatPeXPaymentsCallbackAdapter
import org.json.JSONObject
import java.util.*

class ProductsActivity : AppCompatActivity() {
    var proceedButton: Button? = null
    var itemCountTv1: TextView? = null
    var itemCountTv2: TextView? = null
    var bharatpexPaymentServicesHolder: BharatPeXPaymentServiceHolder? = null
    var initiatePayload: JSONObject? = null
    var coordinatorLayout: CoordinatorLayout? = null
    var item1Count = 1
    var item2Count = 0
    var item1Price = 1
    var item2Price = 1
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_products)
    }

    override fun onStart() {
        super.onStart()
        //block:start:create-bharatpexPayment-services-instance

        bharatpexPaymentServicesHolder = BharatPeXPaymentServiceHolder(this)
        
        //block:end:create-bharatpexPayment-services-instance
        
        initiatePaymentsSDK()
        proceedButton = findViewById(R.id.rectangle_8)
        itemCountTv1 = findViewById(R.id.some_id)
        itemCountTv2 = findViewById(R.id.some_id2)
        proceedButton?.setOnClickListener(View.OnClickListener {
            if (item1Count >= 1 || item2Count >= 1) {
                val intent = Intent(this@ProductsActivity, CheckoutActivity::class.java)
                intent.putExtra("item1Count", item1Count)
                intent.putExtra("item2Count", item2Count)
                intent.putExtra("item1Price", item1Price)
                intent.putExtra("item2Price", item2Price)
                startActivity(intent)
            } else {
                Toast.makeText(
                    this@ProductsActivity,
                    "You should add atlease one item",
                    Toast.LENGTH_SHORT
                ).show()
            }
        })
    }
    //block:start:create-initiate-payload
    private fun createInitiatePayload(): JSONObject {
        val sdkPayload = JSONObject()
        val innerPayload = JSONObject()
        try {
            // generating inner payload
            innerPayload.put("action", "initiate")
            innerPayload.put("merchantId", "<MERCHANT_ID>")   //Your Merchant ID here
            innerPayload.put("clientId", "<CLIENT_ID>")       //Your Client ID here
            innerPayload.put("xRoutingId", "<X_ROUTING_ID>")    //Your X Routing ID here
            innerPayload.put("environment", "production")
            sdkPayload.put("requestId", "" + UUID.randomUUID())
            sdkPayload.put("service", "hyperpay")
            sdkPayload.put("payload", innerPayload)
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return sdkPayload
    }
    //block:end:create-initiate-payload

    //block:start:initiate-sdk
    private fun initiatePaymentsSDK() {
        if (!bharatpexPaymentServicesHolder!!.isInitialised) {
            initiatePayload = createInitiatePayload()
            bharatpexPaymentServicesHolder!!.setCallback(createBharatPeXPaymentsCallbackAdapter())
            bharatpexPaymentServicesHolder!!.initiate(createInitiatePayload())
            showSnackbar("Initiate Called!")
        }
    }
    //block:end:initiate-sdk

    //block:start:create-bharatpexPayment-callback
    private fun createBharatPeXPaymentsCallbackAdapter(): BharatPeXPaymentsCallbackAdapter {
        return object : BharatPeXPaymentsCallbackAdapter() {
            override fun onEvent(jsonObject: JSONObject, responseHandler: BharatPeXPaymentResponseHandler?) {
                val redirect = Intent(this@ProductsActivity, ResponsePage::class.java)
                redirect.putExtra("responsePayload", jsonObject.toString())
                try {
                    val event = jsonObject.getString("event")
                    if (event == "hide_loader") {
                        // Hide Loader
                        CheckoutActivity.dialog!!.hide()
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
                                        this@ProductsActivity,
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
    // block:end:create-bharatpexPayment-callback

    fun showSnackbar(message: String?) {
        coordinatorLayout = findViewById(R.id.coordinatorLayout2)
        val snackbar = Snackbar
            .make(coordinatorLayout!!, "Initiate Called!", Snackbar.LENGTH_LONG)
        snackbar.show()
    }

    fun add1Clicked(v: View?) {
        item1Count += 1
        itemCountTv1!!.text = Integer.toString(item1Count)
    }

    fun add2Clicked(v: View?) {
        item2Count += 1
        itemCountTv2!!.text = Integer.toString(item2Count)
    }

    fun remove1Clicked(v: View?) {
        if (item1Count < 1) {
            Toast.makeText(this, "Cannot remove as item count is already 0.", Toast.LENGTH_SHORT)
                .show()
        } else {
            item1Count -= 1
            itemCountTv1!!.text = Integer.toString(item1Count)
        }
    }

    fun remove2Clicked(v: View?) {
        if (item2Count < 1) {
            Toast.makeText(this, "Cannot remove as item count is already 0.", Toast.LENGTH_SHORT)
                .show()
        } else {
            item2Count -= 1
            itemCountTv2!!.text = Integer.toString(item2Count)
        }
    }
}
