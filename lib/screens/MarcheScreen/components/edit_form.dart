import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:projectpfe/constants.dart';
import 'package:projectpfe/models/Directeur.dart';
import 'package:projectpfe/models/Lots.dart';
import 'package:projectpfe/models/Maitre.dart';
import 'package:projectpfe/models/Marche.dart';
import 'package:projectpfe/models/Operation.dart';
import 'package:projectpfe/screens/MarcheScreen/marches_screen.dart';
import 'package:projectpfe/screens/dashboard/dashboard_screen.dart';

class EditFormMarche extends StatefulWidget {
  const EditFormMarche(List<Marche>? selectedMarches) : super();

  @override
  _EditFormMarcheState createState() => _EditFormMarcheState();
}

class _EditFormMarcheState extends State<EditFormMarche> {
  String? dateTime;

  DateTime selectedDateDebut = DateTime.now();
  DateTime selectedDateFin = DateTime.now();
  DateTime selectedDateMarche = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  List? dataOperations;
  List? dataDirecteurs;
  List? dataMaitres;
  List? dataLots;
  String? selectedOperation;
  String? selectedDirecteur;
  String? selectedMaitre;
  String? selectLot;
  var _idMarcheController = TextEditingController();
  var _numMarcheController = TextEditingController();
  var _dateMarcheController = TextEditingController();
  var _montantMarcheController = TextEditingController();
  var _tauxRetenuGarantieController = TextEditingController();
  var _dejaPayeController = TextEditingController();
  var _dateDebutTravauxController = TextEditingController();
  var _dateFinTravauxController = TextEditingController();
  var _surfacePlancherController = TextEditingController();
  var _avancementController = TextEditingController();
  var _avancementAttacheController = TextEditingController();
  var _seuilRetenueMarcheController = TextEditingController();
  var _seuilPenaliteMarcheController = TextEditingController();
  var _maitreOuvrageController = TextEditingController();
  var _directeurController = TextEditingController();
  var _operationController = TextEditingController();
  var _lotController = TextEditingController();
  static List<Operation>? parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Operation>((json) => Operation.fromJson(json)).toList();
  }

  static List<Directeur>? parseResponsee(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Directeur>((json) => Directeur.fromJson(json)).toList();
  }

  static List<Maitre>? parseResponseMaitre(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Maitre>((json) => Maitre.fromJson(json)).toList();
  }

  static List<LotsMarche>? parseResponseLot(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<LotsMarche>((json) => LotsMarche.fromJson(json)).toList();
  }

  getAllLots() async {
    final response = await http.get(Uri.http(ipAddress, "lots"));
    final jsonresponse = parseResponseLot(response.body);
    setState(() {
      dataLots = jsonresponse;
      print(dataLots);
    });
  }

  //Future method to read the URL
  getAllOperation() async {
    final response = await http.get(Uri.http(ipAddress, "operations"));
    final jsonresponse = parseResponse(response.body);
    setState(() {
      dataOperations = jsonresponse;
      print(dataOperations);
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

  Future updateMarche(int idMarche) async {
    final response = await http.put(
        Uri.http(ipAddress, "/marches/u/${idMarche}"),
        headers: {
          "accept": "application/json",
          "content-type": "application/json"
        },
        body: json.encode({
          "numMarche": _numMarcheController.text,
          "dateMarche": _dateMarcheController.text,
          "montantMarche": _montantMarcheController.text,
          "tauxRetenuGarantie": _tauxRetenuGarantieController.text,
          "dejaPaye": _dejaPayeController.text,
          "dateDebutTravaux": _dateDebutTravauxController.text,
          "dateFinTravaux": _dateFinTravauxController.text,
          "surfacePlancher": _surfacePlancherController.text,
          "avancement": _avancementController.text,
          "avancementAttache": _avancementAttacheController.text,
          "seuilRetenueMarche": _seuilRetenueMarcheController.text,
          "seuilPenaliteMarche": _seuilPenaliteMarcheController.text,
          "lotMarche": _lotController.text,
          "operation": _operationController.text,
          "maitreOuvrage": _maitreOuvrageController.text,
          "directeur": _directeurController.text,
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
        desc: 'Le Marché a été modifié avec succès ...',
        btnOkOnPress: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        btnOkIcon: Icons.check_circle,
      ).show();
    }
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => MarcheScreen(selectedMarches, 0)));
  }

  Future<Null> _selectDateDebut(BuildContext context) async {
    final f = new DateFormat('yyyy-MM-dd');
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDateDebut,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDateDebut = picked;
        _dateDebutTravauxController.text = f.format(selectedDateDebut);
      });
  }

  Future<Null> _selectDateMarche(BuildContext context) async {
    final f = new DateFormat('yyyy-MM-dd');
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDateMarche,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDateMarche = picked;
        _dateMarcheController.text = f.format(selectedDateMarche);
      });
  }

  Future<Null> _selectDateFin(BuildContext context) async {
    final f = new DateFormat('yyyy-MM-dd');
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDateFin,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDateFin = picked;
        _dateFinTravauxController.text = f.format(selectedDateFin);
      });
  }

  _showValues() {
    _idMarcheController.text = selectedMarches!
        .map((e) => e.idMarche)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _numMarcheController.text = selectedMarches!
        .map((e) => e.numMarche)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _dateMarcheController.text = selectedMarches!
        .map((e) => new DateFormat("yyyy-MM-dd")
            .format(DateTime.parse(e.dateMarche.toString())))
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _dateDebutTravauxController.text = selectedMarches!
        .map((e) => new DateFormat("yyyy-MM-dd")
            .format(DateTime.parse(e.dateDebutTravaux.toString())))
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _surfacePlancherController.text = selectedMarches!
        .map((e) => e.surfacePlancher)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _dateFinTravauxController.text = selectedMarches!
        .map((e) => new DateFormat("yyyy-MM-dd")
            .format(DateTime.parse(e.dateFinTravaux.toString())))
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _montantMarcheController.text = selectedMarches!
        .map((e) => e.montantMarche)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _tauxRetenuGarantieController.text = selectedMarches!
        .map((e) => e.tauxRetenuGarantie)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _dejaPayeController.text = selectedMarches!
        .map((e) => e.dejaPaye)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    ;
    _avancementController.text = selectedMarches!
        .map((e) => e.avancement)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _avancementAttacheController.text = selectedMarches!
        .map((e) => e.avancementAttache)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _seuilRetenueMarcheController.text = selectedMarches!
        .map((e) => e.seuilRetenueMarche)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _seuilPenaliteMarcheController.text = selectedMarches!
        .map((e) => e.seuilPenaliteMarche)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    ;
    _maitreOuvrageController.text = selectedMarches!
        .map((e) => e.maitreOuvrage)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _directeurController.text = selectedMarches!
        .map((e) => e.directeur)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _operationController.text = selectedMarches!
        .map((e) => e.operation)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '');
    _lotController.text = selectedMarches!
        .map((e) => e.lotMarche)
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
        title: Text("ID Marche"),
        content: Column(
          children: [
            Container(
              height: 60,
              child: TextFormField(
                enabled: false,
                controller: _idMarcheController,
                decoration: InputDecoration(labelText: "ID Marché"),
              ),
            ),
          ],
        ),
        isActive: _currentStep >= 0,
        state: StepState.disabled,
      ),
      Step(
        title: Text("Numéro & Date Marche"),
        content: Column(
          children: [
            Container(
              height: 60,
              child: TextFormField(
                controller: _numMarcheController,
                decoration: InputDecoration(labelText: "Numéro"),
              ),
            ),
            Container(
              height: 70,
              child: TextFormField(
                onTap: () {
                  _selectDateMarche(context);
                },
                controller: _dateMarcheController,
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    Icons.date_range_outlined,
                    color: Colors.blue,
                  ),
                  labelText: "Date Marché",
                ),
              ),
            )
          ],
        ),
        isActive: _currentStep >= 1,
        state: StepState.complete,
      ),
      Step(
          title: Text("Montant & Taux Garanti & Deja Paye"),
          content: Column(
            children: [
              Container(
                height: 60,
                child: TextFormField(
                  controller: _montantMarcheController,
                  decoration: InputDecoration(labelText: "Montant Marché"),
                ),
              ),
              Container(
                height: 60,
                child: TextFormField(
                  controller: _tauxRetenuGarantieController,
                  decoration:
                      InputDecoration(labelText: "Taux Retenuu Garanti"),
                ),
              ),
              Container(
                height: 60,
                child: TextFormField(
                  controller: _dejaPayeController,
                  decoration: InputDecoration(labelText: "Déja Payé"),
                ),
              ),
            ],
          ),
          isActive: _currentStep >= 2,
          state: StepState.complete),
      Step(
          title: Text("Date Début & Fin des travaux"),
          content: Column(
            children: [
              Container(
                height: 70,
                child: TextFormField(
                  onTap: () {
                    _selectDateDebut(context);
                  },
                  controller: _dateDebutTravauxController,
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.date_range_outlined,
                      color: Colors.blue,
                    ),
                    labelText: "Date Début",
                  ),
                ),
              ),
              Container(
                height: 70,
                child: TextFormField(
                  onTap: () {
                    _selectDateFin(context);
                  },
                  controller: _dateFinTravauxController,
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.date_range_outlined,
                      color: Colors.blue,
                    ),
                    labelText: "Date Fin",
                  ),
                ),
              ),
            ],
          ),
          isActive: _currentStep >= 3,
          state: StepState.complete),
      Step(
          title: Text("Surface Plancher"),
          content: Column(
            children: [
              Container(
                height: 60,
                child: TextFormField(
                  controller: _surfacePlancherController,
                  decoration: InputDecoration(labelText: "Surface Plancher"),
                ),
              ),
            ],
          ),
          isActive: _currentStep >= 4,
          state: StepState.complete),
      Step(
          title: Text("Avancement"),
          content: Column(
            children: [
              Container(
                height: 70,
                child: TextFormField(
                  controller: _avancementController,
                  decoration: InputDecoration(labelText: "Avancement"),
                ),
              ),
              Container(
                height: 70,
                child: TextFormField(
                  controller: _avancementAttacheController,
                  decoration: InputDecoration(labelText: "Avancement Attache"),
                ),
              ),
            ],
          ),
          isActive: _currentStep >= 5,
          state: StepState.complete),
      Step(
          title: Text("Seuil Retenu & Penalite"),
          content: Column(
            children: [
              Container(
                height: 60,
                child: TextFormField(
                  controller: _seuilRetenueMarcheController,
                  maxLines: 3,
                  decoration: InputDecoration(labelText: "Seuil Retenue"),
                ),
              ),
              Container(
                height: 60,
                child: TextFormField(
                  controller: _seuilPenaliteMarcheController,
                  maxLines: 3,
                  decoration: InputDecoration(labelText: "Seuil Penalite"),
                ),
              ),
            ],
          ),
          isActive: _currentStep >= 6,
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
          isActive: _currentStep >= 7,
          state: StepState.complete),
      Step(
          title: Text("Lots & Operation"),
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
                    value: selectLot,
                    hint: Text(
                      "Select Lots",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    items: dataLots!.map((lot) {
                      return DropdownMenuItem(
                        onTap: () {
                          setState(() {
                            _lotController.text = lot.id;
                          });
                        },
                        child: Text(
                          "${lot.designationLot}",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        value: lot.id,
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectLot = value as String?;
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
                    value: selectedOperation,
                    hint: Text(
                      "Select Operation",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    items: dataOperations!.map((o) {
                      return DropdownMenuItem(
                        onTap: () {
                          setState(() {
                            _operationController.text = o.id;
                          });
                        },
                        child: Text(
                          "${o.nomOperation}",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        value: o.id,
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedOperation = value as String?;
                        print(value);
                      });
                    }),
              ),
            ],
          ),
          isActive: _currentStep >= 8,
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
            updateMarche(int.parse(_idMarcheController.text));
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
    selectedProjets;
    // TODO: implement initState
    dataDirecteurs = [];
    dataMaitres = [];
    print("selectd" + selectedProjets!.map((e) => e.nomProjet).toString());
    getAllDirecteur();
    getAllMaitre();
    getAllOperation();
    getAllLots();
    print(dataDirecteurs);
    print(dataMaitres);
    _showValues();
  }
}
