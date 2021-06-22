import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:projectpfe/constants.dart';
import 'package:projectpfe/models/Directeur.dart';
import 'package:projectpfe/models/Foncier.dart';
import 'package:projectpfe/models/Maitre.dart';
import 'package:projectpfe/models/Projet.dart';
import 'package:projectpfe/screens/dashboard/dashboard_screen.dart';

class EditFormProjects extends StatefulWidget {
  const EditFormProjects(List<Projet>? selectedProjets) : super();

  @override
  _EditFormProjectsState createState() => _EditFormProjectsState();
}

class _EditFormProjectsState extends State<EditFormProjects> {
  String? dateTime;

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
  var _nomProjetController = TextEditingController();
  var _surfaceTitreFoncierController = TextEditingController();
  var _surfacePlancherController = TextEditingController();
  var _surfaceLotiController = TextEditingController();
  var _budgetLotiController = TextEditingController();
  var _idProjectController = TextEditingController();
  var _delaiController = TextEditingController();
  var _numAutorisationConstruireController = TextEditingController();
  var _dateAutorisationConstruireController = TextEditingController();
  var _numAutorisationLotirController = TextEditingController();
  var _dateAutorisationLotirController = TextEditingController();
  var _observationController = TextEditingController();
  var _maitreOuvrageController = TextEditingController();
  var _directeurController = TextEditingController();
  var _foncierController = TextEditingController();

  static List<Foncier>? parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Foncier>((json) => Foncier.fromJson(json)).toList();
  }

  static List<Directeur>? parseResponsee(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Directeur>((json) => Directeur.fromJson(json)).toList();
  }

  static List<Maitre>? parseResponseMaitre(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Maitre>((json) => Maitre.fromJson(json)).toList();
  }

  //Future method to read the URL
  getAllFoncier() async {
    final response = await http.get(Uri.http(ipAddress, "fonciers"));
    final jsonresponse = parseResponse(response.body);
    setState(() {
      dataFonciers = jsonresponse;
      print(dataFonciers);
    });
  }

  getAllMaitre() async {
    final response = await http.get(Uri.http(ipAddress, "maitres"));
    final jsonresponse = parseResponseMaitre(response.body);
    setState(() {
      dataMaitres = jsonresponse;
      print(dataMaitres);
    });
  }

  //Future method to read the URL
  getAllDirecteur() async {
    final response = await http.get(Uri.http(ipAddress, "directeurs"));
    final jsonresponsee = parseResponsee(response.body);
    setState(() {
      dataDirecteurs = jsonresponsee;
      print(dataDirecteurs);
    });
  }

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
    final response = await http.post(Uri.http(ipAddress, "/projets/newprojet"),
        headers: {
          "accept": "application/json",
          "content-type": "application/json"
        },
        body: json.encode({
          "nomProjet": _nomProjetController.text,
          "surfaceTitreFoncier": _surfaceTitreFoncierController.text,
          "surfacePlancher": _surfacePlancherController.text,
          "surfaceLoti": _surfaceLotiController.text,
          "delai": _delaiController.text,
          "budget": _budgetLotiController.text,
          "numAutorisationConstruire":
              _numAutorisationConstruireController.text,
          "dateAutorisationConstruire":
              _dateAutorisationConstruireController.text,
          "numAutorisationLotir": _numAutorisationLotirController.text,
          "dateAutorisationLotir": _dateAutorisationLotirController.text,
          "observation": _observationController.text,
          "maitreOuvrage": _maitreOuvrageController.text,
          "directeur": _directeurController.text,
          "foncier": _foncierController.text,
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
        desc: 'Le Projet a été ajouté avec succès ...',
        btnOkOnPress: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        btnOkIcon: Icons.check_circle,
      ).show();
    }
    /*  Navigator.push(
        context, new MaterialPageRoute(builder: (context) => SplashScreen()));*/
  }

  Future update(int idProjet) async {
    final response = await http.put(
        Uri.http(ipAddress, "/projets/u/${idProjet}"),
        headers: {
          "accept": "application/json",
          "content-type": "application/json"
        },
        body: json.encode({
          "nomProjet": _nomProjetController.text,
          "surfaceTitreFoncier": _surfaceTitreFoncierController.text,
          "surfacePlancher": _surfacePlancherController.text,
          "surfaceLoti": _surfaceLotiController.text,
          "delai": _delaiController.text,
          "budget": _budgetLotiController.text,
          "numAutorisationConstruire":
              _numAutorisationConstruireController.text,
          "dateAutorisationConstruire":
              _dateAutorisationConstruireController.text,
          "numAutorisationLotir": _numAutorisationLotirController.text,
          "dateAutorisationLotir": _dateAutorisationLotirController.text,
          "observation": _observationController.text,
          "maitreOuvrage": _maitreOuvrageController.text,
          "directeur": _directeurController.text,
          "foncier": _foncierController.text,
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
        desc: 'Le Projet a été modifié avec succès ...',
        btnOkOnPress: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        btnOkIcon: Icons.check_circle,
      ).show();
    }
    /*  Navigator.push(
        context, new MaterialPageRoute(builder: (context) => SplashScreen()));*/
  }

  Future<Null> _selectDateConstruire(BuildContext context) async {
    final f = new DateFormat('yyyy-MM-dd');
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDateConstruire,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDateConstruire = picked;
        _dateAutorisationConstruireController.text =
            f.format(selectedDateConstruire);
      });
  }

  Future<Null> _selectDateLotir(BuildContext context) async {
    final f = new DateFormat('yyyy-MM-dd');
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDateLotir,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDateLotir = picked;
        _dateAutorisationLotirController.text = f.format(selectedDateLotir);
      });
  }

  _showValues() {
    _idProjectController.text = selectedProjets!
        .map((e) => e.idProjet)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _nomProjetController.text = selectedProjets!
        .map((e) => e.nomProjet)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _surfaceTitreFoncierController.text = selectedProjets!
        .map((e) => e.surfaceTitreFoncier)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _surfacePlancherController.text = selectedProjets!
        .map((e) => e.surfacePlancher)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _surfaceLotiController.text = selectedProjets!
        .map((e) => e.surfaceLoti)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _delaiController.text = selectedProjets!
        .map((e) => e.delai)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _budgetLotiController.text = selectedProjets!
        .map((e) => e.budget)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _numAutorisationConstruireController.text = selectedProjets!
        .map((e) => e.numAutorisationConstruire)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    ;
    _dateAutorisationConstruireController.text = selectedProjets!
        .map((e) => new DateFormat("yyyy-MM-dd")
            .format(DateTime.parse(e.dateAutorisationConstruire.toString())))
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _numAutorisationLotirController.text = selectedProjets!
        .map((e) => e.numAutorisationLotir)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _dateAutorisationLotirController.text = selectedProjets!
        .map((e) => new DateFormat("yyyy-MM-dd")
            .format(DateTime.parse(e.dateAutorisationLotir.toString())))
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _observationController.text = selectedProjets!
        .map((e) => e.observation)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    ;
    _maitreOuvrageController.text = selectedProjets!
        .map((e) => e.maitreOuvrage)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _directeurController.text = selectedProjets!
        .map((e) => e.directeur)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _foncierController.text = selectedProjets!
        .map((e) => e.foncier)
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
        title: Text("ID Projet"),
        content: Column(
          children: [
            Container(
              height: 60,
              child: TextFormField(
                enabled: false,
                controller: _idProjectController,
                decoration: InputDecoration(labelText: "ID Projet"),
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 0,
        state: StepState.disabled,
      ),
      Step(
        title: Text("Nom Projet"),
        content: Column(
          children: [
            Container(
              height: 60,
              child: TextFormField(
                controller: _nomProjetController,
                decoration: InputDecoration(labelText: "Nom Projet"),
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 1,
        state: StepState.complete,
      ),
      Step(
          title: Text("Surface"),
          content: Column(
            children: [
              Container(
                height: 60,
                child: TextFormField(
                  controller: _surfaceTitreFoncierController,
                  decoration:
                      InputDecoration(labelText: "Surface Titre Foncier"),
                ),
              ),
              Container(
                height: 60,
                child: TextFormField(
                  controller: _surfacePlancherController,
                  decoration: InputDecoration(labelText: "Surface Plancher"),
                ),
              ),
              Container(
                height: 60,
                child: TextFormField(
                  controller: _surfaceLotiController,
                  decoration: InputDecoration(labelText: "Surface Loti"),
                ),
              ),
            ],
          ),
          isActive: _currentStep >= 2,
          state: StepState.complete),
      Step(
          title: Text("Budget & Delai"),
          content: Column(
            children: [
              Container(
                height: 60,
                child: TextFormField(
                  controller: _delaiController,
                  decoration: InputDecoration(labelText: "Delai"),
                ),
              ),
              Container(
                height: 60,
                child: TextFormField(
                  controller: _budgetLotiController,
                  decoration: InputDecoration(labelText: "Budget"),
                ),
              ),
            ],
          ),
          isActive: _currentStep >= 3,
          state: StepState.complete),
      Step(
          title: Text("Info Autorisation Construire"),
          content: Column(
            children: [
              Container(
                height: 60,
                child: TextFormField(
                  controller: _numAutorisationConstruireController,
                  decoration:
                      InputDecoration(labelText: "№ Autorisation Construire"),
                ),
              ),
              Container(
                height: 70,
                child: TextFormField(
                  onTap: () {
                    _selectDateConstruire(context);
                  },
                  controller: _dateAutorisationConstruireController,
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.date_range_outlined,
                      color: Colors.blue,
                    ),
                    labelText: "Date Autorisation Construire",
                  ),
                ),
              ),
            ],
          ),
          isActive: _currentStep >= 4,
          state: StepState.complete),
      Step(
          title: Text("Info Autorisation Lotir"),
          content: Column(
            children: [
              Container(
                height: 70,
                child: TextFormField(
                  controller: _numAutorisationLotirController,
                  decoration:
                      InputDecoration(labelText: "№ Autorisation Lotir"),
                ),
              ),
              Container(
                height: 70,
                child: TextFormField(
                  onTap: () {
                    _selectDateLotir(context);
                  },
                  controller: _dateAutorisationLotirController,
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.date_range_outlined,
                      color: Colors.blue,
                    ),
                    labelText: "Date Autorisation Lotir",
                  ),
                ),
              ),
            ],
          ),
          isActive: _currentStep >= 5,
          state: StepState.complete),
      Step(
          title: Text("Observation"),
          content: Column(
            children: [
              Container(
                height: 60,
                child: TextFormField(
                  controller: _observationController,
                  maxLines: 3,
                  decoration: InputDecoration(labelText: "Observation"),
                ),
              ),
            ],
          ),
          isActive: _currentStep >= 6,
          state: StepState.complete),
      Step(
          title: Text("Maitre D'ouvrage"),
          content: Column(
            children: [
              Container(
                height: 60,
                alignment: Alignment.topLeft,
                width: double.infinity,
                child: DropdownButton(
                    isExpanded: true,
                    style: TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.black,
                    icon: Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                      size: 16,
                    ),
                    value: selectedMaitre,
                    hint: Text(
                      "Select Un Maitre",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    items: dataMaitres!.map((maitre) {
                      return DropdownMenuItem(
                        onTap: () {
                          setState(() {
                            _maitreOuvrageController.text = maitre.id;
                          });
                        },
                        child: Text(
                          "${maitre.raisonSocial}",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        value: maitre.id,
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedMaitre = value as String?;
                        print(value);
                      });
                    }),
              ),
            ],
          ),
          isActive: _currentStep >= 7,
          state: StepState.complete),
      Step(
          title: Text("Directeur"),
          content: Column(
            children: [
              Container(
                height: 60,
                alignment: Alignment.topLeft,
                width: double.infinity,
                child: DropdownButton(
                    isExpanded: true,
                    style: TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.black,
                    icon: Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                      size: 16,
                    ),
                    value: selectedDirecteur,
                    hint: Text(
                      "Select Un Directeur",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    items: dataDirecteurs!.map((dir) {
                      return DropdownMenuItem(
                        onTap: () {
                          setState(() {
                            _directeurController.text = dir.id;
                          });
                        },
                        child: Text(
                          "${dir.nom} ${dir.prenom}",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        value: dir.id,
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDirecteur = value as String?;
                        print(value);
                      });
                    }),
              ),
            ],
          ),
          isActive: _currentStep >= 8,
          state: StepState.complete),
      Step(
          title: Text("Foncier"),
          content: Column(
            children: [
              Container(
                height: 60,
                alignment: Alignment.topLeft,
                width: double.infinity,
                child: DropdownButton(
                    isExpanded: true,
                    style: TextStyle(color: Colors.white),
                    iconEnabledColor: Colors.black,
                    icon: Icon(
                      Icons.arrow_downward,
                      color: Colors.white,
                      size: 16,
                    ),
                    value: selectedFoncier,
                    hint: Text(
                      "Select Un Foncier",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    items: dataFonciers!.map((list) {
                      return DropdownMenuItem(
                        onTap: () {
                          setState(() {
                            _foncierController.text = list.id;
                          });
                        },
                        child: Text(
                          list.localite,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        value: list.id,
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedFoncier = value as String?;
                        print(value);
                      });
                    }),
              ),
              SizedBox(
                height: 0,
              ),
            ],
          ),
          isActive: _currentStep >= 9,
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
            update(int.parse(_idProjectController.text));
          },
          child: Row(
            children: [Text("Modifier"), Icon(Icons.add)],
          ),
          autofocus: true,
        ),
      ),
    ];
    return _steps;
  }

  @override
  void initState() {
    selectedProjets;
    // TODO: implement initState
    dataFonciers = [];
    dataDirecteurs = [];
    dataMaitres = [];
    getAllFoncier();
    print("selectd" + selectedProjets!.map((e) => e.nomProjet).toString());
    getAllDirecteur();
    getAllMaitre();
    print(dataFonciers);
    print(dataDirecteurs);
    print(dataMaitres);
    _nomProjetController = TextEditingController();
    _surfaceTitreFoncierController = TextEditingController();
    _surfacePlancherController = TextEditingController();
    _surfaceLotiController = TextEditingController();
    _delaiController = TextEditingController();
    _budgetLotiController = TextEditingController();
    _numAutorisationConstruireController = TextEditingController();
    _dateAutorisationConstruireController = TextEditingController();
    _numAutorisationLotirController = TextEditingController();
    _dateAutorisationLotirController = TextEditingController();
    _observationController = TextEditingController();
    _maitreOuvrageController = TextEditingController();
    _directeurController = TextEditingController();
    _foncierController = TextEditingController();
    _showValues();
  }
}
