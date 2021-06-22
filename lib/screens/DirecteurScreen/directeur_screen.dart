import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:projectpfe/models/Directeur.dart';
import 'package:projectpfe/screens/dashboard/dashboard_screen.dart';

import '../../constants.dart';
import 'components/common_widgets.dart';

class DirecteurScreen extends StatefulWidget {
  @override
  _DirecteurScreenState createState() => _DirecteurScreenState();
}

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _DirecteurScreenState extends State<DirecteurScreen> {
  final double _borderRadius = 24;
  List<Directeur>? _directeurs;
  List<Directeur>? filteredDirecteurs;
  bool isSearching = false;

  final _debouncer = Debouncer(milliseconds: 500);

  static List<Directeur>? parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Directeur>((json) => Directeur.fromJson(json)).toList();
  }

  List? dire;
  loadDataCountries() async {
    String url = "https://localhost:5000/directeurs";
    http.Response response = await http.get(Uri.parse(url));
    setState(() {
      dire = json.decode(response.body);
      print(dire);
    });
  }

  //Future method to read the URL
  fetchInfo() async {
    final response = await http.get(Uri.http(ipAddress, "directeurs"));
    final jsonresponse = parseResponse(response.body);
    setState(() {
      _directeurs = jsonresponse;
      filteredDirecteurs = _directeurs;
      print("boliss${_directeurs}");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _directeurs = [];
    fetchInfo();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Project',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.purple, Colors.blue])),
          ),
          leading: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => new DashboardScreen()));
              },
              child: Icon(Icons.keyboard_return)),
          automaticallyImplyLeading: true,
          backgroundColor: Colors.blue,
          title: !isSearching
              ? Text('Directeurs')
              : TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      hintText: "Search Directeur Here",
                      hintStyle: TextStyle(color: Colors.white)),
                  onChanged: (string) {
                    _debouncer.run(() {
                      setState(() {
                        filteredDirecteurs = _directeurs!
                            .where((u) => (u.nom!
                                    .toLowerCase()
                                    .contains(string.toLowerCase()) ||
                                u.prenom!
                                    .toLowerCase()
                                    .contains(string.toLowerCase())))
                            .toList();
                      });
                    });
                  },
                ),
          actions: <Widget>[
            isSearching
                ? IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        this.isSearching = false;
                      });
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        this.isSearching = true;
                      });
                    },
                  )
          ],
        ),
        body: ListView.builder(
          itemCount: filteredDirecteurs!.length,
          itemBuilder: (context, index) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(_borderRadius),
                        gradient: LinearGradient(
                            colors: [Color(0xff6DC8F3), Colors.purple],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff73A1F9),
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      top: 0,
                      child: CustomPaint(
                        size: Size(100, 150),
                        painter: CustomCardShapePainter(
                            _borderRadius, Color(0xff6DC8F3), Colors.purple),
                      ),
                    ),
                    Positioned.fill(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.white,
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            flex: 4,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  ' ${_directeurs![index].nom.toString()}  ${_directeurs![index].prenom.toString()}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Avenir',
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  'Matricule : ${_directeurs![index].matricule.toString()}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Avenir',
                                  ),
                                ),
                                Text(
                                  'No Cin : ${_directeurs![index].numCin.toString()}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Avenir',
                                  ),
                                ),
                                Text(
                                  'DateEmbauche : ${new DateFormat("yyyy-MM-dd").format(DateTime.parse(_directeurs![index].dateEmbauche.toString()))}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Avenir',
                                  ),
                                ),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.price_change_outlined,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    Text(
                                      " Prix Par Heure : ",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Flexible(
                                      child: Text(
                                        _directeurs![index]
                                            .prixParHeure
                                            .toString(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Avenir',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  '5.0',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Avenir',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                                RatingBar(rating: 4.4),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PlaceInfo {
  final String name;
  final String category;
  final String location;
  final double rating;
  final Color startColor;
  final Color endColor;

  PlaceInfo(this.name, this.startColor, this.endColor, this.rating,
      this.location, this.category);
}

class CustomCardShapePainter extends CustomPainter {
  final double radius;
  final Color startColor;
  final Color endColor;

  CustomCardShapePainter(this.radius, this.startColor, this.endColor);

  @override
  void paint(Canvas canvas, Size size) {
    var radius = 24.0;

    var paint = Paint();
    paint.shader = ui.Gradient.linear(
        Offset(0, 0), Offset(size.width, size.height), [
      HSLColor.fromColor(startColor).withLightness(0.8).toColor(),
      endColor
    ]);

    var path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - radius, size.height)
      ..quadraticBezierTo(
          size.width, size.height, size.width, size.height - radius)
      ..lineTo(size.width, radius)
      ..quadraticBezierTo(size.width, 0, size.width - radius, 0)
      ..lineTo(size.width - 1.5 * radius, 0)
      ..quadraticBezierTo(-radius, 2 * radius, 0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
