fun onEvent(data: JSONObject, handler: JuspayResponsehandler?) {
    val event: String = data.optString("event")
    when (event) {
        "initiate_result" -> {
          // handle initiate response -- log it
			   // do what you want here
        }
        "hide_loader" -> {
        // stop the processing loader 
        }
        "process_result" -> {
            val error: Boolean = data.optBoolean("error")
            val innerPayload: JSONObject = data.optJSONObject("payload")
            val status: String = innerPayload.optString("status")
            val pi: String = innerPayload.optString("paymentInstrument")
            val pig: String = innerPayload.optString("paymentInstrumentGroup")
            if (!error) {
                // txn success, status should be "charged"
                // process data -- show pi and pig in UI maybe also?
                // example -- pi: "PAYTM", pig: "WALLET"
                // call orderStatus once to verify (false positives)
            } else {
                val errorCode: String = data.optString("errorCode")
                val errorMessage: String = data.optString("errorMessage")
                when (status) {
                    "backpressed" -> {
                      // user back-pressed from PP without initiating txn
                    }
                    "user_aborted" -> {
                      // user initiated a txn and pressed back
						         // poll order status
                    }
                    "pending_vbv", "authorizing" -> {
                      // txn in pending state
						      // poll order status until backend says fail or success
                    }
                    "authorization_failed", "authentication_failed", "api_failure" -> {
                      // txn failed
						// poll orderStatus to verify
                                  
                    }
                    "new" -> {
                      // order created but txn failed
						         // very rare
					         	// also failure
						       // poll order status
                    }
                    else -> {
                      // unknown status, this is also failure
						// poll order status
                    }
                }
                // if txn was attempted, pi and pig would be non-empty
                // can be used to show in UI if you are into that
                // errorMessage can also be shown in UI
            }
        }
    }
}