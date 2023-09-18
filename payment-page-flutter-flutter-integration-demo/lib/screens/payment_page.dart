import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// block:start:import-hyper-sdk
import 'package:hypersdkflutter/hypersdkflutter.dart';
// block:end:import-hyper-sdk

import '../utils/generate_payload.dart';
import './success.dart';
import './failed.dart';

class PaymentPage extends StatefulWidget {
  // Create Juspay Object
  // block:start:create-hyper-sdk-instance
  final HyperSDK hyperSDK;
  // block:end:create-hyper-sdk-instance
  final String amount;
  const PaymentPage({Key? key, required this.hyperSDK, required this.amount})
      : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState(amount);
}

Future<Map<String, dynamic>> makeApiCall(amount) async {
  var url = Uri.parse('https://api.juspay.in/session');

  var headers = {
    'Authorization': 'Basic <YOUR_API_KEY>',
    'x-merchantid': '<MERCHANT_ID>',
    'Content-Type': 'application/json',
  };

  var rng = new Random();
  var number = rng.nextInt(900000) + 100000;

  var requestBody = {
    "order_id": "test" + number.toString(),
    "amount": amount,
    "customer_id": "9876543201",
    "customer_email": "test@mail.com",
    "customer_phone": "9876543201",
    "payment_page_client_id": "<CLIENT_ID>",
    "action": "paymentPage",
    "return_url": "https://shop.merchant.com",
    "description": "Complete your payment",
    "first_name": "John",
    "last_name": "wick"
  };

  var response =
      await http.post(url, headers: headers, body: jsonEncode(requestBody));

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse['sdk_payload'];
  } else {
    throw Exception('API call failed with status code ${response.statusCode}');
  }
}

class _PaymentPageState extends State<PaymentPage> {
  var showLoader = true;
  var processCalled = false;
  var paymentSuccess = false;
  var paymentFailed = false;
  var amount = "0";
  _PaymentPageState(amount) {
    this.amount = amount;
  }

  @override
  Widget build(BuildContext context) {
    if (!processCalled) {
      callProcess(amount);
    }
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

  void callProcess(amount) async {
    processCalled = true;
    var processPayload = await makeApiCall(amount);
    // Get process payload from backend
    // block:start:fetch-process-payload
    // var processPayload = await getProcessPayload(widget.amount);
    // block:end:fetch-process-payload

    // Calling process on hyperSDK to open the Hypercheckout screen
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SuccessScreen()));
              }
              break;
            case "cod_initiated":
              {
                // User opted for cash on delivery option displayed on the Hypercheckout screen
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SuccessScreen()));
              }
              break;
          }
        } else {
          var errorCode = args["errorCode"] ?? " ";
          var errorMessage = args["errorMessage"] ?? " ";

          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   Navigator.pushReplacement(context,
          //       MaterialPageRoute(builder: (context) => const SuccessScreen()));
          // });
          switch (status) {
            case "backpressed":
              {
                // user back-pressed from PP without initiating any txn
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FailedScreen()));
              }
              break;
            case "user_aborted":
              {
                // user initiated a txn and pressed back
                // check order status via S2S API
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FailedScreen()));
              }
              break;
            case "pending_vbv":
              {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FailedScreen()));
              }
              break;
            case "authorizing":
              {
                // txn in pending state
                // check order status via S2S API
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FailedScreen()));
              }
              break;
            case "authorization_failed":
              {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FailedScreen()));
              }
              break;
            case "authentication_failed":
              {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FailedScreen()));
              }
              break;
            case "api_failure":
              {
                // txn failed
                // check order status via S2S API
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FailedScreen()));
              }
              break;
            case "new":
              {
                // order created but txn failed
                // check order status via S2S API
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FailedScreen()));
              }
              break;
            default:
              {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FailedScreen()));
              }
          }
        }
    }
  }
  // block:end:callback-handler
}
