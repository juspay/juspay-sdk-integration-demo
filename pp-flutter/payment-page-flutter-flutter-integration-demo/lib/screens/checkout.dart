import 'package:flutter/material.dart';
import 'package:hypersdk/hypersdk.dart';

import '../widgets/app_bar.dart';
import '../widgets/bottom_button.dart';
import './payment_page.dart';

class CheckoutScreen extends StatefulWidget {
  final int productOneCount;
  final int productTwoCount;
  final HyperSDK hyperSDK;

  const CheckoutScreen(
      {Key? key,
      required this.productOneCount,
      required this.productTwoCount,
      required this.hyperSDK})
      : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    var amounts = calculateAmount();

    return Scaffold(
      appBar: customAppBar(text: "Checkout Screen"),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            color: const Color(0xFFF8F5F5),
            height: screenHeight / 12,
            child: Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                child: const Text(
                  "Call process on HyperServices instance on Checkout Button Click",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                )),
          ),
          Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20, top: 15),
                margin: const EdgeInsets.only(bottom: 10),
                child: const Text(
                  "Cart Details",
                  style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFfFB8D33),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFf5f5f5))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Product 1",
                    ),
                    Text("x${widget.productOneCount}"),
                    const Text("₹ 1")
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFf5f5f5))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Product 2",
                    ),
                    Text("x${widget.productTwoCount}"),
                    const Text("₹ 1")
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20, top: 15),
                margin: const EdgeInsets.only(bottom: 10),
                child: const Text(
                  "Amount",
                  style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFfFB8D33),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFf5f5f5))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Amount",
                    ),
                    Text("₹ ${amounts['totalAmount']}")
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFf5f5f5))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Tax",
                    ),
                    Text("₹ ${amounts['tax']}"),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFf5f5f5))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Payable Amount",
                    ),
                    Text("₹ ${amounts['totalPayable']}")
                  ],
                ),
              ),
            ],
          ),
          BottomButton(
              height: screenHeight / 10,
              text: "Checkout",
              onpressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaymentPage(
                            hyperSDK: widget.hyperSDK,
                            amount: amounts['totalAmount'].toString(),
                          ))))
        ],
      ),
    );
  }

  Map<String, double> calculateAmount() {
    var amounts = <String, double>{};

    amounts["totalAmount"] =
        (widget.productOneCount + widget.productTwoCount).toDouble();

    amounts["tax"] = (amounts["totalAmount"] ?? 0) * 0.01;

    amounts["totalPayable"] =
        (amounts["totalAmount"] ?? 0) + (amounts["tax"] ?? 0);

    return amounts;
  }
}
