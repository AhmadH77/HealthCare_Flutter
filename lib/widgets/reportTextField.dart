import 'package:flutter/material.dart';

class ReportTextField extends StatelessWidget {
  const ReportTextField(
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
        maxLines: 15,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: labelText,
          filled: true,
          fillColor: Colors.transparent,
          contentPadding:
              const EdgeInsets.only(left: 14.0, bottom: 6.0, top: 8.0),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return "This Field is required";
          }
          return null;
        },
        style: TextStyle(fontSize: 14),
        // decoration: InputDecoration(
        //     labelText: labelText,
        // ),
        obscureText: obscureText ?? false,
      ),
    );
  }
}
