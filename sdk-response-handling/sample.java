public void onEvent(JSONObject data, JuspayResponsehandler handler) {
	String event = data.optString("event");
	switch (event) {
		case "initiate_result":
			// handle initiate response -- log it
			// do what you want here
			break;

		case "hide_loader":
			// stop the processing loader 
			break;
    
    case "log_stream":
      // Consume the click events
      break;
      
		case "process_result":
			boolean error = data.optBoolean("error");

			JSONObject innerPayload = data.optJSONObject("payload");
			String status = innerPayload.optString("status");
			String pi = innerPayload.optString("paymentInstrument");
			String pig = innerPayload.optString("paymentInstrumentGroup"); 

			if (!error) {
				// "charged", if order was successful
				// "cod_initiated", if user opted for cash on delivery option displayed on payment page
				         // process data -- show pi and pig in UI maybe also?
				         // example -- pi: "PAYTM", pig: "WALLET"
				         // call orderStatus once to verify (false positives)
			} else {
				String errorCode = data.optString("errorCode");
				String errorMessage = data.optString("errorMessage");
				switch (status) {
					case "backpressed":
						// user back-pressed from PP without
                                       // without initiating txn
						break;
					case "user_aborted":
						// user initiated a txn and pressed back
						// poll order status
						break;
					case "pending_vbv":
					case "authorizing":
						// txn in pending state
						// poll order status until backend says fail or success
						break;
					case "authorization_failed":
					case "authentication_failed":
					case "api_failure":
						// txn failed
						// poll orderStatus to verify
                                       // (false negatives)
						break;
					case "new":
						// order created but txn failed
						// very rare
						// also failure
						// poll order status
						break;
					default:
						// unknown status, this is also failure
						// poll order status
				}
				// if txn was attempted, pi and pig would be non-empty
				// can be used to show in UI if you are into that
				// errorMessage can also be shown in UI
			}
	}
}