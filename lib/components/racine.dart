import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectpfe/components/map_screen_hybrid.dart';
import 'package:projectpfe/constants.dart';

class Racine extends StatelessWidget {
  const Racine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapHybrid(),
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
    );
  }
}
