// splash_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:client/features/auth/view/pages/signup_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Redirect to signup page after 3 seconds
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignupPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Spotify style
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Spotify logo from network
            Image.asset('assets/spotify.png', width: 300, height: 300),
            const SizedBox(height: 30),
            const CircularProgressIndicator(color: Colors.green),
          ],
        ),
      ),
    );
  }
}
