import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.blue,
                width: double.infinity,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
            const Expanded(
                flex: 8,
                child: Center(
                  child: Text(
                    "Payment Successful!",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ))
          ],
        ));
  }
}
