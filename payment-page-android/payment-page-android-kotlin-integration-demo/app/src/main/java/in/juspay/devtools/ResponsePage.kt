package `in`.juspay.devtools

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class ResponsePage : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_response_page)
    }

    override fun onStart() {
        super.onStart()
        val i = intent
        val status = i.getStringExtra("status")
        val statusIcon = findViewById<ImageView>(R.id.checked_1)
        val statusText = findViewById<TextView>(R.id.payment_suc)
        if (status == "OrderSuccess") {
            statusIcon.setImageDrawable(resources.getDrawable(R.drawable.payment_success))
            statusText.text = "Payment Successful!"
        } else if (status == "CODInitiated") {
            statusIcon.setImageDrawable(resources.getDrawable(R.drawable.cod_initiated))
            statusText.text = "COD Initiated!"
        } else {
            statusIcon.setImageDrawable(resources.getDrawable(R.drawable.payment_failed))
            statusText.text = "Payment Failed!"
        }
        val okay = findViewById<Button>(R.id.rectangle_12)
        okay.setOnClickListener {
            finishAffinity()
            System.exit(0)
        }
        val back = findViewById<ImageView>(R.id.imageView1)
        back.setOnClickListener {
            finish()
            val i = Intent(this@ResponsePage, ProductsActivity::class.java)
            startActivity(i)
        }
    }
}