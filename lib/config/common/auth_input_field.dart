import 'package:flutter/material.dart';

class AuthInputField extends StatefulWidget {
  final String hintText;
  final String labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isObscureText;
  final TextEditingController controller;
  const AuthInputField({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.controller,
    this.isObscureText = false,
    required this.prefixIcon,
    required this.suffixIcon,
  });

  @override
  State<AuthInputField> createState() => _AuthInputFieldState();
}

class _AuthInputFieldState extends State<AuthInputField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        hintText: widget.hintText,
        // contentPadding: EdgeInsets.all(25),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return "${widget.labelText} is required";
        }
        return null;
      },
      obscureText: widget.isObscureText,
    );
  }
}
