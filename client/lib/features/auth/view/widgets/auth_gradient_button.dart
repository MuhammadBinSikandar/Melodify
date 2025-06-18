// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

class AuthGradientButton extends StatefulWidget {
  final String buttonText;
  final VoidCallback OnTap;
  const AuthGradientButton({
    super.key,
    required this.buttonText,
    required this.OnTap,
  });

  @override
  State<AuthGradientButton> createState() => _AuthGradientButtonState();
}

class _AuthGradientButtonState extends State<AuthGradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.OnTap,
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, child) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF7C4DFF), // buttonActive
                  Color(0xFF651FFF), // buttonHover
                  Color(0xFFBB86FC), // neonPurple
                ],
                stops: [0.0, 0.5, 1.0],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.3), // glassBorderStrong
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(
                    0xFF7C4DFF,
                  ).withOpacity(_glowAnimation.value), // glowPurple
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: const Offset(0, 2),
                ),
                BoxShadow(
                  color: const Color(0xFFBB86FC).withOpacity(0.4), // shadowNeon
                  blurRadius: 20,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: widget.OnTap,
                child: Container(
                  width: 395,
                  height: 55,
                  alignment: Alignment.center,
                  child: Text(
                    widget.buttonText,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white, // primaryText
                      letterSpacing: 0.5,
                      shadows: [
                        Shadow(
                          color: const Color(
                            0xFF7C4DFF,
                          ).withOpacity(0.5), // glowPurple
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
