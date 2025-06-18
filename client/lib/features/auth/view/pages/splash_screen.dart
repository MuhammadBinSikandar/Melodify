import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:client/features/home/view/pages/home_page.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _glowAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.3, end: 0.6).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutCubic,
      ),
    );
    _rotateAnimation = Tween<double>(begin: 0, end: 0.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Schedule navigation after a delay
    Timer(const Duration(seconds: 2), () {
      final currentUser = ref.read(currentUserNotifierProvider);
      if (currentUser == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignupPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Homepage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0A0A), // secondaryBackground
              Color(0xFF6A1B9A), // gradientPurple
              Color(0xFF1565C0), // gradientBlue
              Color(0xFF0A0A0A), // secondaryBackground
            ],
            stops: [0.0, 0.4, 0.6, 1.0],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotateAnimation.value,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1), // glassOverlay
                    border: Border.all(
                      color: const Color(
                        0xFFBB86FC,
                      ).withOpacity(0.4), // neonPurple
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFF7C4DFF,
                        ).withOpacity(_glowAnimation.value), // glowPurple
                        blurRadius: 25,
                        spreadRadius: 8,
                      ),
                      BoxShadow(
                        color: const Color(
                          0xFF64B5F6,
                        ).withOpacity(0.3), // neonBlue
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    'assets/images/spotify.png',
                    width: 220,
                    height: 220,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      bottomSheet: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.15), // glassOverlayStrong
              Colors.white.withOpacity(0.05), // glassOverlayLight
            ],
          ),
          border: const Border(
            top: BorderSide(
              color: Color(0xFF00BCD4), // electricBlue
              width: 2,
            ),
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(
                        0xFF00E676,
                      ).withOpacity(_glowAnimation.value), // playButtonActive
                      blurRadius: 12,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color(0xFF00E676),
                  ), // playButtonActive
                  backgroundColor: Color(0xFFBB86FC), // volumeSlider
                  strokeWidth: 4,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
