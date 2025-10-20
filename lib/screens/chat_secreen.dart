import 'package:flutter/material.dart';
import 'package:scholar_chat_app/constants.dart';
import 'package:scholar_chat_app/models/message_modle.dart';
import 'package:scholar_chat_app/widgets/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scholar_chat_app/widgets/chat_bubble_for_anouther_user.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key});
  static String id = "chat_screen";

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  bool _isRTL = false;
  bool _canSend = false;
  final _controller = ScrollController();
  CollectionReference messages =
      FirebaseFirestore.instance.collection(KMessageCollection);

  @override
  void initState() {
    super.initState();
    messageController.addListener(_handleLanguageChange);
  }

  @override
  void dispose() {
    messageController.removeListener(_handleLanguageChange);
    messageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleLanguageChange() {
    final text = messageController.text;
    final isRtlNow = _containsArabic(text);
    final canSendNow = text.trim().isNotEmpty;
    if (isRtlNow != _isRTL || canSendNow != _canSend) {
      setState(() {
        _isRTL = isRtlNow;
        _canSend = canSendNow;
      });
    }
  }

  bool _containsArabic(String input) {
    if (input.isEmpty) return false;
    // basic Arabic unicode blocks
    final arabicRegex = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]');
    return arabicRegex.hasMatch(input);
  }

  void _sendMessage(String email, String name) {
    final value = messageController.text.trim();
    if (value.isEmpty) return;
    messages.add({
      KMessage: value,
      KTimestamp: FieldValue.serverTimestamp(),
      KSenderEmail: email,
      KSenderName: name,
    });
    messageController.clear();
    // hide keyboard after sending
    FocusScope.of(context).unfocus();
    _controller.animateTo(
      0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    var arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var email = arguments["email"];
    var name = arguments["name"];
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy("timestamp", descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            final doc = snapshot.data!.docs[i];
            // DocumentSnapshot's data may be Map<String, dynamic>
            messagesList.add(Message.fromJson(doc));
          }
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    height: 50,
                    KLogo,
                  ),
                  Text(
                    "chat",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              backgroundColor: KPrimaryColor,
            ),
            body: Column(children: [
              Expanded(
                child: ListView.builder(
                    reverse: true,
                    controller: _controller,
                    addAutomaticKeepAlives: true,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      if (email == snapshot.data!.docs[index][KSenderEmail]) {
                        return ChatBubble(
                          message: messagesList[index].message,
                        );
                      } else {
                        return ChatBubbleForAnotherUser(
                          message: messagesList[index].message,
                          sendername: messagesList[index].senderName,
                        );
                      }
                    }),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, bottom: 16, top: 8),
                child: TextField(
                  controller: messageController,
                  textAlign: _isRTL ? TextAlign.right : TextAlign.left,
                  textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
                  onSubmitted: (value) => _sendMessage(email, name),
                  decoration: InputDecoration(
                      hintText: "Type your message here...",
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        color: _canSend ? KPrimaryColor : Colors.grey,
                        onPressed:
                            _canSend ? () => _sendMessage(email, name) : null,
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: KPrimaryColor))),
                ),
              )
            ]),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: KPrimaryColor,
            ),
          );
        }
      },
    );
  }
}
