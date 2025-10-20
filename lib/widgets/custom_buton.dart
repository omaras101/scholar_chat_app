import 'package:flutter/material.dart';

class CustomButon extends StatelessWidget {
  const CustomButon({super.key, required this.buttonText, this.onTap});
  final String buttonText;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffE7E6E6),
          borderRadius: BorderRadius.circular(15),
        ),
        width: double.infinity,
        height: 50,
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
                color: Color(0xff2B475E),
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
