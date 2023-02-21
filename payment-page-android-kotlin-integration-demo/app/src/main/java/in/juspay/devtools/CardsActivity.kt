package `in`.juspay.devtools

import `in`.juspay.hypersdk.data.JuspayResponseHandler
import `in`.juspay.hypersdk.ui.HyperPaymentsCallbackAdapter
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Bundle
import android.text.Editable
import android.text.InputFilter
import android.text.InputFilter.LengthFilter
import android.text.TextWatcher
import android.util.Log
import android.view.View
import android.widget.Button
import android.widget.EditText
import android.widget.ImageView
import androidx.appcompat.app.AppCompatActivity
import org.json.JSONObject
import java.util.*

class CardsActivity: AppCompatActivity() {
    private lateinit var sharedPref: SharedPreferences
    var hyperServicesHolder: HyperServiceHolder? = null


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_cards);
        sharedPref = applicationContext.getSharedPreferences("secrets", Context.MODE_PRIVATE);
    }

    override fun onStart() {
        super.onStart();

        hyperServicesHolder = HyperServiceHolder(this)
        hyperServicesHolder!!.setCallback(createHyperPaymentsCallbackAdapter())

        var backImage = findViewById<ImageView>(R.id.imageView)
        backImage?.setOnClickListener(View.OnClickListener { onBackPressed() });

        var cardInputEditText = findViewById<EditText>(R.id.card_input);
        val expiryInputEditText = findViewById<EditText>(R.id.expiry_input);
        val cvvInputEditText = findViewById<EditText>(R.id.cvv_input);


        // Card input
        val cardWatcher = CardNumberTextWatcher(cardInputEditText, expiryInputEditText)
        cardInputEditText.addTextChangedListener(cardWatcher)

        val cardFilters = arrayOfNulls<InputFilter>(1)
        cardFilters[0] = LengthFilter(19)
        cardInputEditText.filters = cardFilters

        //Expiry input
        val expiryWatcher = ExpiryDateTextWatcher(expiryInputEditText, cvvInputEditText)
        expiryInputEditText.addTextChangedListener(expiryWatcher)

        val expiryFilters = arrayOfNulls<InputFilter>(1)
        expiryFilters[0] = LengthFilter(5)
        expiryInputEditText.filters = expiryFilters

        //CVV input
        val cvvWatcher = CvvTextWatcher(cvvInputEditText)
        cvvInputEditText.addTextChangedListener(cvvWatcher)

        val cvvFilters = arrayOfNulls<InputFilter>(1)
        cvvFilters[0] = LengthFilter(3)
        cvvInputEditText.filters = cvvFilters


        val proceedToPayButton = findViewById<Button>(R.id.proceed_button);
        proceedToPayButton.setOnClickListener {
            val cardNumber = cardInputEditText.text;
            Log.d("ANURAG CARD", cardNumber.toString())
//            Log.d("ANURAG exp month", cardNumber.toString())
//            Log.d("ANURAG CARD", cardNumber.toString())
//            Log.d("ANURAG CARD", cardNumber.toString())

            startCardPayments("1", "2", "3", "4");
        }
    }

    private fun startCardPayments(cardNumber: String, cardExpMonth: String, cardExpYear: String, cardSecurityCode: String) {
        val payload = JSONObject();
        val innerPayload = JSONObject();
        val requestId = UUID.randomUUID().toString();

        innerPayload.put("action", "cardTxn")
        innerPayload.put("orderId", "orderId")
        innerPayload.put("paymentMethod", "VISA")
        innerPayload.put("cardNumber", "4111111111111111")
        innerPayload.put("cardExpMonth", "11")
        innerPayload.put("cardExpYear", "24")
        innerPayload.put("cardSecurityCode", "123")
        innerPayload.put("saveToLocker", true)
        innerPayload.put("clientAuthToken", sharedPref.getString("clientAuthToken", ""))
        innerPayload.put("tokenize", "true")
        innerPayload.put("cardNickName", "User - HDFC")

        payload.put("request_id", requestId)
        payload.put("service", "in.juspay.hyperapi")
        payload.put("payload", innerPayload);

        if (hyperServicesHolder!!.isInitiated) {
            hyperServicesHolder!!.process(payload)
            Log.d("ANURAG PROCESS CALLED", payload.toString())
        }
    }

    private fun createHyperPaymentsCallbackAdapter(): HyperPaymentsCallbackAdapter {
        return object : HyperPaymentsCallbackAdapter() {
            override fun onEvent(jsonObject: JSONObject, responseHandler: JuspayResponseHandler?) {
                Log.d("ANURAG PROCESS EVENT", jsonObject.toString())
                val redirect = Intent(this@CardsActivity, ResponsePage::class.java)
                redirect.putExtra("responsePayload", jsonObject.toString())
                try {
                    val event = jsonObject.getString("event")
                    if (event == "hide_loader") {
                        // Hide Loader
                        Log.d("ANURAG", "HIDE LOADER FIRED")
//                        dialog!!.hide()
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
                                        this@CardsActivity,
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
}

class CardNumberTextWatcher(private val editText: EditText, private val nextEditText: EditText ) : TextWatcher {
    override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {
        if (s.length === 19) {
            // set focus to next EditText
            nextEditText.requestFocus();
        }

        // remove any non-digits from the input text
        val digits = s.toString().replace("[^\\d]".toRegex(), "")

        // format the digits as a credit card number
        val formatted = StringBuilder()
        var group = 0
        for (i in 0 until digits.length) {
            if (group == 4) {
                formatted.append(" ")
                group = 0
            }
            formatted.append(digits[i])
            group++
        }

        // update the EditText with the formatted text
        editText.removeTextChangedListener(this)
        editText.setText(formatted.toString())
        editText.setSelection(formatted.length)
        editText.addTextChangedListener(this)
    }

    override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
    override fun afterTextChanged(s: Editable) {}
}

class ExpiryDateTextWatcher(private val editText: EditText, private val nextEditText: EditText) : TextWatcher {
    override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {
        if (s.length === 5) {
            // set focus to next EditText
            nextEditText.requestFocus();
        }

        // add slash after two digits
        if (s.length == 2 && count == 1) {
            editText.setText("$s/")
            editText.setSelection(s.length + 1)
        }
    }

    override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
    override fun afterTextChanged(s: Editable) {}
}

class CvvTextWatcher(private val editText: EditText) : TextWatcher {
    override fun onTextChanged(s: CharSequence, start: Int, before: Int, count: Int) {
        // replace all digits with mask characters
        val masked = s.toString().replace("\\d".toRegex(), "*")

        // update the EditText with the masked text
        editText.removeTextChangedListener(this)
        editText.setText(masked)
        editText.setSelection(masked.length)
        editText.addTextChangedListener(this)
    }

    override fun beforeTextChanged(s: CharSequence, start: Int, count: Int, after: Int) {}
    override fun afterTextChanged(s: Editable) {}
}