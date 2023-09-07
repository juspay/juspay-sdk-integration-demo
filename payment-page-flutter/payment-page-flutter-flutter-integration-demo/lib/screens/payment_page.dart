import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hypersdkflutter/hypersdkflutter.dart';

// import '../utils/generate_payload.dart';
import './success.dart';
import './failed.dart';

class PaymentPage extends StatefulWidget {
  final HyperSDK hyperSDK;
  final String amount;
  const PaymentPage({Key? key, required this.hyperSDK, required this.amount})
      : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  var showLoader = true;
  var processCalled = false;
  var paymentSuccess = false;
  var paymentFailed = false;

  @override
  Widget build(BuildContext context) {
    if (!processCalled) {
      callProcess();
    }

    navigateAfterPayment(context);

    // Overriding onBackPressed to handle hardware backpress
    // block:start:onBackPressed
    return WillPopScope(
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
      },
      // block:end:onBackPressed
      child: Container(
        color: Colors.white,
        child: Center(
          child: showLoader ? const CircularProgressIndicator() : Container(),
        ),
      ),
    );
  }

  void callProcess() async {
    processCalled = true;

    // Get process payload from backend
    // block:start:fetch-process-payload
    var processPayload = {
      "requestId": "12398b5571d74c3388a74004bc24370c",
      "service": "in.juspay.hyperpay",
      "payload": {
        "clientId": "geddit",
        "amount": "1.0",
        "merchantId": "geddit",
        "clientAuthToken": "tkn_xxxxxxxxxxxxxxxxxxxxx",
        "clientAuthTokenExpiry": "2022-03-12T20:29:23Z",
        "environment": "production",
        "options.getUpiDeepLinks": "true",
        "lastName": "wick",
        "action": "paymentPage",
        "customerId": "testing-customer-one",
        "returnUrl": "https://shop.merchant.com",
        "currency": "INR",
        "firstName": "John",
        "customerPhone": "9876543210",
        "customerEmail": "test@mail.com",
        "orderId": "testing-order-one",
        "description": "Complete your payment"
      }
    };
    // block:end:fetch-process-payload

    // Calling process on hyperSDK to open payment page
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
                // User opted for cash on delivery option displayed on payment page
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

  void navigateAfterPayment(BuildContext context) {
    if (paymentSuccess) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SuccessScreen()));
      });
    } else if (paymentFailed) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const FailedScreen()));
      });
    }
  }
}
