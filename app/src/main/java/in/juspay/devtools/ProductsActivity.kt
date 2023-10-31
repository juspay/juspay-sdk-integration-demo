package `in`.juspay.devtools

import android.content.Intent
import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity

class ProductsActivity : AppCompatActivity() {
    private lateinit var proceedButton: Button
    private lateinit var itemCountTv1: TextView
    private lateinit var itemCountTv2: TextView
    private var item1Count = 1
    private var item2Count = 0
    private val item1Price = 1
    private val item2Price = 1

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_products)
    }

    override fun onStart() {
        super.onStart()
        prepareUI()
    }

    private fun prepareUI() {
        proceedButton = findViewById(R.id.rectangle_8)
        itemCountTv1 = findViewById(R.id.some_id)
        itemCountTv2 = findViewById(R.id.some_id2)
        proceedButton.setOnClickListener {
            if (item1Count >= 1 || item2Count >= 1) {
                val intent = Intent(this@ProductsActivity, CheckoutActivity::class.java)
                intent.putExtra("item1Count", item1Count)
                intent.putExtra("item2Count", item2Count)
                intent.putExtra("item1Price", item1Price)
                intent.putExtra("item2Price", item2Price)
                startActivity(intent)
            } else {
                Toast.makeText(this@ProductsActivity, "You should add at least one item", Toast.LENGTH_SHORT).show()
            }
        }
    }

    fun add1Clicked(v: View) {
        item1Count += 1
        itemCountTv1.text = item1Count.toString()
    }

    fun add2Clicked(v: View) {
        item2Count += 1
        itemCountTv2.text = item2Count.toString()
    }

    fun remove1Clicked(v: View) {
        if (item1Count < 1) {
            Toast.makeText(this, "Cannot remove as item count is already 0.", Toast.LENGTH_SHORT).show()
        } else {
            item1Count -= 1
            itemCountTv1.text = item1Count.toString()
        }
    }

    fun remove2Clicked(v: View) {
        if (item2Count < 1) {
            Toast.makeText(this, "Cannot remove as item count is already 0.", Toast.LENGTH_SHORT).show()
        } else {
            item2Count -= 1
            itemCountTv2.text = item2Count.toString()
        }
    }
}
