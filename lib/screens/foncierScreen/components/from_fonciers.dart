import 'dart:convert';
import 'dart:core';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart' as ps;
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:projectpfe/constants.dart';
import 'package:projectpfe/models/Foncier.dart';
import 'package:projectpfe/screens/dashboard/dashboard_screen.dart';
import 'package:projectpfe/screens/foncierScreen/fonicer_screen.dart';

class FormFonciers extends StatefulWidget {
  final String latitude;
  final String longitude;
  const FormFonciers(
    List<Foncier>? selectedFonciers,
    this.latitude,
    this.longitude,
  ) : super();

  @override
  _FormFonciersState createState() => _FormFonciersState();
}

class _FormFonciersState extends State<FormFonciers> {
  String? lati;
  String? long;
  GoogleMapController? googleMapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  ps.Position? position;
  void getMarkers(double lat, double long) {
    MarkerId markerId = MarkerId(lat.toString() + long.toString());
    Marker _marker = Marker(
        markerId: markerId,
        position: LatLng(lat, long),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
        infoWindow: InfoWindow(snippet: 'Address'));
    setState(() {
      markers[markerId] = _marker;
    });
  }

  void getCurrentLocation() async {
    ps.Position currentPosition =
        await GeolocatorPlatform.instance.getCurrentPosition();
    setState(() {
      position = currentPosition;
    });
  }

  static const _initialCameraPosition = CameraPosition(
    target: LatLng(33.5333312, -7.583331),
    zoom: 11.5,
  );
  String? dateTime;
  static List<Foncier>? parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Foncier>((json) => Foncier.fromJson(json)).toList();
  }

  DateTime selectedDateConstruire = DateTime.now();
  DateTime selectedDateLotir = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  List? dataFonciers;
  List? dataDirecteurs;
  List? dataMaitres;
  String? selectedFoncier;
  String? selectedDirecteur;
  String? selectedMaitre;
  var _localiteController = TextEditingController();
  var _titreFoncierController = TextEditingController();
  var _denominationController = TextEditingController();
  var _etatController = TextEditingController();
  var _latitudeController = TextEditingController();
  var _longitudeController = TextEditingController();
  var _observationController = TextEditingController();
  var _surfaceTfController = TextEditingController();
  var _niveauFoncierController = TextEditingController();
  var _villeCobtroller = TextEditingController();

/*  getAllFoncier() async {
    final response = await http.get(Uri.http("192.168.1.68:5000", "fonciers"));
    final jsonBody = response.body;
    final jsonData = parseResponse(jsonBody);
    setState(() {
      data = jsonData;
      print(data);
    });
    print(jsonData);
  }*/
  // _addProjet() {
/*    Services.addPatient(
            _nomProjetController!.text,
            _surfaceTitreFoncierController!.text,
            _surfacePlancherController!.text,
            _surfaceLotiController!.text,
            _delaiController!.text,
            _budgetLotiController!.text,
            _numAutorisationConstruireController!.text,
            _dateAutorisationConstruireController!.text,
            _numAutorisationLotirController!.text,
            _dateAutorisationLotirController!.text,
            _observationController!.text,
            _maitreOuvrageController!.text,
            _directeurController!.text,
            _foncierController!.text)
        .then((result) {
      if ('sucess' == result) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => new DataTableProjets()));
      }
    });
  }*/

  Future add() async {
    final response = await http.post(
        Uri.http(ipAddress, "/fonciers/newfoncier"),
        headers: {
          "accept": "application/json",
          "content-type": "application/json"
        },
        body: json.encode({
          "localite": _localiteController.text,
          "titreFoncier": _titreFoncierController.text,
          "denomination": _denominationController.text,
          "etat": _etatController.text,
          "latitude": _latitudeController.text,
          "longitude": _longitudeController.text,
          "observation": _observationController.text,
          "surfaceTf": _surfaceTfController.text,
          "niveauFoncier": _niveauFoncierController.text,
          "ville": _villeCobtroller.text,
        }));
    print(response.body);
    if (200 == response.statusCode) {
      AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        headerAnimationLoop: false,
        dialogType: DialogType.SUCCES,
        showCloseIcon: true,
        title: 'Succès',
        desc: 'Le Foncier a été ajouté avec succès ...',
        btnOkOnPress: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        btnOkIcon: Icons.check_circle,
      ).show();
    }
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => FonciersScreen(selectedFonciers, 0)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new DashboardScreen()));
            },
            child: Icon(Icons.keyboard_return)),
        actions: [],
        title: Text("Insertion Page"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.purple, Colors.blue])),
        ),
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: Container(
              width: double.infinity,
              child: Stepper(
                physics: ClampingScrollPhysics(),
                steps: _stepper(),
                currentStep: this._currentStep,
                onStepTapped: (step) {
                  setState(() {
                    _currentStep = step;
                    print(step);
                  });
                },
                onStepCancel: () {
                  setState(() {
                    _currentStep > 0 ? _currentStep -= 1 : _currentStep = 0;
                  });
                },
                onStepContinue: () {
                  setState(() {
                    _currentStep < _stepper().length - 1
                        ? _currentStep += 1
                        : _currentStep = 0;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Step> _stepper() {
    List<Step> _steps = [
      Step(
        title: Text("Localite"),
        content: Column(
          children: [
            Container(
              height: 60,
              child: TextFormField(
                controller: _localiteController,
                decoration: InputDecoration(labelText: "Localite Foncier"),
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 0,
        state: StepState.complete,
      ),
      Step(
          title: Text("Titre Foncier"),
          content: Column(
            children: [
              Container(
                height: 60,
                child: TextFormField(
                  controller: _titreFoncierController,
                  decoration: InputDecoration(labelText: "Titre Foncier"),
                ),
              ),
              Container(
                height: 60,
                child: TextFormField(
                  controller: _denominationController,
                  decoration: InputDecoration(labelText: "Denomination"),
                ),
              ),
              Container(
                height: 60,
                child: TextFormField(
                  controller: _etatController,
                  decoration: InputDecoration(labelText: "Etat Foncier"),
                ),
              ),
            ],
          ),
          isActive: _currentStep >= 1,
          state: StepState.complete),
      Step(
          title: Text("Latitude & Longitude"),
          content: Column(
            children: [
              GestureDetector(
                child: Container(
                    width: double.infinity,
                    height: 60,
                    padding: EdgeInsets.all(2),
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/mapIcon.svg",
                          height: 60,
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          "Get Position",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        )
                      ],
                    )),
                onTap: () {
                  /*Navigator.push(context,
                      MaterialPageRoute(builder: (context) => new Racine()));*/
                  showDialog(
                      context: (context),
                      builder: (context) {
                        return Container(
                          width: double.infinity,
                          child: AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text(
                              "Select Foncier",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            content: GoogleMap(
                              onTap: (tapped) async {
                                getMarkers(tapped.latitude, tapped.longitude);
                                setState(() {
                                  lati = tapped.latitude.toString();
                                  long = tapped.longitude.toString();
                                  print(lati);
                                  _latitudeController.text = lati.toString();
                                  _longitudeController.text = long.toString();
                                });
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                              mapType: MapType.hybrid,
                              compassEnabled: true,
                              trafficEnabled: true,
                              initialCameraPosition: _initialCameraPosition,
                              onMapCreated: (GoogleMapController controller) {
                                setState(() {
                                  googleMapController = controller;
                                });
                              },
                              markers: Set<Marker>.of(markers.values),
                            ),
                          ),
                        );
                      });
                },
              ),
              Container(
                height: 60,
                child: TextFormField(
                  controller: _latitudeController,
                  decoration: InputDecoration(labelText: "Latitude Foncier"),
                ),
              ),
              Container(
                height: 60,
                child: TextFormField(
                  controller: _longitudeController,
                  decoration: InputDecoration(labelText: "Longitude Foncier"),
                ),
              ),
            ],
          ),
          isActive: _currentStep >= 2,
          state: StepState.complete),
      Step(
          title: Text("Observation"),
          content: Column(
            children: [
              Container(
                height: 60,
                child: TextFormField(
                  controller: _observationController,
                  decoration: InputDecoration(labelText: "Observation"),
                ),
              ),
              Container(
                height: 70,
                child: TextFormField(
                  controller: _surfaceTfController,
                  decoration: InputDecoration(
                    labelText: "Surface TF",
                  ),
                ),
              ),
            ],
          ),
          isActive: _currentStep >= 3,
          state: StepState.complete),
      Step(
          title: Text("Ville Foncier"),
          content: Column(
            children: [
              Container(
                height: 70,
                child: TextFormField(
                  controller: _villeCobtroller,
                  decoration: InputDecoration(
                    labelText: "Ville Foncier",
                  ),
                ),
              ),
            ],
          ),
          isActive: _currentStep >= 4,
          state: StepState.complete),
      Step(
        subtitle: Text(
          "Clicker Sur Ce Button Pour Ajouter Un Foncier",
          style: GoogleFonts.dancingScript(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        title: Text('Submit'),
        content: RaisedButton(
          onPressed: () {
            add();
          },
          child: Row(
            children: [Text("Ajouter"), Icon(Icons.add)],
          ),
          autofocus: true,
        ),
      ),
    ];
    return _steps;
  }

  @override
  void initState() {
    selectedFonciers;
    // TODO: implement initState
    dataFonciers = [];
    dataDirecteurs = [];
    dataMaitres = [];
    print("selectd" + selectedProjets!.map((e) => e.nomProjet).toString());
    print(dataFonciers);
    print(dataDirecteurs);
    print(dataMaitres);
  }
}
