{
  // Overriding onBackPressed to handle hardware backpress
  // block:start:onBackPressed

    onWillPop: () async {
      if (Platform.isAndroid) {
        var backpressResult = await widget.hyperSDK.onBackPress();

        if (backpressResult.toLowerCase() == "true") {
          return false;
        } else {
          return true;
        }
      } else {
        return true;
      }
    }
    // block:end:onBackPressed


  // Get process payload from backend
  // block:start:fetch-process-payload

  var processPayload = await getProcessPayload(widget.amount);
  // block:end:fetch-process-payload

  // Calling process on hyperSDK to open the checkout screen
  // block:start:process-sdk

  await widget.hyperSDK.process(processPayload, hyperSDKCallbackHandler);
  // block:end:process-sdk
}

// Define handler for callbacks from hyperSDK
// block:start:callback-handler

void hyperSDKCallbackHandler(MethodCall methodCall) {
  switch (methodCall.method) {
    case "hide_loader":
      setState(() {
        showLoader = false;
      });
      break;
    case "process_result":
      var args = {};

      try {
        args = json.decode(methodCall.arguments);
      } catch (e) {
        print(e);
      }

      var error = args["error"] ?? false;

      var innerPayload = args["payload"] ?? {};

      var status = innerPayload["status"] ?? " ";
      var pi = innerPayload["paymentInstrument"] ?? " ";
      var pig = innerPayload["paymentInstrumentGroup"] ?? " ";

      if (!error) {
        switch (status) {
          case "charged":
            {
              // block:start:check-order-status
              // Successful Transaction
              // check order status via S2S API
              // block:end:check-order-status
              setState(() {
                paymentSuccess = true;
                paymentFailed = false;
              });
            }
            break;
          case "cod_initiated":
            {
              // User opted for cash on delivery option displayed on the checkout screen
            }
            break;
        }
      } else {
        var errorCode = args["errorCode"] ?? " ";
        var errorMessage = args["errorMessage"] ?? " ";
        switch (status) {
          case "backpressed":
            {
              // user back-pressed from PP without initiating any txn
              setState(() {
                paymentFailed = true;
                paymentSuccess = false;
              });
            }
            break;
          case "user_aborted":
            {
              // user initiated a txn and pressed back
              // check order status via S2S API
            }
            break;
          case "pending_vbv":
            {}
            break;
          case "authorizing":
            {
              // txn in pending state
              // check order status via S2S API
            }
            break;
          case "authorization_failed":
            {}
            break;
          case "authentication_failed":
            {}
            break;
          case "api_failure":
            {
              // txn failed
              // check order status via S2S API
            }
            break;
          case "new":
            {
              // order created but txn failed
              // check order status via S2S API
            }
            break;
        }
      }
  }
}
// block:end:callback-handler
