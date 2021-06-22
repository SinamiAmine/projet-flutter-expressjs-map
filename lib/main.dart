import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Welcome/welcome_screen.dart';
import 'constants.dart';
import 'controllers/MenuController.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Project',
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: WelcomeScreen(),
      ),
      providers: [
        ChangeNotifierProvider(create: (_) => MenuController()),
      ],
    );
  }
}
