import 'package:flutter/material.dart';
import 'package:scholar_chat_app/constants.dart';
import 'package:scholar_chat_app/helper/show_snack_bar.dart';
import 'package:scholar_chat_app/widgets/costom_text_field.dart';
import 'package:scholar_chat_app/widgets/custom_buton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({super.key});
  static String id = "singupScreen";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String? email, password, name;

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
                      "SIGN UP",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                CostomTextFormField(
                  hintText: "Name",
                  onChanged: (value) => name = value,
                ),
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
                  buttonText: "Sign up",
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      await createUserAccount(
                          context, email!, password!, name!);
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
                      "you have an account ?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                        );
                      },
                      child: const Text(
                        "log in",
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

Future<void> createUserAccount(
    BuildContext context, String email, String password, String name) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    await userCredential.user!.updateDisplayName(name);
    String seccessMessage = '🎉 Account created successfully!';
    // print('✅ User created successfully: ${userCredential.user?.email}');
    showSnackBar(context, seccessMessage, Colors.green);
    Navigator.pop(context);
  } on FirebaseAuthException catch (e) {
    String errorMessage;

    errorMessage = errorMessageValueChackerForSignUp(e, context);

    // print('FirebaseAuthException: ${e.code} — ${e.message}');
    showSnackBar(context, errorMessage, Colors.red);
  } catch (e) {
    // Catch all other errors (e.g., JSON conversion, network issues)
    String errorMessage = 'An unexpected error occurred. Please try again.';
    // print('🔥 Unexpected error: $e');
    showSnackBar(context, errorMessage, Colors.red);
  }
}

String errorMessageValueChackerForSignUp(
    FirebaseAuthException e, BuildContext context) {
  String errorMessage;

  switch (e.code) {
    case 'email-already-in-use':
      {
        errorMessage =
            '⚠️ This email is already registered. Try logging in instead.';
        Navigator.pop(context);
      }
      break;
    case 'invalid-email':
      errorMessage = '📧 The email address is not valid.';
      break;
    case 'operation-not-allowed':
      errorMessage =
          '🚫 Email/password accounts are not enabled in Firebase Console.';
      break;
    case 'weak-password':
      errorMessage = '🔑 The password is too weak. Use at least 6 characters.';
      break;
    case 'network-request-failed':
      errorMessage = '🌐 Network error. Please check your internet connection.';
      break;
    case 'too-many-requests':
      errorMessage =
          '⚠️ Too many attempts. Please wait a moment before trying again.';
      break;
    default:
      errorMessage = '❗ An unknown error occurred: ${e.message}';
  }
  return errorMessage;
}
