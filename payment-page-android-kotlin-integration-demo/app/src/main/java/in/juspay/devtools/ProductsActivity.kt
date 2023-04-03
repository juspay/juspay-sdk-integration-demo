package `in`.juspay.devtools

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.coordinatorlayout.widget.CoordinatorLayout
import com.google.android.material.snackbar.Snackbar
import `in`.juspay.hyperinteg.HyperServiceHolder
import org.json.JSONObject
import java.util.*

class ProductsActivity : AppCompatActivity() {
    var proceedButton: Button? = null
    var itemCountTv1: TextView? = null
    var itemCountTv2: TextView? = null
    var hyperServicesHolder: HyperServiceHolder? = null
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
        //block:start:create-hyper-services-instance

        hyperServicesHolder = HyperServiceHolder(this)
        
        //block:end:create-hyper-services-instance
        
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
            innerPayload.put("environment", "production")
            sdkPayload.put("requestId", "" + UUID.randomUUID())
            sdkPayload.put("service", "in.juspay.hyperpay")
            sdkPayload.put("payload", innerPayload)
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return sdkPayload
    }
    //block:end:create-initiate-payload

    //block:start:initiate-sdk
    private fun initiatePaymentsSDK() {
        if (!hyperServicesHolder!!.isInitialised) {
            initiatePayload = createInitiatePayload()
            hyperServicesHolder!!.initiate(createInitiatePayload())
            showSnackbar("Initiate Called!")
        }
    }
    //block:end:initiate-sdk

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