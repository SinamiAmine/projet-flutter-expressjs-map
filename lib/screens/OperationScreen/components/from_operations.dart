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
import 'package:projectpfe/models/Operation.dart';
import 'package:projectpfe/models/Projet.dart';
import 'package:projectpfe/screens/OperationScreen/operation_screen.dart';
import 'package:projectpfe/screens/dashboard/dashboard_screen.dart';

class FormOperation extends StatefulWidget {
  const FormOperation(List<Operation>? selectedOperations) : super();

  @override
  _FormOperationState createState() => _FormOperationState();
}

class _FormOperationState extends State<FormOperation> {
  String? dateTime;

  DateTime selecteddateAutorisationConstruire = DateTime.now();
  DateTime selecteddateAutorisationLotir = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  List? dataDirecteurs;
  List? dataMaitres;
  List? dataProjet;
  List? dataFoncier;
  String? selectedFoncier;
  String? selectedDirecteur;
  String? selectedMaitre;
  String? selectProjet;
  var _nomOprationController = TextEditingController();
  var _surfaceTitreFoncierController = TextEditingController();
  var _surfacePlancherController = TextEditingController();
  var _surfaceLotiController = TextEditingController();
  var _delaiController = TextEditingController();
  var _budgetController = TextEditingController();
  var _numAutorisationConstruireController = TextEditingController();
  var _dateAutorisationConstruireController = TextEditingController();
  var _numAutorisationLotirController = TextEditingController();
  var _dateAutorisationLotirController = TextEditingController();
  var _foncierController = TextEditingController();
  var _projetController = TextEditingController();
  var _maitreOuvrageController = TextEditingController();
  var _directeurController = TextEditingController();

  static List<Directeur>? parseResponseDirecteur(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Directeur>((json) => Directeur.fromJson(json)).toList();
  }

  static List<Foncier>? parseResponseFoncier(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Foncier>((json) => Foncier.fromJson(json)).toList();
  }

  static List<Maitre>? parseResponseMaitre(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Maitre>((json) => Maitre.fromJson(json)).toList();
  }

  static List<Projet>? parseResponseProjet(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Projet>((json) => Projet.fromJson(json)).toList();
  }

  getAllProjet() async {
    final response = await http.get(Uri.http(ipAddress, "projets"));
    final jsonresponse = parseResponseProjet(response.body);
    setState(() {
      dataProjet = jsonresponse;
      print(dataProjet);
    });
  }

  //Future method to read the URL
  getAllFoncier() async {
    final response = await http.get(Uri.http(ipAddress, "fonciers"));
    final jsonresponse = parseResponseFoncier(response.body);
    setState(() {
      dataFoncier = jsonresponse;
      print(dataFoncier);
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
    final jsonresponsee = parseResponseDirecteur(response.body);
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
    final response = await http.post(
        Uri.http(ipAddress, "/operations/newoperation"),
        headers: {
          "accept": "application/json",
          "content-type": "application/json"
        },
        body: json.encode({
          "nomOperation": _nomOprationController.text,
          "surfaceTitreFoncier": _surfaceTitreFoncierController.text,
          "surfacePlancher": _surfacePlancherController.text,
          "surfaceLoti": _surfaceLotiController.text,
          "delai": _delaiController.text,
          "budget": _budgetController.text,
          "numAutorisationConstruire":
              _numAutorisationConstruireController.text,
          "dateAutorisationConstruire":
              _dateAutorisationConstruireController.text,
          "numAutorisationLotir": _numAutorisationLotirController.text,
          "dateAutorisationLotir": _dateAutorisationLotirController.text,
          "foncier": _foncierController.text,
          "projet": _projetController.text,
          "directeur": _directeurController.text,
          "maitreOuvrage": _maitreOuvrageController.text,
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
        desc: 'L"Operation a été ajouté avec succès ...',
        btnOkOnPress: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        btnOkIcon: Icons.check_circle,
      ).show();
    }
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => OperationScreen(selectedOperations, 0)));
  }

  Future<Null> _selectDateAutorisationConstruire(BuildContext context) async {
    final f = new DateFormat('yyyy-MM-dd');
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selecteddateAutorisationConstruire,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selecteddateAutorisationConstruire = picked;
        _dateAutorisationConstruireController.text =
            f.format(selecteddateAutorisationConstruire);
      });
  }

  Future<Null> _selectDateAutorisationLotir(BuildContext context) async {
    final f = new DateFormat('yyyy-MM-dd');
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selecteddateAutorisationLotir,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selecteddateAutorisationLotir = picked;
        _dateAutorisationLotirController.text =
            f.format(selecteddateAutorisationLotir);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => new DashboardScreen()));
          },
          child: Icon(Icons.keyboard_return),
        ),
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
        title: Text("Nom Operation"),
        content: Column(
          children: [
            Container(
              height: 60,
              child: TextFormField(
                controller: _nomOprationController,
                decoration: InputDecoration(labelText: "Nom Operation"),
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 0,
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
          isActive: _currentStep >= 1,
          state: StepState.complete),
      Step(
          title: Text("Délai & Budget"),
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
                  controller: _budgetController,
                  decoration: InputDecoration(labelText: "Budget"),
                ),
              ),
            ],
          ),
          isActive: _currentStep >= 2,
          state: StepState.complete),
      Step(
          title: Text("Numéro & Date  Autorisation Construire"),
          content: Column(
            children: [
              Container(
                height: 60,
                child: TextFormField(
                  controller: _numAutorisationConstruireController,
                  decoration: InputDecoration(
                      labelText: "Numéro Autorisation Construire"),
                ),
              ),
              Container(
                height: 70,
                child: TextFormField(
                  onTap: () {
                    _selectDateAutorisationConstruire(context);
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
          isActive: _currentStep >= 3,
          state: StepState.complete),
      Step(
          title: Text("Numéro & Date  Autorisation Lotir"),
          content: Column(
            children: [
              Container(
                height: 60,
                child: TextFormField(
                  controller: _numAutorisationLotirController,
                  decoration:
                      InputDecoration(labelText: "Numéro Autorisation Lotir"),
                ),
              ),
              Container(
                height: 70,
                child: TextFormField(
                  onTap: () {
                    _selectDateAutorisationLotir(context);
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
          isActive: _currentStep >= 4,
          state: StepState.complete),
      Step(
          title: Text("Maitre D'ouvrage & Directeur"),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                      "Select Maitre",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    items: dataMaitres!.map((m) {
                      return DropdownMenuItem(
                        onTap: () {
                          setState(() {
                            _maitreOuvrageController.text = m.id;
                          });
                        },
                        child: Text(
                          "${m.raisonSocial}",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        value: m.id,
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedMaitre = value as String?;
                        print(value);
                      });
                    }),
              ),
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
                      "Select Directeur",
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
          isActive: _currentStep >= 5,
          state: StepState.complete),
      Step(
          title: Text("Projet & Foncier"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
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
                    value: selectProjet,
                    hint: Text(
                      "Select Projet",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    items: dataProjet!.map((p) {
                      return DropdownMenuItem(
                        onTap: () {
                          setState(() {
                            _projetController.text = p.id;
                          });
                        },
                        child: Text(
                          "${p.nomProjet}",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        value: p.id,
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectProjet = value as String?;
                        print(value);
                      });
                    }),
              ),
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
                      "Select Foncier",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    items: dataFoncier!.map((f) {
                      return DropdownMenuItem(
                        onTap: () {
                          setState(() {
                            _foncierController.text = f.id;
                          });
                        },
                        child: Text(
                          "${f.localite}",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        value: f.id,
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedFoncier = value as String?;
                        print(value);
                      });
                    }),
              ),
            ],
          ),
          isActive: _currentStep >= 6,
          state: StepState.complete),
      Step(
        subtitle: Text(
          "Clicker Sur Ce Button Pour Ajouter Cette Operation",
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
    selectedOperations;
    dataFoncier = [];
    dataProjet = [];
    dataDirecteurs = [];
    dataMaitres = [];
    print("selectd" + selectedProjets!.map((e) => e.nomProjet).toString());
    getAllDirecteur();
    getAllMaitre();
    getAllFoncier();
    getAllProjet();
  }
}
