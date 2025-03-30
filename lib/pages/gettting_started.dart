import 'package:expense_tracker/pages/home.dart';
import 'package:expense_tracker/pages/signup_screen.dart';
import 'package:flutter/material.dart';

class GetttingStarted extends StatelessWidget {
  const GetttingStarted({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width & height
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF7B5CFF),
                  Color(0xFF745CFF),
                ], // Purple gradient
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Positioned Logo (Top-left)
          Positioned(
            top: screenHeight * 0.06,
            left: screenWidth * 0.06,
            child: Image.asset(
              'lib/images/Vector.png',
              width: screenWidth * 0.18,
            ),
          ),

          Positioned(
            bottom: screenHeight * 0.0,

            child: Image.asset(
              'lib/images/recordcircle.png',
              width: screenWidth * 0.44,
            ),
          ),

          Positioned(
            top: screenHeight * 0.0,
            right: screenWidth * 0.00,
            child: Image.asset(
              'lib/images/recordcircle2.png',
              width: screenWidth * 0.44,
            ),
          ),

          Positioned(
            bottom: screenHeight * 0.08,
            left: screenWidth * 0.08,
            right: screenWidth * 0.08,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const HomeScreen(),
                    //   ),
                    // );
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: Image.asset(
                    'lib/images/Group 262.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
