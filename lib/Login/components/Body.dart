import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projectpfe/Login/components/background.dart';
import 'package:projectpfe/Signup/signup_screen.dart';
import 'package:projectpfe/components/already_have_an_account_check.dart';
import 'package:projectpfe/components/rounded_button.dart';
import 'package:projectpfe/models/user.dart';
import 'package:projectpfe/screens/main/root.dart';

import '../../../constants.dart';

class Body extends StatefulWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String message = "";
  final _formKey = GlobalKey<FormState>();
  Future save() async {
    final response = await http.post(Uri.http(ipAddress, "/signin"),
        headers: {
          "accept": "application/json",
          "content-type": "application/json"
        },
        body: json.encode({"email": user.email, "password": user.password}));
    var userData = jsonDecode(response.body);
    print(response.body);
    print(userData['email']);
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => Root()));
  }

  User user = User('', '');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BackGround(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: size.height,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                    color: Colors.purple,
                    child: Text(
                      "Login Page",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                    onPressed: () {},
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Image.asset(
                  "assets/images/loginImage.jpg",
                  height: size.height * 0.35,
                ),
                SizedBox(height: size.height * 0.03),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  width: size.width * 0.8,
                  decoration: BoxDecoration(
                    color: kPrimaryLightColor,
                    borderRadius: BorderRadius.circular(29),
                  ),
                  child: TextFormField(
                    onFieldSubmitted: (value) {
                      save();
                    },
                    onEditingComplete: () {},
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
                    onEditingComplete: () {},
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
                    text: "LOGIN",
                    press: () {
                      save();
                    }),
                SizedBox(height: size.height * 0.03),
                AlreadyHaveAnAccountCheck(
                  press: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SignUpScreen();
                    }));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
