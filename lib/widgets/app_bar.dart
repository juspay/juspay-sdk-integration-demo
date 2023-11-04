import 'package:doc_app/main.dart';
import 'package:doc_app/screens/products.dart';
import 'package:flutter/material.dart';
import 'package:hypersdkflutter/hypersdkflutter.dart';

AppBar customAppBar({
  required String text,
  required BuildContext context,
  VoidCallback? backButtonAction,
}) {
  return AppBar(
    title: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Juspay SDK Integration Demo",
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 5),
        Text(
          text,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    ),
    backgroundColor: const Color(0xFF2E2B2C),
    leading: text == "Home Screen"
        ? null
        : IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => {
                  Navigator.pop(context),
                  if (text == "Payment Status") Navigator.pop(context)
                }),
  );
}
