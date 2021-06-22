import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projectpfe/screens/DirecteurScreen/directeur_screen.dart';
import 'package:projectpfe/screens/MarcheScreen/marches_screen.dart';
import 'package:projectpfe/screens/OperationScreen/operation_screen.dart';
import 'package:projectpfe/screens/foncierScreen/fonicer_screen.dart';

import '../../../constants.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        // it enables scrolling
        child: Column(
          children: [
            DrawerHeader(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  "Chaaabi Liliskane",
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
            DrawerListTile(
              title: "Projets",
              svgSrc: "assets/icons/menu_tran.svg",
              press: () {},
            ),
            DrawerListTile(
              title: "Operations",
              svgSrc: "assets/icons/menu_tran.svg",
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            new OperationScreen(selectedOperations, 0)));
              },
            ),
            DrawerListTile(
              title: "Avancements",
              svgSrc: "assets/icons/menu_task.svg",
              press: () {},
            ),
            DrawerListTile(
              title: "Marches",
              svgSrc: "assets/icons/menu_doc.svg",
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            new MarcheScreen(selectedMarches, 0)));
              },
            ),
            DrawerListTile(
              title: "Directeurs",
              svgSrc: "assets/icons/menu_store.svg",
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            new DirecteurScreen()));
              },
            ),
            DrawerListTile(
              title: "Lots",
              svgSrc: "assets/icons/menu_notification.svg",
              press: () {},
            ),
            DrawerListTile(
              title: "Fonciers",
              svgSrc: "assets/icons/menu_profile.svg",
              press: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            new FonciersScreen(selectedFonciers, 0)));
              },
            ),
            DrawerListTile(
              title: "Settings",
              svgSrc: "assets/icons/menu_setting.svg",
              press: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: Colors.white54),
      ),
    );
  }
}
