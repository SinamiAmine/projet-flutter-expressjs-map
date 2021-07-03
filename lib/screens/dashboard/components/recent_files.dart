import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:projectpfe/models/Marche.dart';
import 'package:projectpfe/models/Projet.dart';
import 'package:projectpfe/screens/MarcheScreen/marches_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants.dart';

class RecentFiles extends StatefulWidget {
  const RecentFiles({
    Key? key,
  }) : super(key: key);

  @override
  _RecentFilesState createState() => _RecentFilesState();
}

class _RecentFilesState extends State<RecentFiles> {
  Timer? _timer;
  int _start = 5;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  List<Marche>? countriesData;
  List? marcheList;

  getProjets() async {
    try {
      var map = Map<String, dynamic>();
      final response =
          await http.post(Uri.http(ipAddress, "/marche?page=1&limit=4"));
      print('getProjets Response: ${response.body}');
      print('getProjets length: ${response.body.length}');
      setState(() {
        marcheList = json.decode(response.body);
      });
      if (200 == response.statusCode) {
        List<Projet>? list = json.decode(response.body);
        return list;
      } else {
        return <Projet>[];
      }
    } catch (e) {
      return <Projet>[]; // return an empty list on exception/error

    }
  }

/*  loadDataMarches() async {
    String url = ipAddress + "/marches";
    http.Response response = await http.get(Uri.http(ipAddress, "/marches"));
    setState(() {
      countriesData = json.decode(response.body);
      print('hihoooooooooo${countriesData}');
      print('hihoooooooooo${countriesData!.length}');
    });
  }*/

  static List<Marche>? parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Marche>((json) => Marche.fromJson(json)).toList();
  }

  //Future method to read the URL
  fetchInfo() async {
    final response = await http
        .get(Uri.parse("http://" + ipAddress + "/marche?page=1&limit=4"));
    final jsonresponse = parseResponse(response.body);
    if (mounted) {
      setState(() {
        countriesData = jsonresponse;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: countriesData == []
          ? Shimmer.fromColors(
              period: Duration(seconds: 6),
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Marches",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      new MarcheScreen(selectedMarches, 0)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text("Afficher Tous ..",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DataTable(
                      horizontalMargin: 0,
                      columnSpacing: defaultPadding,
                      columns: [
                        DataColumn(
                          label: Text("Numéro"),
                        ),
                        DataColumn(
                          label: Text("Montant"),
                        ),
                        DataColumn(
                          label: Text("Avancement"),
                        ),
                      ],
                      rows: countriesData!
                          .map(
                            (projet) => DataRow(cells: [
                              DataCell(
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/icons/doc_file.svg",
                                      height: 20,
                                      width: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: defaultPadding),
                                      child: Text(
                                        projet.numMarche.toString(),
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(Text(
                                '${projet.montantMarche.toString()}',
                                style: TextStyle(fontSize: 13),
                              )),
                              DataCell(
                                Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: new LinearPercentIndicator(
                                    width: 80,
                                    animation: true,
                                    lineHeight: 18.0,
                                    animationDuration: 2500,
                                    percent: double.parse(
                                            projet.avancement.toString()) /
                                        100,
                                    center: Text(
                                      '${double.parse((projet.avancement.toString()))} %',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    linearStrokeCap: LinearStrokeCap.roundAll,
                                    progressColor: Colors.green,
                                  ),
                                ),
                              ),
                            ]),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Marches",
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    new MarcheScreen(selectedMarches, 0)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Text("Afficher Tous ..",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue)),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    horizontalMargin: 0,
                    columnSpacing: defaultPadding,
                    columns: [
                      DataColumn(
                        label: Text("Numéro"),
                      ),
                      DataColumn(
                        label: Text("Montant"),
                      ),
                      DataColumn(
                        label: Text("Avancement"),
                      ),
                    ],
                    rows: countriesData!
                        .map(
                          (projet) => DataRow(cells: [
                            DataCell(
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/doc_file.svg",
                                    height: 20,
                                    width: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: defaultPadding),
                                    child: Text(
                                      projet.numMarche.toString(),
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(Text(
                              '${projet.montantMarche.toString()}',
                              style: TextStyle(fontSize: 13),
                            )),
                            DataCell(
                              Padding(
                                padding: EdgeInsets.all(15.0),
                                child: new LinearPercentIndicator(
                                  width: 80,
                                  animation: true,
                                  lineHeight: 18.0,
                                  animationDuration: 2500,
                                  percent: double.parse(
                                          projet.avancement.toString()) /
                                      100,
                                  center: Text(
                                    '${double.parse((projet.avancement.toString()))} %',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  linearStrokeCap: LinearStrokeCap.roundAll,
                                  progressColor: Colors.green,
                                ),
                              ),
                            ),
                          ]),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
    );
  }
}

DataRow recentFileDataRow(Projet fileInfo) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            SvgPicture.asset(
              "assets/icons/doc_file.svg",
              height: 30,
              width: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(fileInfo.numAutorisationConstruire!),
            ),
          ],
        ),
      ),
      DataCell(Text(fileInfo.numAutorisationLotir!)),
      DataCell(Text(fileInfo.numAutorisationLotir!)),
    ],
  );
}
