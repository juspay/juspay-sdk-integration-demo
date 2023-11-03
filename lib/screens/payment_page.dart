import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hypersdkflutter/hypersdkflutter.dart';
import '../utils/generate_payload.dart';
import 'response.dart';

class PaymentPage extends StatefulWidget {
  final HyperSDK hyperSDK;
  final String amount;
  const PaymentPage({Key? key, required this.hyperSDK, required this.amount})
      : super(key: key);
  @override
  _PaymentPageState createState() => _PaymentPageState(amount);
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
      startPayment(amount);
    }

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
      child: Container(
        color: Colors.white,
        child: Center(
          child: showLoader ? const CircularProgressIndicator() : Container(),
        ),
      ),
    );
  }

  void startPayment(amount) async {
    processCalled = true;
    var url = Uri.parse(
        'http://10.0.2.2:5000/initiateJuspayPayment'); //10.0.2.2 Works only on emulator
    var headers = {
      'Content-Type': 'application/json',
    };
    var rng = new Random();
    var number = rng.nextInt(900000) + 100000;

    var requestBody = {
      "order_id": "test" + number.toString(),
      "amount": amount
    };
    var response =
        await http.post(url, headers: headers, body: jsonEncode(requestBody));
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      widget.hyperSDK
          .openPaymentPage(jsonResponse['sdkPayload'], hyperSDKCallbackHandler);
    } else {
      throw Exception(
          'API call failed with status code ${response.statusCode}');
    }
    ;
  }

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
        var orderId = args['orderId'];

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResponseScreen(),
                settings: RouteSettings(arguments: orderId)));
    }
  }
}
