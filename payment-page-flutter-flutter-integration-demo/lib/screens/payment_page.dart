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
      openPaymentPage(amount);
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

  void openPaymentPage(amount) async {
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
      "amount": amount,
      "customer_id": "9876543201",
      "customer_email": "test@mail.com",
      "customer_phone": "9876543201",
      "payment_page_client_id": "hdfcmaster"
    };

    var response =
        await http.post(url, headers: headers, body: jsonEncode(requestBody));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      widget.hyperSDK
          .process(jsonResponse['sdkPayload'], hyperSDKCallbackHandler);
    } else {
      throw Exception(
          'API call failed with status code ${response.statusCode}');
    }
    ;
  }

  void hyperSDKCallbackHandler(MethodCall methodCall) {
    print('args>>> $methodCall');
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
        print('args>>> $args');
        var orderId = args['orderId'];

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResponseScreen(),
                settings: RouteSettings(arguments: orderId)));
    }
  }
  // block:end:callback-handler
}
