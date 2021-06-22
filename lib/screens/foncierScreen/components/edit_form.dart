import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:projectpfe/constants.dart';
import 'package:projectpfe/models/Foncier.dart';
import 'package:projectpfe/screens/dashboard/dashboard_screen.dart';
import 'package:projectpfe/screens/foncierScreen/fonicer_screen.dart';

class EditFormFoncier extends StatefulWidget {
  const EditFormFoncier(List<Foncier>? selectedFonciers) : super();

  @override
  _EditFormFoncierState createState() => _EditFormFoncierState();
}

class _EditFormFoncierState extends State<EditFormFoncier> {
  String? dateTime;

  DateTime selectedDateConstruire = DateTime.now();
  DateTime selectedDateLotir = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  String? selectedFoncier;
  var _idFoncierController = TextEditingController();
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

  static List<Foncier>? parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Foncier>((json) => Foncier.fromJson(json)).toList();
  }

  Future update(int idFoncier) async {
    final response = await http.put(
        Uri.http(ipAddress, "/fonciers/u/${idFoncier}"),
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
        desc: 'Foncier a été modifié avec succès ...',
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

  _showValues() {
    _idFoncierController.text = selectedFonciers!
        .map((e) => e.codeFoncier)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _localiteController.text = selectedFonciers!
        .map((e) => e.localite)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _titreFoncierController.text = selectedFonciers!
        .map((e) => e.titreFoncier)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _denominationController.text = selectedFonciers!
        .map((e) => e.denomination)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _etatController.text = selectedFonciers!
        .map((e) => e.etat)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _latitudeController.text = selectedFonciers!
        .map((e) => e.latitude)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _longitudeController.text = selectedFonciers!
        .map((e) => e.longitude)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _observationController.text = selectedFonciers!
        .map((e) => e.observation)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    ;
    _surfaceTfController.text = selectedFonciers!
        .map((e) => e.surfaceTf)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _villeCobtroller.text = selectedFonciers!
        .map((e) => e.ville)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
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
        title: Text("Modification Page"),
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
        title: Text("Code Foncier"),
        content: Column(
          children: [
            Container(
              height: 60,
              child: TextFormField(
                enabled: false,
                controller: _idFoncierController,
                decoration: InputDecoration(labelText: "Code Foncier"),
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 0,
        state: StepState.disabled,
      ),
      Step(
        title: Text("Localite Foncier"),
        content: Column(
          children: [
            Container(
              height: 60,
              child: TextFormField(
                controller: _localiteController,
                decoration: InputDecoration(labelText: "Localite"),
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 1,
        state: StepState.complete,
      ),
      Step(
          title: Text("Titre Foncier & Dénomination & Etat"),
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
                  decoration: InputDecoration(labelText: "Dénomination"),
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
          isActive: _currentStep >= 2,
          state: StepState.complete),
      Step(
          title: Text("Latitude & Longitude"),
          content: Column(
            children: [
              Container(
                height: 60,
                child: TextFormField(
                  controller: _latitudeController,
                  decoration: InputDecoration(labelText: "Latitude"),
                ),
              ),
              Container(
                height: 60,
                child: TextFormField(
                  controller: _longitudeController,
                  decoration: InputDecoration(labelText: "Longitude"),
                ),
              ),
            ],
          ),
          isActive: _currentStep >= 3,
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
            ],
          ),
          isActive: _currentStep >= 4,
          state: StepState.complete),
      Step(
          title: Text("Surface TF"),
          content: Column(
            children: [
              Container(
                height: 70,
                child: TextFormField(
                  controller: _surfaceTfController,
                  decoration: InputDecoration(labelText: "Surface TF"),
                ),
              ),
            ],
          ),
          isActive: _currentStep >= 5,
          state: StepState.complete),
      Step(
          title: Text("Ville Foncier"),
          content: Column(
            children: [
              Container(
                height: 60,
                child: TextFormField(
                  controller: _villeCobtroller,
                  maxLines: 3,
                  decoration: InputDecoration(labelText: "Ville Foncier"),
                ),
              ),
            ],
          ),
          isActive: _currentStep >= 6,
          state: StepState.complete),
      Step(
        subtitle: Text(
          "Clicker Sur Ce Button Pour Modifier Ce Projet",
          style: GoogleFonts.dancingScript(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        title: Text('Submit'),
        content: RaisedButton(
          onPressed: () {
            update(int.parse(_idFoncierController.text));
          },
          child: Row(
            children: [Text("Update"), Icon(Icons.add)],
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
    print("selectd" + selectedFonciers!.map((e) => e.localite).toString());
    _showValues();
  }
}
