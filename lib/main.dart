import 'package:flutter/material.dart';
import 'package:scholar_chat_app/screens/chat_secreen.dart';
import 'package:scholar_chat_app/screens/login_screen.dart';
import 'package:scholar_chat_app/screens/sign_up_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final GlobalKey<ScaffoldMessengerState> messengerKey =
    GlobalKey<ScaffoldMessengerState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: messengerKey,
      routes: {
        LogInScreen.id: (context) => LogInScreen(),
        SignUpScreen.id: (context) => SignUpScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
      initialRoute: LogInScreen.id,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: LogInScreen(),
    );
  }
}
