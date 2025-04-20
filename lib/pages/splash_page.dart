import 'package:eluthozhi_v3/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          // Existing content
          Center(
            child: SizedBox(
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(), // Add spacer to push content to the center
                  Text(
                    'Welcome to',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: getFigmaColor(context, 'Primary', 'Primary Fixed Dim'),
                    ),
                  ),
                  SizedBox(height: 20),
                  SvgPicture.asset(
                    'assets/images/eluthozhi_logo.svg',
                    width: 250,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Learn every words :)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: getFigmaColor(context, 'Primary', 'Primary Fixed Dim'),
                    ),
                  ),
                  Spacer(), // Add spacer to push content to the center
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFA1C7FC),
                      foregroundColor: Colors.black,
                     
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/Login');
                    },
                    child: Text('Get Started'),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
