import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isObscureText;
  final bool readOnly;
  final VoidCallback? onTap;
  const CustomField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly,
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
      obscureText: isObscureText,
      obscuringCharacter: '*',
      validator: (value) {
        if (value!.trim().isEmpty) {
          return '$hintText is required';
        }
        return null;
      },
    );
  }
}
