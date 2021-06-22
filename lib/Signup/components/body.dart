import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:projectpfe/Login/login_screen.dart';
import 'package:projectpfe/Signup/components/background.dart';
import 'package:projectpfe/Signup/components/or_divider.dart';
import 'package:projectpfe/Signup/components/social_icon.dart';
import 'package:projectpfe/components/already_have_an_account_check.dart';
import 'package:projectpfe/components/rounded_button.dart';

import '../../../constants.dart';
import '../../../models/user.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();

  Future signUp() async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'authorization': 'Basic c3R1ZHlkb3RlOnN0dWR5ZG90ZTEyMw=='
    };
    final response = await http.post(
        Uri.parse("http://192.168.1.45:5000/signup"),
        headers: {
          "accept": "application/json",
          "content-type": "application/json"
        },
        body: json.encode({"email": user.email, "password": user.password}));
    print(response.body);
    showDialog(
        context: context,
        builder: (a) => _alertDialogSave(),
        barrierDismissible: false);
    /*  Navigator.push(
        context, new MaterialPageRoute(builder: (context) => SplashScreen()));*/
  }

  User user = User('', '');

  Widget _alertDialogSave() {
    return CupertinoAlertDialog(
      title: Text(
        "Saved Successfully",
        style: TextStyle(
            fontSize: 15, color: Colors.black, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        Image(
          image: AssetImage("assets/images/ok.png"),
        ),
        FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Merci",
              style: TextStyle(fontWeight: FontWeight.bold),
            ))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "SIGNUP",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.03),
              SvgPicture.asset(
                "assets/icons/signup.svg",
                height: size.height * 0.35,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                  color: kPrimaryLightColor,
                  borderRadius: BorderRadius.circular(29),
                ),
                child: TextFormField(
                  controller: TextEditingController(text: user.email),
                  onChanged: (value) {
                    user.email = value;
                    print(user.email);
                  },
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.person,
                      color: kPrimaryColor,
                    ),
                    hintText: "Your Email",
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                  color: kPrimaryLightColor,
                  borderRadius: BorderRadius.circular(29),
                ),
                child: TextFormField(
                  onChanged: (value) {
                    user.password = value;
                  },
                  controller: TextEditingController(text: user.password),
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: "Password",
                      icon: Icon(
                        Icons.lock,
                        color: kPrimaryColor,
                      ),
                      suffixIcon: Icon(
                        Icons.visibility,
                        color: kPrimaryColor,
                      ),
                      border: InputBorder.none),
                ),
              ),
              RoundedButton(
                text: "SIGNUP",
                press: () {
                  signUp();
                },
              ),
              SizedBox(height: size.height * 0.03),
              AlreadyHaveAnAccountCheck(
                login: false,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ),
                  );
                },
              ),
              OrDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SocalIcon(
                    iconSrc: "assets/icons/facebook.svg",
                    press: () {},
                  ),
                  SocalIcon(
                    iconSrc: "assets/icons/twitter.svg",
                    press: () {},
                  ),
                  SocalIcon(
                    iconSrc: "assets/icons/google-plus.svg",
                    press: () {},
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
