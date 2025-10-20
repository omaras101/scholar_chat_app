import 'package:flutter/material.dart';
import 'package:scholar_chat_app/constants.dart';

class ChatBubbleForAnotherUser extends StatelessWidget {
  const ChatBubbleForAnotherUser({
    super.key,
    required this.message,
    required this.sendername,
  });
  final String message;
  final String sendername;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: KAnoutherUserColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(32),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  sendername.toUpperCase(),
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
