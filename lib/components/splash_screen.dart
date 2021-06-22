import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectpfe/screens/dashboard/dashboard_screen.dart';

import '../../../constants.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clean Code',
      home: AnimatedSplashScreen(
        splashIconSize: 400,
        duration: 3000,
        splash: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logoSVG.png",
              height: 160,
              width: 300,
            ),
            SizedBox(
              height: 50,
            ),
            Text("Loading To Chaabi Liliskane",
                style: GoogleFonts.pacifico(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.white)),
            SizedBox(height: 60),
            CircularProgressIndicator(
              color: Colors.blue,
            )
          ],
        ),
        // nextScreen: Dashboard(),
        splashTransition: SplashTransition.sizeTransition,
        backgroundColor: bgColor,
        animationDuration: Duration(seconds: 3), nextScreen: DashboardScreen(),
      ),
    );
  }
}
