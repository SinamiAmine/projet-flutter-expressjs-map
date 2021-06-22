import 'package:flutter/material.dart';
import 'package:projectpfe/components/text_field_container.dart';

import '../constants.dart';
import '../models/user.dart';

class RoundedInputField extends StatefulWidget {
  final String? hintText;
  final IconData icon;
  final ValueChanged<String>? onChanged;

  const RoundedInputField({
    Key? key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
  }) : super(key: key);

  @override
  _RoundedInputFieldState createState() => _RoundedInputFieldState();
}

class _RoundedInputFieldState extends State<RoundedInputField> {
  User user = User('', '');

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        controller: TextEditingController(text: user.email),
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          icon: Icon(
            widget.icon,
            color: kPrimaryColor,
          ),
          hintText: widget.hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
