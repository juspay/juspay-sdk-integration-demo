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
