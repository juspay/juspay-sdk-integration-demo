import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  final double height;
  final String text;
  final Function onpressed;

  const BottomButton({Key? key, required this.height, required this.text, required this.onpressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: InkWell(
        onTap: () => onpressed(),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: const Color(0xFF115390),
              borderRadius: BorderRadius.circular(4)),
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
