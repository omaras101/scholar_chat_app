import 'package:flutter/material.dart';

class CostomTextFormField extends StatefulWidget {
  CostomTextFormField({super.key, required this.hintText, this.onChanged});
  final String hintText;
  final Function(String)? onChanged;

  @override
  State<CostomTextFormField> createState() => _CostomTextFormFieldState();
}

class _CostomTextFormFieldState extends State<CostomTextFormField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        obscureText: widget.hintText.toLowerCase().contains('pass')
            ? _obscureText
            : false,
        validator: (value) {
          return validateInput(
              value: value,
              isEmail: widget.hintText == "Email" ? true : false,
              minLength: widget.hintText == "Password" ? 6 : 0);
        },
        style: const TextStyle(color: Colors.white),
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          suffixIcon: widget.hintText.toLowerCase().contains('pass')
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Color.fromARGB(255, 176, 175, 175),
                  ),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                )
              : null,
          filled: false,
          fillColor: Colors.white,
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Color.fromARGB(255, 165, 165, 165)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.white),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(color: Colors.white),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
        ),
      ),
    );
  }
}

/// Validates user input based on specified criteria.

String? validateInput({
  required String? value,
  bool isEmail = false,
  bool allowSpaces = false,
  int minLength = 0,
}) {
  if (value == null || value.trim().isEmpty) {
    return 'This field cannot be empty';
  }

  if (!allowSpaces && value.contains(' ')) {
    return 'No spaces are allowed';
  }

  if (minLength > 0 && value.length < minLength) {
    return 'Must be at least $minLength characters long';
  }

  if (isEmail) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
  }

  return null; // ✅ Valid input
}
