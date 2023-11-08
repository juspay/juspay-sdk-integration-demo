package `in`.juspay.devtools

import android.app.ProgressDialog
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.coordinatorlayout.widget.CoordinatorLayout
import `in`.juspay.hypercheckoutlite.HyperCheckoutLite
import `in`.juspay.hypersdk.data.JuspayResponseHandler
import `in`.juspay.hypersdk.ui.HyperPaymentsCallbackAdapter
import org.json.JSONObject

class CheckoutActivity : AppCompatActivity() {
    private lateinit var processButton: Button
    private lateinit var coordinatorLayout: CoordinatorLayout
    private lateinit var dialog: ProgressDialog
    private var amountString: String? = null
    private var item1Price: Int = 0
    private var item2Price: Int = 0
    private var item1Count: Int = 0
    private var item2Count: Int = 0
    private lateinit var item1PriceTv: TextView
    private lateinit var item2PriceTv: TextView
    private lateinit var item1CountTv: TextView
    private lateinit var item2CountTv: TextView
    private lateinit var totalAmountTv: TextView
    private lateinit var taxTv: TextView
    private lateinit var totalPayableTv: TextView
    private val taxPercent: Double = 0.18
    private lateinit var backImage: ImageView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_checkout)
    }

    override fun onStart() {
        super.onStart()
        updatingUI() // This is relevant only for a sample project
        processButton = findViewById(R.id.rectangle_9)
        processButton.setOnClickListener {
            dialog.show()
            try {
                openPaymentPage()
            } catch (e: Exception) {
            }
        }
        backImage = findViewById(R.id.imageView)
        backImage.setOnClickListener {
            onBackPressed()
        }
    }

    // block:start:startPayment
    private fun openPaymentPage() {
        val payload = JSONObject()

        val randomOrderId = (Math.random() * Math.pow(10.0, 12.0)).toLong()
        val order_id = "test-$randomOrderId" // Put your own order id here
        try {
            // block:start:updateOrderID
            // You can put your payload details here
            payload.put("order_id", order_id) // OrderID should be unique
            payload.put("amount", amountString) // Amount should be in strings e.g. "100.00"
            payload.put("customer_id", "testing-customer-one") // Customer ID should be unique for each user and should be a string
            payload.put("customer_email", "test@mail.com")
            payload.put("customer_phone", "9876543201")
            payload.put("action", "paymentPage")

            // For other payload params, you can refer to the integration doc shared with you
            // block:end:updateOrderID
        } catch (e: Exception) {
            Log.d("Juspay", e.toString())
        }

        // block:start:sendPostRequest
        ApiClient.sendPostRequest("http://10.0.2.2:5000/initiateJuspayPayment", payload, object : ApiClient.ApiResponseCallback {
            override fun onResponseReceived(response: String?) {
                try {
                    val sdkPayload = JSONObject(response).getJSONObject("sdkPayload")
                    runOnUiThread {
                        // block:start:openPaymentPage
                        HyperCheckoutLite.openPaymentPage(this@CheckoutActivity, sdkPayload, createHyperPaymentsCallbackAdapter())
                        // block:end:openPaymentPage
                        Helper().showSnackbar("Opening Payment Page", coordinatorLayout)
                    }
                } catch (e: Exception) {
                    Log.d("ERROR>>>", e.toString())
                }
            }

            override fun onFailure(e: Exception?) {

            }
        })
        // block:end:sendPostRequest
    }
    // block:end:startPayment

    // block:start:create-hyper-callback
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
                                    // Handle back
                                    Helper().showSnackbar("User Aborted", coordinatorLayout)
                                }
                                else -> {
                                    val orderId = jsonObject.getString("orderId")
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
    // block:end:create-hyper-callback

    // block:start:onBackPressed
    override fun onBackPressed() {
        val handleBackpress = HyperCheckoutLite.handleBackPress()
        if (!handleBackpress) {
            super.onBackPressed()
        }
    }
    // block:end:onBackPressed

    private fun updatingUI() {
        coordinatorLayout = findViewById(R.id.coordinatorLayout)
        dialog = ProgressDialog(this@CheckoutActivity)
        dialog.setMessage("Processing...")

        val i = intent
        item1Count = i.getIntExtra("item1Count", 1)
        item2Count = i.getIntExtra("item2Count", 1)
        item1Price = i.getIntExtra("item1Price", 1)
        item2Price = i.getIntExtra("item2Price", 1)

        item1PriceTv = findViewById(R.id.some_id1)
        item2PriceTv = findViewById(R.id.some_id2)
        item1CountTv = findViewById(R.id.x2)
        item2CountTv = findViewById(R.id.x3)
        totalPayableTv = findViewById(R.id.some_id5)
        totalAmountTv = findViewById(R.id.some_id)
        taxTv = findViewById(R.id.some_id3)

        item1CountTv.text = "x$item1Count"
        item2CountTv.text = "x$item2Count"
        val item1Amount = item1Price * item1Count
        val item2Amount = item2Price * item2Count
        item1PriceTv.text = "₹ $item1Amount"
        item2PriceTv.text = "₹ $item2Amount"

        val totalAmount = item1Amount + item2Amount
        val tax = totalAmount * taxPercent
        val totalPayable = totalAmount + tax
        val helper = Helper()
        amountString = helper.round(totalPayable, 2).toString()
        val taxString = helper.round(tax, 2).toString()
        totalAmountTv.text = "₹ $totalAmount"
        taxTv.text = "₹ $taxString"
        totalPayableTv.text = "₹ $amountString"
    }
}
