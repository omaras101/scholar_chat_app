import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String errorMessage, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(errorMessage), backgroundColor: color),
  );
}
