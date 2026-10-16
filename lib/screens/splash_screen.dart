import 'login_screen.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 3),
      () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const LoginScreen(),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      body: Center(

        child: Column(

          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            // ChatNest Logo
            Container(
              height: 120,
              width: 120,

              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),

              child: const Icon(
                Icons.chat_bubble_rounded,
                size: 70,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'ChatNest',

              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Connect. Chat. Stay Connected.',

              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 30),

            // Green Loading Indicator
            const CircularProgressIndicator(
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}