import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:scholar_chat_app/constants.dart';
import 'package:scholar_chat_app/helper/show_snack_bar.dart';
import 'package:scholar_chat_app/screens/chat_secreen.dart';
import 'package:scholar_chat_app/screens/sign_up_screen.dart';

import 'package:scholar_chat_app/widgets/costom_text_field.dart';
import 'package:scholar_chat_app/widgets/custom_buton.dart';

class LogInScreen extends StatefulWidget {
  LogInScreen({super.key});
  static String id = "loginScreen";

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  String? email;

  String? password;
  String? name;

  GlobalKey<FormState> formKey = GlobalKey();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      opacity: 0.9,
      color: KSecondaryColor,
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: KPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                SizedBox(
                  height: 150,
                ),
                Image.asset(
                  height: 100,
                  KLogo,
                ),
                SizedBox(height: 10),
                Center(
                  child: const Text(
                    "Scholar chat",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Pacifico",
                      fontSize: 28,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    const Text(
                      "SIGN IN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                CostomTextFormField(
                  hintText: "Email",
                  onChanged: (value) => email = value,
                ),
                CostomTextFormField(
                  hintText: "Password",
                  onChanged: (value) => password = value,
                ),
                SizedBox(height: 20),
                CustomButon(
                  buttonText: "Sign in",
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      await signInUser(context, email!, password!, name);
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "don't you have an account ?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, SignUpScreen.id);
                      },
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                          color: KSecondaryColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//.......Exeption handeling for.....Creating  User Account ..................

Future<void> signInUser(
  BuildContext context,
  String email,
  String password,
  String? name,
) async {
  try {
    // Try signing in
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    showSnackBar(context, "✅ Successfully signed in!", Colors.green);
    name = userCredential.user!.displayName!;
    Navigator.pushNamed(context, ChatScreen.id,
        arguments: {"email": email, "name": name});
  } on FirebaseAuthException catch (e) {
    String errorMessage;
    errorMessage = errorMessageCheckerForSignIn(e, context);
    showSnackBar(context, errorMessage, Colors.red);
    print(e.code);
  } catch (e) {
    // Non-Firebase errors (network, parsing, etc.)
    String errorMessage = 'An unexpected error occurred. Please try again.';
    showSnackBar(context, errorMessage, Colors.red);
  }
}

String errorMessageCheckerForSignIn(
    FirebaseAuthException e, BuildContext context) {
  String errorMessage;
  switch (e.code) {
    case 'invalid-email':
      errorMessage = '❌ The email address is badly formatted.';
      break;
    case 'user-disabled':
      errorMessage = '🚫 This user account has been disabled.';
      break;
    case 'user-not-found':
      errorMessage = '👤 No user found with this email.';
      break;
    case 'wrong-password':
      errorMessage = '🔑 Incorrect password. Please try again.';
      break;
    case 'too-many-requests':
      errorMessage =
          '⚠️ Too many attempts. Please wait a moment before trying again.';
      break;
    case 'network-request-failed':
      errorMessage = '🌐 Network error. Please check your internet connection.';
      break;
    case 'invalid-credential':
      errorMessage = '🚫 Invalid credentials provided.';
      break;
    case 'operation-not-allowed':
      errorMessage =
          '⚙️ Email/password accounts are not enabled in Firebase Console.';
      break;
    default:
      errorMessage = '❗ An unknown error occurred: ${e.message}';
  }
  return errorMessage;
}
