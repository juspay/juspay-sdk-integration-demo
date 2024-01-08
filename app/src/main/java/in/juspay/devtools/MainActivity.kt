package `in`.juspay.devtools

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.view.WindowManager
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {
    private val SPLASH_SCREEN_TIME_OUT = 500L // Time delay in milliseconds

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Set the activity to fullscreen
        window.setFlags(
            WindowManager.LayoutParams.FLAG_FULLSCREEN,
            WindowManager.LayoutParams.FLAG_FULLSCREEN
        )

        // Set the layout of the activity
        setContentView(R.layout.activity_main)

        // Use a Handler to delay the transition to the ProductsActivity
        Handler().postDelayed({
            val intent = Intent(this@MainActivity, CheckoutActivity::class.java)
            startActivity(intent) // Start the ProductsActivity
            finish() // Close the current activity (splash screen)
        }, SPLASH_SCREEN_TIME_OUT)
    }
}
