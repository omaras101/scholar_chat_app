import 'package:scholar_chat_app/constants.dart';

class Message {
  final String senderName;
  final String message;
  final String senderEmail;
  Message(this.message, this.senderEmail, this.senderName);

  factory Message.fromJson(jsonData) {
    return Message(
        jsonData[KMessage], jsonData[KSenderEmail], jsonData[KSenderName]);
  }
}
