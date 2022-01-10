import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField(
      {Key? key, this.labelText, this.obscureText, required this.controller})
      : super(key: key);
  final String? labelText;
  final bool? obscureText;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return "This Field is required";
          }
          return null;
        },
        style: TextStyle(fontSize: 14),
        decoration: InputDecoration(
          labelText: labelText,
        ),
        obscureText: obscureText ?? false,
      ),
    );
  }
}
