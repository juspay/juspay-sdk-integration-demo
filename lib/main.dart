import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_kit/screens/failed.dart';
import 'package:flutter_kit/screens/success.dart';
import 'package:hypersdkflutter/hypersdkflutter.dart';
import 'package:http/http.dart' as http;

void main() {
  final hyperSDK = HyperSDK();
  runApp(MyApp(hyperSDK: hyperSDK));
}

class MyApp extends StatelessWidget {
  final HyperSDK hyperSDK;
  const MyApp({super.key, required this.hyperSDK});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Kit',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: MyHomePage(
        title: 'Checkout Screen',
        hyperSDK: hyperSDK,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final HyperSDK hyperSDK;
  const MyHomePage({super.key, required this.title, required this.hyperSDK});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? orderId;
  void initiateHyperSDK() async {
    var response = await http
        .get(Uri.parse('http://127.0.0.1:5000/initiateJuspayPayment'));
    if (response.statusCode == 200) {
      try {
        var decodedResponse = json.decode(response.body);
        var sdkPayload = decodedResponse["sdkPayload"];
        orderId = decodedResponse["orderId"];
        if (sdkPayload != null) {
          await widget.hyperSDK
              .openPaymentPage(sdkPayload, hyperSDKCallbackHandler);
        } else {
          //handle case when decode failed
        }
      } catch (e) {
        //handle case when json.decode throws exception
      }
    } else {
      //handle case when api failed
    }
  }

  Future<String> checkPaymentStatus(String status) async {
    String? finalStatus;
    try {
      if (orderId != null) {
        var url =
            "http://127.0.0.1:5000/handleJuspayResponse?order_id=${(orderId ?? "")}";
        var response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          try {
            var decodedResponse = json.decode(response.body);
            var orderStatus = decodedResponse["order_status"];
            if (orderStatus != null) {
              finalStatus = orderStatus;
            }
          } catch (e) {
            //handle case when json.decode throws exception
          }
        }
      }
    } catch (e) {
      //handle when api failed
    }
    return finalStatus ?? status;
  }

  void openSucessScreen() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const SuccessScreen()));
  }

  void openFailureScreen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const FailedScreen()));
  }

  void checkStatus(bool error, String status) async {
    var finalStatus = await checkPaymentStatus(status);
    if (!error) {
      switch (finalStatus) {
        case "charged":
          {
            // block:start:check-order-status
            // Successful Transaction
            // check order status via S2S API
            // block:end:check-order-status
            openSucessScreen();
          }
          break;
        case "cod_initiated":
          {
            // User opted for cash on delivery option displayed on the Hypercheckout screen
            openSucessScreen();
          }
          break;
      }
    } else {
      switch (finalStatus) {
        case "backpressed":
          {
            // user back-pressed from PP without initiating any txn
            openFailureScreen();
          }
          break;
        case "user_aborted":
          {
            // user initiated a txn and pressed back
            // check order status via S2S API
            openFailureScreen();
          }
          break;
        case "pending_vbv":
          {
            openFailureScreen();
          }
          break;
        case "authorizing":
          {
            // txn in pending state
            // check order status via S2S API
            openFailureScreen();
          }
          break;
        case "authorization_failed":
          {
            openFailureScreen();
          }
          break;
        case "authentication_failed":
          {
            openFailureScreen();
          }
          break;
        case "api_failure":
          {
            // txn failed
            // check order status via S2S API
            openFailureScreen();
          }
          break;
        case "new":
          {
            // order created but txn failed
            // check order status via S2S API
            openFailureScreen();
          }
          break;
        default:
          {
            openFailureScreen();
          }
      }
    }
  }

  void hyperSDKCallbackHandler(MethodCall methodCall) {
    switch (methodCall.method) {
      case "hide_loader":
        setState(() {
          // showLoader = false;
        });
        break;
      case "process_result":
        var args = {};

        try {
          args = json.decode(methodCall.arguments);
        } catch (e) {
          //handle decode failure
        }

        var error = args["error"] ?? false;

        var innerPayload = args["payload"] ?? {};

        var status = innerPayload["status"] ?? " ";
        checkStatus(error, status);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: initiateHyperSDK,
                child: const Text('Open Payment Page'),
              )
            ],
          ),
        ));
  }
}
