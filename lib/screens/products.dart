import 'package:doc_app/screens/payment_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hypersdkflutter/hypersdkflutter.dart';
import 'package:uuid/uuid.dart';

import '../widgets/app_bar.dart';
import '../widgets/bottom_button.dart';

class HomeScreen extends StatefulWidget {
  final HyperSDK hyperSDK;

  const HomeScreen({Key? key, required this.hyperSDK}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var countProductOne = 1;
  var countProductTwo = 0;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: customAppBar(text: "Checkout Screen", context: context),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            color: const Color(0xFFF8F5F5),
            height: screenHeight / 12,
            child: Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20),
                child: const Text(
                  "",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                )),
          ),
          BottomButton(
              height: 100,
              text: "Open Payment Page",
              onpressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaymentPage(
                            hyperSDK: widget.hyperSDK,
                          ))))
        ],
      ),
    );
  }

  Widget singleProduct(double height, String text, int itemCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      height: height / 2,
      child: Column(
        children: [
          Container(
            height: height / 4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Color.fromARGB(255, 121, 119, 119)),
            child: Image.asset(
              text == 'one' ? 'assets/product1.png' : 'assets/product2.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: height / 4,
            color: const Color(0xFFFFFFFF),
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Product $text",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: RichText(
                          text: TextSpan(children: [
                        const TextSpan(
                            text: "Price: Rs. 1/item",
                            style:
                                TextStyle(fontSize: 12, color: Colors.black)),
                        const TextSpan(text: "\n"),
                        const TextSpan(
                            text: "Awesome product description for",
                            style:
                                TextStyle(fontSize: 12, color: Colors.black)),
                        TextSpan(
                            text: "\nproduct $text",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black)),
                      ])),
                    ),
                    Expanded(
                        flex: 2,
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            height: height / 12,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border:
                                    Border.all(color: Colors.black, width: 2)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                GestureDetector(
                                  onTap: () => decreaseItemQuantity(text),
                                  child: const Icon(
                                    Icons.horizontal_rule_rounded,
                                    color: Color(0xFF115390),
                                  ),
                                ),
                                Text(
                                  itemCount.toString(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFB8D33)),
                                ),
                                GestureDetector(
                                    onTap: () => increaseItemQuantity(text),
                                    child: const Icon(Icons.add,
                                        color: Color(0xFF115390)))
                              ],
                            ),
                          ),
                        )),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void increaseItemQuantity(String text) {
    if (text == "one") {
      setState(() {
        countProductOne += 1;
      });
    } else {
      setState(() {
        countProductTwo += 1;
      });
    }
  }

  void decreaseItemQuantity(String text) {
    if (text == "one") {
      setState(() {
        if (countProductOne != 0) {
          countProductOne -= 1;
        }
      });
    } else {
      setState(() {
        if (countProductTwo != 0) {
          countProductTwo -= 1;
        }
      });
    }
  }
}
