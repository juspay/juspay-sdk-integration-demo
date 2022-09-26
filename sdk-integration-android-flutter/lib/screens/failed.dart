import 'package:flutter/material.dart';

import '../widgets/app_bar.dart';

class FailedScreen extends StatelessWidget {
  const FailedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(text: "Payment Status"),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                  color: Colors.blue,
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: const Text(
                    "Call process on HyperServices instance on Checkout Button Click",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  )),
            ),
            const Expanded(
                flex: 8,
                child: Center(
                  child: Text(
                    "Payment Failed!",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ))
          ],
        ));
  }
}
