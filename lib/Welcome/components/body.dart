import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectpfe/Login/login_screen.dart';
import 'package:projectpfe/Signup/signup_screen.dart';
import 'package:projectpfe/Welcome/components/background.dart';
import 'package:projectpfe/components/rounded_button.dart';

import '../../constants.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.09),
            Text("Welcome To Chaabi Liliskane",
                style: GoogleFonts.pacifico(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.black)),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/chat.svg",
              height: size.height * 0.45,
            ),
            SizedBox(height: size.height * 0.09),
            RoundedButton(
              text: "Login",
              press: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ));
              },
            ),
            RoundedButton(
              text: "Sign Up",
              color: kPrimaryLightColor,
              textColor: Colors.black,
              press: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return SignUpScreen();
                  },
                ));
              },
            ),
          ],
        ),
      ),
    );
    ;
  }
}
