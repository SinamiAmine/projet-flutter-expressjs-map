import 'package:flutter/material.dart';
import 'package:projectpfe/components/text_field_container.dart';

import '../../../models/user.dart';
import '../constants.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  const RoundedPasswordField({
    Key? key,
    this.onChanged,
  }) : super(key: key);

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  User user = User('', '');
  TextEditingController emailController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
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
    );
  }
}
