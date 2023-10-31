package `in`.juspay.devtools

import android.graphics.Color
import android.view.Gravity
import android.view.View
import android.widget.TextView
import androidx.coordinatorlayout.widget.CoordinatorLayout
import com.google.android.material.snackbar.Snackbar
import kotlin.math.pow

class Helper {
    fun showSnackbar(message: String, coordinatorLayout: CoordinatorLayout) {
        val snackbar = Snackbar.make(coordinatorLayout, message, Snackbar.LENGTH_LONG)
        snackbar.setActionTextColor(Color.BLACK)
        val view = snackbar.view
        view.setBackgroundColor(Color.WHITE)
        val textView = view.findViewById<TextView>(com.google.android.material.R.id.snackbar_text)
        textView.setTextColor(Color.BLACK)
        val params = view.layoutParams as CoordinatorLayout.LayoutParams
        params.gravity = Gravity.TOP
        view.layoutParams = params
        snackbar.show()
    }

    fun round(value: Double, places: Int): Double {
        require(places >= 0) { "Places argument must be non-negative" }
        val factor = 10.0.pow(places.toDouble()).toLong()
        val roundedValue = (value * factor).toLong()
        return roundedValue.toDouble() / factor
    }
}
