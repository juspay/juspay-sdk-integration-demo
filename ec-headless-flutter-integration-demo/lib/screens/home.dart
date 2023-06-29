void initiateHyperSDK() async {
  // Check whether hyperSDK is already initialised
  if (!await widget.hyperSDK.isInitialised()) {
    // Getting initiate payload
    // block:start:get-initiate-payload
    
    var initiatePayload = {
      "requestId": const Uuid().v4(),
      "service": "in.juspay.hyperapi",
      "payload": {
        "action": "initiate",
        "merchantId": "<merchant-id>",
        "clientId": "<client-id>",
        "environment": "production"
      }
    };
    // block:end:get-initiate-payload

    // Calling initiate on hyperSDK instance to boot up payment engine.
    // block:start:initiate-sdk

    await widget.hyperSDK.initiate(initiatePayload, initiateCallbackHandler);
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


