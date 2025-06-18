// ignore_for_file: non_constant_identifier_names

import 'package:client/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AuthGradientButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback OnTap;
  const AuthGradientButton({
    super.key,
    required this.buttonText,
    required this.OnTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Pallete.gradient1, Pallete.gradient2],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: ElevatedButton(
        onPressed: OnTap,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(395, 55),
          backgroundColor: Pallete.transparentColor,
          shadowColor: Pallete.transparentColor,
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Pallete.backgroundColor,
          ),
        ),
      ),
    );
  }
}
