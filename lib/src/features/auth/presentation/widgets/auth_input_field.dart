import 'package:flutter/material.dart';

class AuthInputField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isObscureText;
  final bool isEmail;
  final bool isPhoneNumber;
  final TextEditingController controller;
  const AuthInputField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.controller,
    this.isObscureText = false,
    this.isEmail = false,
    this.isPhoneNumber = false,
    required this.prefixIcon,
    required this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        // contentPadding: EdgeInsets.all(25),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "$labelText is required";
        }
        if (isEmail) {
          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
            return 'Please enter a valid email';
          }
        }

        return null;
      },
      obscureText: isObscureText,
    );
  }
}
