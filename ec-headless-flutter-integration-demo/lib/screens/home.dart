void initiateBharatPexPaymentSDK() async {
  // Check whether bharatpexPaymentSDK is already initialised
  if (!await widget.bharatpexPaymentSDK.isInitialised()) {
    // Getting initiate payload
    // block:start:get-initiate-payload
    
    var initiatePayload = {
      "requestId": const Uuid().v4(),
      "service": "hyperapi",
      "payload": {
        "action": "initiate",
        "merchantId": "<merchant-id>",
        "clientId": "<client-id>",
        "xRoutingId": "<x-routing-id>",
        "environment": "production"
      }
    };
    // block:end:get-initiate-payload

    // Calling initiate on bharatpexPaymentSDK instance to boot up payment engine.
    // block:start:initiate-sdk

    await widget.bharatpexPaymentSDK.initiate(initiatePayload, initiateCallbackHandler);
    // block:end:initiate-sdk
  }
}

// Define handler for inititate callback
// block:start:initiate-callback-handler

void initiateCallbackHandler(MethodCall methodCall) {
  if (methodCall.method == "initiate_result") {
    // check initiate result
  }
}
// block:end:initiate-callback-handler


