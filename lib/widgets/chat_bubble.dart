import 'package:flutter/material.dart';
import 'package:scholar_chat_app/constants.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
  });
  final String message;
  bool _containsArabic(String input) {
    if (input.isEmpty) return false;
    final arabicRegex = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]');
    return arabicRegex.hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = _containsArabic(message);
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: KPrimaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
          child: Text(
            message,
            textAlign: isRtl ? TextAlign.right : TextAlign.left,
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
