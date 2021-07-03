import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:projectpfe/responsive.dart';
import 'package:projectpfe/screens/MarcheScreen/marches_screen.dart';
import 'package:projectpfe/screens/projetsScreen/projets_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../../../constants.dart';

class MyFiels extends StatelessWidget {
  const MyFiels({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Statistiques",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5,
                  vertical:
                      defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                ),
              ),
              onPressed: () {},
              icon: Icon(Icons.dashboard),
              label: Text("Dashboard"),
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 ? 1.3 : 1,
          ),
          tablet: FileInfoCardGridView(),
          desktop: FileInfoCardGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatefulWidget {
  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  _FileInfoCardGridViewState createState() => _FileInfoCardGridViewState();
}

class _FileInfoCardGridViewState extends State<FileInfoCardGridView> {
  List? dataMarche;
  loadDataCountries() async {
    String url = ipAddress + "/marches";
    http.Response response = await http.post(Uri.http(ipAddress, "/marches"));
    setState(() {
      dataMarche = json.decode(response.body);
      print('Marches : ${dataMarche}');
      print('Marche Length : ${dataMarche!.length}');
    });
  }

  List? dataProjet;
  loadDataProjet() async {
    String url = ipAddress + "/projets";
    http.Response response = await http.post(Uri.http(ipAddress, "/projets"));
    setState(() {
      dataProjet = json.decode(response.body);
      print('Proejt  :${dataProjet}');
      print('Projet Length :${dataProjet!.length}');
    });
  }

  List? dataDirecteur;
  loadDataDirecteur() async {
    String url = ipAddress + "/directeurs";
    http.Response response =
        await http.post(Uri.http(ipAddress, "/directeurs"));
    setState(() {
      dataDirecteur = json.decode(response.body);
      print('Directeur  :${dataDirecteur}');
      print('Directeur Length :${dataDirecteur!.length}');
    });
  }

  List? dataLot;
  loadDataLots() async {
    String url = ipAddress + "/lots";
    http.Response response = await http.post(Uri.http(ipAddress, "/lots"));
    setState(() {
      dataLot = json.decode(response.body);
      print('Lot :${dataLot}');
      print('Lots Length :${dataLot!.length}');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadDataCountries();
    loadDataDirecteur();
    loadDataLots();
    loadDataProjet();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 169,
              padding: EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(defaultPadding * 0.75),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/Documents.svg",
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Text("Projets", style: TextStyle(fontSize: 12)),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                          onTap: () {
                            AwesomeDialog(
                              padding: EdgeInsets.all(10),
                              btnCancelColor: Colors.transparent,
                              btnCancelOnPress: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                              body: Column(
                                children: [
                                  Container(
                                    child: RaisedButton(
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    new ProjetsScreen(
                                                        selectedProjets, 0)));
                                      },
                                      color: Colors.blue,
                                      child: Text('Check Projects'),
                                      padding: EdgeInsets.all(10),
                                    ),
                                  ),
                                ],
                              ),
                              context: context,
                              animType: AnimType.LEFTSLIDE,
                              headerAnimationLoop: false,
                              dialogType: DialogType.INFO,
                              showCloseIcon: true,
                              title: 'Choose',
                              btnOkIcon: Icons.check_circle,
                            ).show();
                          },
                          child: Icon(Icons.more_vert, color: Colors.white54)),
                    ],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    dataProjet!.length != 0
                        ? '${dataProjet!.length} Projets '
                        : '${dataProjet!.length} Projets ',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  ProgressLine(
                    color: Colors.green,
                    percentage: dataProjet!.length != 0
                        ? dataProjet!.length
                        : dataProjet!.length,
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${dataProjet!.length} Documents ',
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(color: Colors.white70),
                      ),
                      Text(
                        '1',
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              width: 169,
              padding: EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(defaultPadding * 0.75),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/Documents.svg",
                          color: Colors.red,
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Text("Marches", style: TextStyle(fontSize: 12)),
                      SizedBox(
                        width: 8,
                      ),
                      GestureDetector(
                          onTap: () {
                            AwesomeDialog(
                              padding: EdgeInsets.all(10),
                              btnCancelColor: Colors.transparent,
                              btnCancelOnPress: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                              body: Column(
                                children: [
                                  Container(
                                    child: RaisedButton(
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    new MarcheScreen(
                                                        selectedMarches, 0)));
                                      },
                                      color: Colors.blue,
                                      child: Text('Check Marchés'),
                                      padding: EdgeInsets.all(10),
                                    ),
                                  ),
                                ],
                              ),
                              context: context,
                              animType: AnimType.LEFTSLIDE,
                              headerAnimationLoop: false,
                              dialogType: DialogType.INFO,
                              showCloseIcon: true,
                              title: 'Choose',
                              btnOkIcon: Icons.check_circle,
                            ).show();
                          },
                          child: Icon(Icons.more_vert, color: Colors.white54))
                    ],
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    '${dataMarche!.length} Marches',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  ProgressLine(
                    color: Colors.red,
                    percentage: dataMarche!.length,
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${dataMarche!.length} Documents',
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(color: Colors.white70),
                      ),
                      Text(
                        '${dataMarche!.length}',
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 169,
              padding: EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(defaultPadding * 0.75),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/Documents.svg",
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text("Directeurs", style: TextStyle(fontSize: 12)),
                      SizedBox(
                        width: 2,
                      ),
                      Icon(Icons.more_vert, color: Colors.white54),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    '${dataDirecteur!.length} Directeurs',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  ProgressLine(
                    color: Colors.blue,
                    percentage: dataDirecteur!.length,
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${dataDirecteur!.length} Documents',
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(color: Colors.white70),
                      ),
                      Text(
                        '${dataDirecteur!.length}',
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              width: 169,
              padding: EdgeInsets.all(defaultPadding),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.all(defaultPadding * 0.75),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: SvgPicture.asset(
                          "assets/icons/Documents.svg",
                          color: Colors.amber,
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text("Lots", style: TextStyle(fontSize: 12)),
                      SizedBox(
                        width: 19,
                      ),
                      Icon(Icons.more_vert, color: Colors.white54)
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    '${dataLot!.length} Lots',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  ProgressLine(
                    color: Colors.amber,
                    percentage: dataLot!.length,
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${dataLot!.length} Documents',
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(color: Colors.white70),
                      ),
                      Text(
                        '${dataLot!.length}',
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(color: Colors.white),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color color;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}

var alertStyle = AlertStyle(
  animationType: AnimationType.fromBottom,
  titleTextAlign: TextAlign.justify,
  isCloseButton: true,
  alertPadding: EdgeInsets.all(3),
  descTextAlign: TextAlign.start,
  animationDuration: Duration(milliseconds: 400),
  alertBorder: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(0.0),
    side: BorderSide(
      color: Colors.grey,
    ),
  ),
  titleStyle: TextStyle(
    color: Colors.white,
  ),
  alertAlignment: Alignment.center,
);
