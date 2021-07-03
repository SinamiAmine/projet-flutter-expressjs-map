import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:projectpfe/components/gradientButton.dart';
import 'package:projectpfe/models/Directeur.dart';
import 'package:projectpfe/screens/DirecteurScreen/directeur_screen.dart';
import 'package:projectpfe/screens/dashboard/dashboard_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants.dart';
import 'common_widgets.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
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

class _ListPageState extends State<ListPage> {
  bool isLoading = false;
  final double _borderRadius = 24;
  List<Directeur>? _directeurs;
  List<Directeur>? filteredDirecteurs;
  bool isSearching = false;
  String? dateTime;
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

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  DateTime selectedDateNaissance = DateTime.now();
  DateTime selectedDateEmbauche = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  var _matriculeDirecteurController = TextEditingController();
  var _nomDirecteurController = TextEditingController();
  var _prenomDirecteurController = TextEditingController();
  var _numCinDirecteurController = TextEditingController();
  var _telephoneDirecteurController = TextEditingController();
  var _emailDirecteurController = TextEditingController();
  var _dateNaissanceDirecteurController = TextEditingController();
  var _dateEmbaucheDirecteurController = TextEditingController();
  var _prixParHeureDirecteurController = TextEditingController();
  var _numCnssDirecteurController = TextEditingController();
  var _codeDirecteurController = TextEditingController();

  _clearValues() {
    _matriculeDirecteurController.text = "";
    _prenomDirecteurController.text = "";
    _nomDirecteurController.text = "";
    _numCinDirecteurController.text = "";
    _telephoneDirecteurController.text = "";
    _emailDirecteurController.text = "";
    _dateNaissanceDirecteurController.text = "";
    _dateEmbaucheDirecteurController.text = "";
    _emailDirecteurController.text = "";
    _prixParHeureDirecteurController.text = "";
    _numCnssDirecteurController.text = "";
  }

  Future add() async {
    final response = await http.post(
        Uri.http(ipAddress, "/directeurs/newdirecteur"),
        headers: {
          "accept": "application/json",
          "content-type": "application/json"
        },
        body: json.encode({
          "matricule": _matriculeDirecteurController.text,
          "nom": _nomDirecteurController.text,
          "prenom": _prenomDirecteurController.text,
          "numCin": _numCinDirecteurController.text,
          "telephone": _telephoneDirecteurController.text,
          "email": _emailDirecteurController.text,
          "dateNaiss": _dateNaissanceDirecteurController.text,
          "dateEmbauche": _dateEmbaucheDirecteurController.text,
          "prixParHeure": _prixParHeureDirecteurController.text,
          "numCnss": _numCnssDirecteurController.text,
          "code": _codeDirecteurController.text
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
        desc: 'Le Directeur a été ajouté avec succès ...',
        btnOkOnPress: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        btnOkIcon: Icons.check_circle,
      ).show();
    }
    /*  Navigator.push(
        context, new MaterialPageRoute(builder: (context) => SplashScreen()));*/
  }

  Future<Null> _selectDateNaissance(BuildContext context) async {
    final f = new DateFormat('yyyy-MM-dd');
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDateNaissance,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDateNaissance = picked;
        _dateNaissanceDirecteurController.text =
            f.format(selectedDateNaissance);
      });
  }

  Future<Null> _selectDateEmbauche(BuildContext context) async {
    final f = new DateFormat('yyyy-MM-dd');
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDateEmbauche,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDateEmbauche = picked;
        _dateEmbaucheDirecteurController.text = f.format(selectedDateEmbauche);
      });
  }

  deleteDirecteur(int idDir) async {
    try {
      var map = Map<String, dynamic>();
      map['code'] = idDir;
      final response =
          await http.delete(Uri.http(ipAddress, "directeurs/d/${idDir}"));
      print('deleteDirecteurs Response: ${response.body}');
      if (200 == response.statusCode) {
        fetchInfo();
        AwesomeDialog(
          context: context,
          animType: AnimType.LEFTSLIDE,
          headerAnimationLoop: false,
          dialogType: DialogType.ERROR,
          showCloseIcon: true,
          title: 'Succès Supression',
          desc: 'Le Directeur a été supprimé avec succès ...',
          btnOkOnPress: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          btnOkIcon: Icons.check_circle,
        ).show();
        return response.body;
      } else {
        return "error";
      }
    } catch (e) {
      return "error"; // returning just an "error" string to keep this simple...
    }
  }

  Future update(int idDir) async {
    final response = await http.put(
        Uri.http(ipAddress, "/directeurs/u/${idDir}"),
        headers: {
          "accept": "application/json",
          "content-type": "application/json"
        },
        body: json.encode({
          "matricule": _matriculeDirecteurController.text,
          "nom": _nomDirecteurController.text,
          "prenom": _prenomDirecteurController.text,
          "numCin": _numCinDirecteurController.text,
          "telephone": _telephoneDirecteurController.text,
          "email": _emailDirecteurController.text,
          "dateNaiss": _dateNaissanceDirecteurController.text,
          "dateEmbauche": _dateEmbaucheDirecteurController.text,
          "prixParHeure": _prixParHeureDirecteurController.text,
          "numCnss": _numCnssDirecteurController.text,
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
        desc: 'Le Directeur a été modifié avec succès ...',
        btnOkOnPress: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        btnOkIcon: Icons.check_circle,
      ).show();
    }
    /*  Navigator.push(
        context, new MaterialPageRoute(builder: (context) => SplashScreen()));*/
  }

  Future<void> showInformationDialogModification(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          bool isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: Form(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _matriculeDirecteurController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.center_focus_strong,
                          color: Colors.blue,
                        ),
                        labelText: "Matricule Directeur",
                      ),
                    ),
                    TextFormField(
                      controller: _prenomDirecteurController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        labelText: "Prenom Directeur",
                      ),
                    ),
                    TextFormField(
                      controller: _nomDirecteurController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        labelText: "Nom Directeur",
                      ),
                    ),
                    TextFormField(
                      controller: _numCinDirecteurController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.credit_card,
                          color: Colors.blue,
                        ),
                        labelText: "Numéro CIN",
                      ),
                    ),
                    TextFormField(
                      controller: _telephoneDirecteurController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.phone_android,
                          color: Colors.blue,
                        ),
                        labelText: "Telephone",
                      ),
                    ),
                    TextFormField(
                      controller: _emailDirecteurController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.email,
                          color: Colors.blue,
                        ),
                        labelText: "Email Directeur",
                      ),
                    ),
                    TextFormField(
                      onTap: () {
                        _selectDateNaissance(context);
                      },
                      controller: _dateNaissanceDirecteurController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.date_range_outlined,
                          color: Colors.blue,
                        ),
                        labelText: "Date Naissance",
                      ),
                    ),
                    TextFormField(
                      onTap: () {
                        _selectDateNaissance(context);
                      },
                      controller: _dateEmbaucheDirecteurController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.date_range_outlined,
                          color: Colors.blue,
                        ),
                        labelText: "Date Embauche",
                      ),
                    ),
                    TextFormField(
                      controller: _prixParHeureDirecteurController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.price_change_outlined,
                          color: Colors.blue,
                        ),
                        labelText: "Prix par heure",
                      ),
                    ),
                    TextFormField(
                      controller: _numCnssDirecteurController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.accessibility_sharp,
                          color: Colors.blue,
                        ),
                        labelText: "Numéro Cnss",
                      ),
                    ),
                  ],
                )),
              ),
              title: Text('Modifier Directeur'),
              actions: <Widget>[
                Center(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14),
                    color: Colors.blue,
                    child: InkWell(
                      child: Center(
                          child: Text(
                        'Modifier',
                        style: TextStyle(color: Colors.white),
                      )),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ],
            );
          });
        });
  }

  Future<void> showInformationDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          bool isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: SingleChildScrollView(
                child: Form(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _matriculeDirecteurController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.center_focus_strong,
                          color: Colors.blue,
                        ),
                        labelText: "Matricule Directeur",
                      ),
                    ),
                    TextFormField(
                      controller: _prenomDirecteurController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        labelText: "Prenom Directeur",
                      ),
                    ),
                    TextFormField(
                      controller: _nomDirecteurController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        labelText: "Nom Directeur",
                      ),
                    ),
                    TextFormField(
                      controller: _numCinDirecteurController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.credit_card,
                          color: Colors.blue,
                        ),
                        labelText: "Numéro CIN",
                      ),
                    ),
                    TextFormField(
                      controller: _telephoneDirecteurController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.phone_android,
                          color: Colors.blue,
                        ),
                        labelText: "Telephone",
                      ),
                    ),
                    TextFormField(
                      controller: _emailDirecteurController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.email,
                          color: Colors.blue,
                        ),
                        labelText: "Email Directeur",
                      ),
                    ),
                    TextFormField(
                      onTap: () {
                        _selectDateNaissance(context);
                      },
                      controller: _dateNaissanceDirecteurController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.date_range_outlined,
                          color: Colors.blue,
                        ),
                        labelText: "Date Naissance",
                      ),
                    ),
                    TextFormField(
                      onTap: () {
                        _selectDateNaissance(context);
                      },
                      controller: _dateEmbaucheDirecteurController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.date_range_outlined,
                          color: Colors.blue,
                        ),
                        labelText: "Date Embauche",
                      ),
                    ),
                    TextFormField(
                      controller: _prixParHeureDirecteurController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.price_change_outlined,
                          color: Colors.blue,
                        ),
                        labelText: "Prix par heure",
                      ),
                    ),
                    TextFormField(
                      controller: _numCnssDirecteurController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.accessibility_sharp,
                          color: Colors.blue,
                        ),
                        labelText: "Numéro Cnss",
                      ),
                    ),
                  ],
                )),
              ),
              title: Text('Nouveau Directeur'),
              actions: <Widget>[
                Center(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(14),
                    color: Colors.blue,
                    child: InkWell(
                      child: Center(
                          child: Text(
                        'Ajouter',
                        style: TextStyle(color: Colors.white),
                      )),
                      onTap: () {
                        add();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ],
            );
          });
        });
  }

  Future<void> showGestionDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          bool isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Update Or Delete ?'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GradientButton(
                      press: () {},
                      color1: Color(0xff374ABE),
                      color2: Color(0xff64B6FF),
                      text: "Modifier",
                    ),
                    GradientButton(
                      press: () {},
                      color1: Color(0xffbe3772),
                      color2: Color(0xffff6464),
                      text: "Supprimer",
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

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
      isLoading = true;
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
      isLoading = true;
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
    startTimer();
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
            IconButton(
                onPressed: () async {
                  _clearValues();
                  await showInformationDialog(context);
                },
                icon: Icon(Icons.add)),
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
            return isLoading == false && _start == 5
                ? Shimmer.fromColors(
                    period: Duration(seconds: 6),
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              bool isChecked = false;
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                return AlertDialog(
                                  title: Text('Update Or Delete ?'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GradientButton(
                                          press: () {
                                            _matriculeDirecteurController.text =
                                                filteredDirecteurs![index]
                                                    .matricule
                                                    .toString();
                                            _prenomDirecteurController.text =
                                                filteredDirecteurs![index]
                                                    .prenom
                                                    .toString();
                                            _nomDirecteurController.text =
                                                filteredDirecteurs![index]
                                                    .nom
                                                    .toString();
                                            _numCinDirecteurController.text =
                                                filteredDirecteurs![index]
                                                    .numCin
                                                    .toString();
                                            _telephoneDirecteurController.text =
                                                filteredDirecteurs![index]
                                                    .telephone
                                                    .toString();
                                            _emailDirecteurController.text =
                                                filteredDirecteurs![index]
                                                    .email
                                                    .toString();
                                            _dateNaissanceDirecteurController
                                                .text = new DateFormat(
                                                    "yyyy-MM-dd")
                                                .format(DateTime.parse(
                                                    filteredDirecteurs![index]
                                                        .dateNaiss
                                                        .toString()));
                                            _dateEmbaucheDirecteurController
                                                .text = new DateFormat(
                                                    "yyyy-MM-dd")
                                                .format(DateTime.parse(
                                                    filteredDirecteurs![index]
                                                        .dateEmbauche
                                                        .toString()));
                                            _prixParHeureDirecteurController
                                                    .text =
                                                filteredDirecteurs![index]
                                                    .prixParHeure
                                                    .toString();
                                            _numCnssDirecteurController.text =
                                                filteredDirecteurs![index]
                                                    .numCnss
                                                    .toString();
                                            _codeDirecteurController.text =
                                                filteredDirecteurs![index]
                                                    .code
                                                    .toString();
                                            Navigator.pop(context);
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  bool isChecked = false;
                                                  return StatefulBuilder(
                                                      builder:
                                                          (context, setState) {
                                                    return AlertDialog(
                                                      content:
                                                          SingleChildScrollView(
                                                        child: Form(
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              TextFormField(
                                                                controller:
                                                                    _matriculeDirecteurController,
                                                                decoration:
                                                                    InputDecoration(
                                                                  suffixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .center_focus_strong,
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                  labelText:
                                                                      "Matricule Directeur",
                                                                ),
                                                              ),
                                                              TextFormField(
                                                                controller:
                                                                    _prenomDirecteurController,
                                                                decoration:
                                                                    InputDecoration(
                                                                  suffixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .person,
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                  labelText:
                                                                      "Prenom Directeur",
                                                                ),
                                                              ),
                                                              TextFormField(
                                                                controller:
                                                                    _nomDirecteurController,
                                                                decoration:
                                                                    InputDecoration(
                                                                  suffixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .person,
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                  labelText:
                                                                      "Nom Directeur",
                                                                ),
                                                              ),
                                                              TextFormField(
                                                                controller:
                                                                    _numCinDirecteurController,
                                                                decoration:
                                                                    InputDecoration(
                                                                  suffixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .credit_card,
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                  labelText:
                                                                      "Numéro CIN",
                                                                ),
                                                              ),
                                                              TextFormField(
                                                                controller:
                                                                    _telephoneDirecteurController,
                                                                decoration:
                                                                    InputDecoration(
                                                                  suffixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .phone_android,
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                  labelText:
                                                                      "Telephone",
                                                                ),
                                                              ),
                                                              TextFormField(
                                                                controller:
                                                                    _emailDirecteurController,
                                                                decoration:
                                                                    InputDecoration(
                                                                  suffixIcon:
                                                                      Icon(
                                                                    Icons.email,
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                  labelText:
                                                                      "Email Directeur",
                                                                ),
                                                              ),
                                                              TextFormField(
                                                                onTap: () {
                                                                  _selectDateNaissance(
                                                                      context);
                                                                },
                                                                controller:
                                                                    _dateNaissanceDirecteurController,
                                                                decoration:
                                                                    InputDecoration(
                                                                  suffixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .date_range_outlined,
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                  labelText:
                                                                      "Date Naissance",
                                                                ),
                                                              ),
                                                              TextFormField(
                                                                onTap: () {
                                                                  _selectDateNaissance(
                                                                      context);
                                                                },
                                                                controller:
                                                                    _dateEmbaucheDirecteurController,
                                                                decoration:
                                                                    InputDecoration(
                                                                  suffixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .date_range_outlined,
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                  labelText:
                                                                      "Date Embauche",
                                                                ),
                                                              ),
                                                              TextFormField(
                                                                controller:
                                                                    _prixParHeureDirecteurController,
                                                                decoration:
                                                                    InputDecoration(
                                                                  suffixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .price_change_outlined,
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                  labelText:
                                                                      "Prix par heure",
                                                                ),
                                                              ),
                                                              TextFormField(
                                                                controller:
                                                                    _numCnssDirecteurController,
                                                                decoration:
                                                                    InputDecoration(
                                                                  suffixIcon:
                                                                      Icon(
                                                                    Icons
                                                                        .accessibility_sharp,
                                                                    color: Colors
                                                                        .blue,
                                                                  ),
                                                                  labelText:
                                                                      "Numéro Cnss",
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      title: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                'Modifier Directeur'),
                                                            Text(
                                                                _codeDirecteurController
                                                                    .text)
                                                          ]),
                                                      actions: <Widget>[
                                                        Center(
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            padding:
                                                                EdgeInsets.all(
                                                                    14),
                                                            color: Colors.blue,
                                                            child: InkWell(
                                                              child: Center(
                                                                child: Text(
                                                                  'Modifier',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                              onTap: () {
                                                                update(
                                                                  int.parse(
                                                                    filteredDirecteurs![
                                                                            index]
                                                                        .code
                                                                        .toString(),
                                                                  ),
                                                                );
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                new DirecteurScreen(0)));
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  });
                                                });
                                          },
                                          color1: Color(0xff374ABE),
                                          color2: Color(0xff64B6FF),
                                          text: "Modifier",
                                        ),
                                        GradientButton(
                                          press: () {
                                            deleteDirecteur(int.parse(
                                                filteredDirecteurs![index]
                                                    .code
                                                    .toString()));
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        new DirecteurScreen(
                                                            0)));
                                          },
                                          color1: Color(0xffbe3772),
                                          color2: Color(0xffff6464),
                                          text: "Supprimer",
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                            });
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(_borderRadius),
                                  gradient: LinearGradient(
                                      colors: [
                                        Color(0xff6DC8F3),
                                        Colors.purple
                                      ],
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
                                  painter: CustomCardShapePainter(_borderRadius,
                                      Color(0xff6DC8F3), Colors.purple),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            ' default',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Avenir',
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            ' default',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Avenir',
                                            ),
                                          ),
                                          Text(
                                            ' default',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Avenir',
                                            ),
                                          ),
                                          Text(
                                            ' default',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Avenir',
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(
                                                Icons.price_change_outlined,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                              Text(
                                                " Prix Par Heure : ",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  ' default',
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
                      ),
                    ),
                  )
                : _start == 0 && isLoading == true
                    ? GestureDetector(
                        onTap: () {
                          print(filteredDirecteurs![index].code);
                          showDialog(
                              context: context,
                              builder: (context) {
                                bool isChecked = false;
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return AlertDialog(
                                    title: Text('Update Or Delete ?'),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GradientButton(
                                            press: () {
                                              _matriculeDirecteurController
                                                      .text =
                                                  filteredDirecteurs![index]
                                                      .matricule
                                                      .toString();
                                              _prenomDirecteurController.text =
                                                  filteredDirecteurs![index]
                                                      .prenom
                                                      .toString();
                                              _nomDirecteurController.text =
                                                  filteredDirecteurs![index]
                                                      .nom
                                                      .toString();
                                              _numCinDirecteurController.text =
                                                  filteredDirecteurs![index]
                                                      .numCin
                                                      .toString();
                                              _telephoneDirecteurController
                                                      .text =
                                                  filteredDirecteurs![index]
                                                      .telephone
                                                      .toString();
                                              _emailDirecteurController.text =
                                                  filteredDirecteurs![index]
                                                      .email
                                                      .toString();
                                              _dateNaissanceDirecteurController
                                                  .text = new DateFormat(
                                                      "yyyy-MM-dd")
                                                  .format(DateTime.parse(
                                                      filteredDirecteurs![index]
                                                          .dateNaiss
                                                          .toString()));
                                              _dateEmbaucheDirecteurController
                                                  .text = new DateFormat(
                                                      "yyyy-MM-dd")
                                                  .format(DateTime.parse(
                                                      filteredDirecteurs![index]
                                                          .dateEmbauche
                                                          .toString()));
                                              _prixParHeureDirecteurController
                                                      .text =
                                                  filteredDirecteurs![index]
                                                      .prixParHeure
                                                      .toString();
                                              _numCnssDirecteurController.text =
                                                  filteredDirecteurs![index]
                                                      .numCnss
                                                      .toString();
                                              _codeDirecteurController.text =
                                                  filteredDirecteurs![index]
                                                      .code
                                                      .toString();
                                              Navigator.pop(context);
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    bool isChecked = false;
                                                    return StatefulBuilder(
                                                        builder: (context,
                                                            setState) {
                                                      return AlertDialog(
                                                        content:
                                                            SingleChildScrollView(
                                                          child: Form(
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                TextFormField(
                                                                  controller:
                                                                      _matriculeDirecteurController,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    suffixIcon:
                                                                        Icon(
                                                                      Icons
                                                                          .center_focus_strong,
                                                                      color: Colors
                                                                          .blue,
                                                                    ),
                                                                    labelText:
                                                                        "Matricule Directeur",
                                                                  ),
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      _prenomDirecteurController,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    suffixIcon:
                                                                        Icon(
                                                                      Icons
                                                                          .person,
                                                                      color: Colors
                                                                          .blue,
                                                                    ),
                                                                    labelText:
                                                                        "Prenom Directeur",
                                                                  ),
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      _nomDirecteurController,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    suffixIcon:
                                                                        Icon(
                                                                      Icons
                                                                          .person,
                                                                      color: Colors
                                                                          .blue,
                                                                    ),
                                                                    labelText:
                                                                        "Nom Directeur",
                                                                  ),
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      _numCinDirecteurController,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    suffixIcon:
                                                                        Icon(
                                                                      Icons
                                                                          .credit_card,
                                                                      color: Colors
                                                                          .blue,
                                                                    ),
                                                                    labelText:
                                                                        "Numéro CIN",
                                                                  ),
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      _telephoneDirecteurController,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    suffixIcon:
                                                                        Icon(
                                                                      Icons
                                                                          .phone_android,
                                                                      color: Colors
                                                                          .blue,
                                                                    ),
                                                                    labelText:
                                                                        "Telephone",
                                                                  ),
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      _emailDirecteurController,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    suffixIcon:
                                                                        Icon(
                                                                      Icons
                                                                          .email,
                                                                      color: Colors
                                                                          .blue,
                                                                    ),
                                                                    labelText:
                                                                        "Email Directeur",
                                                                  ),
                                                                ),
                                                                TextFormField(
                                                                  onTap: () {
                                                                    _selectDateNaissance(
                                                                        context);
                                                                  },
                                                                  controller:
                                                                      _dateNaissanceDirecteurController,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    suffixIcon:
                                                                        Icon(
                                                                      Icons
                                                                          .date_range_outlined,
                                                                      color: Colors
                                                                          .blue,
                                                                    ),
                                                                    labelText:
                                                                        "Date Naissance",
                                                                  ),
                                                                ),
                                                                TextFormField(
                                                                  onTap: () {
                                                                    _selectDateNaissance(
                                                                        context);
                                                                  },
                                                                  controller:
                                                                      _dateEmbaucheDirecteurController,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    suffixIcon:
                                                                        Icon(
                                                                      Icons
                                                                          .date_range_outlined,
                                                                      color: Colors
                                                                          .blue,
                                                                    ),
                                                                    labelText:
                                                                        "Date Embauche",
                                                                  ),
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      _prixParHeureDirecteurController,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    suffixIcon:
                                                                        Icon(
                                                                      Icons
                                                                          .price_change_outlined,
                                                                      color: Colors
                                                                          .blue,
                                                                    ),
                                                                    labelText:
                                                                        "Prix par heure",
                                                                  ),
                                                                ),
                                                                TextFormField(
                                                                  controller:
                                                                      _numCnssDirecteurController,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    suffixIcon:
                                                                        Icon(
                                                                      Icons
                                                                          .accessibility_sharp,
                                                                      color: Colors
                                                                          .blue,
                                                                    ),
                                                                    labelText:
                                                                        "Numéro Cnss",
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        title: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                  'Modifier Directeur'),
                                                              Text(
                                                                  _codeDirecteurController
                                                                      .text)
                                                            ]),
                                                        actions: <Widget>[
                                                          Center(
                                                            child: Container(
                                                              width: double
                                                                  .infinity,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(14),
                                                              color:
                                                                  Colors.blue,
                                                              child: InkWell(
                                                                child: Center(
                                                                  child: Text(
                                                                    'Modifier',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                                onTap: () {
                                                                  update(
                                                                    int.parse(
                                                                      filteredDirecteurs![
                                                                              index]
                                                                          .code
                                                                          .toString(),
                                                                    ),
                                                                  );
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              new DirecteurScreen(0)));
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    });
                                                  });
                                            },
                                            color1: Color(0xff374ABE),
                                            color2: Color(0xff64B6FF),
                                            text: "Modifier",
                                          ),
                                          GradientButton(
                                            press: () {
                                              deleteDirecteur(int.parse(
                                                  filteredDirecteurs![index]
                                                      .code
                                                      .toString()));
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          new DirecteurScreen(
                                                              0)));
                                            },
                                            color1: Color(0xffbe3772),
                                            color2: Color(0xffff6464),
                                            text: "Supprimer",
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                              });
                        },
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(_borderRadius),
                                    gradient: LinearGradient(
                                        colors: [
                                          Color(0xff6DC8F3),
                                          Colors.purple
                                        ],
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
                                        _borderRadius,
                                        Color(0xff6DC8F3),
                                        Colors.purple),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Icon(
                                                  Icons.price_change_outlined,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                                Text(
                                                  " Prix Par Heure : ",
                                                  style: TextStyle(
                                                      color: Colors.white),
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
                        ),
                      )
                    : Shimmer.fromColors(
                        period: Duration(seconds: 6),
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  bool isChecked = false;
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return AlertDialog(
                                      title: Text('Update Or Delete ?'),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GradientButton(
                                              press: () {
                                                _matriculeDirecteurController
                                                        .text =
                                                    filteredDirecteurs![index]
                                                        .matricule
                                                        .toString();
                                                _prenomDirecteurController
                                                        .text =
                                                    filteredDirecteurs![index]
                                                        .prenom
                                                        .toString();
                                                _nomDirecteurController.text =
                                                    filteredDirecteurs![index]
                                                        .nom
                                                        .toString();
                                                _numCinDirecteurController
                                                        .text =
                                                    filteredDirecteurs![index]
                                                        .numCin
                                                        .toString();
                                                _telephoneDirecteurController
                                                        .text =
                                                    filteredDirecteurs![index]
                                                        .telephone
                                                        .toString();
                                                _emailDirecteurController.text =
                                                    filteredDirecteurs![index]
                                                        .email
                                                        .toString();
                                                _dateNaissanceDirecteurController
                                                        .text =
                                                    new DateFormat("yyyy-MM-dd")
                                                        .format(DateTime.parse(
                                                            filteredDirecteurs![
                                                                    index]
                                                                .dateNaiss
                                                                .toString()));
                                                _dateEmbaucheDirecteurController
                                                        .text =
                                                    new DateFormat("yyyy-MM-dd")
                                                        .format(DateTime.parse(
                                                            filteredDirecteurs![
                                                                    index]
                                                                .dateEmbauche
                                                                .toString()));
                                                _prixParHeureDirecteurController
                                                        .text =
                                                    filteredDirecteurs![index]
                                                        .prixParHeure
                                                        .toString();
                                                _numCnssDirecteurController
                                                        .text =
                                                    filteredDirecteurs![index]
                                                        .numCnss
                                                        .toString();
                                                _codeDirecteurController.text =
                                                    filteredDirecteurs![index]
                                                        .code
                                                        .toString();
                                                Navigator.pop(context);
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      bool isChecked = false;
                                                      return StatefulBuilder(
                                                          builder: (context,
                                                              setState) {
                                                        return AlertDialog(
                                                          content:
                                                              SingleChildScrollView(
                                                            child: Form(
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  TextFormField(
                                                                    controller:
                                                                        _matriculeDirecteurController,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      suffixIcon:
                                                                          Icon(
                                                                        Icons
                                                                            .center_focus_strong,
                                                                        color: Colors
                                                                            .blue,
                                                                      ),
                                                                      labelText:
                                                                          "Matricule Directeur",
                                                                    ),
                                                                  ),
                                                                  TextFormField(
                                                                    controller:
                                                                        _prenomDirecteurController,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      suffixIcon:
                                                                          Icon(
                                                                        Icons
                                                                            .person,
                                                                        color: Colors
                                                                            .blue,
                                                                      ),
                                                                      labelText:
                                                                          "Prenom Directeur",
                                                                    ),
                                                                  ),
                                                                  TextFormField(
                                                                    controller:
                                                                        _nomDirecteurController,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      suffixIcon:
                                                                          Icon(
                                                                        Icons
                                                                            .person,
                                                                        color: Colors
                                                                            .blue,
                                                                      ),
                                                                      labelText:
                                                                          "Nom Directeur",
                                                                    ),
                                                                  ),
                                                                  TextFormField(
                                                                    controller:
                                                                        _numCinDirecteurController,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      suffixIcon:
                                                                          Icon(
                                                                        Icons
                                                                            .credit_card,
                                                                        color: Colors
                                                                            .blue,
                                                                      ),
                                                                      labelText:
                                                                          "Numéro CIN",
                                                                    ),
                                                                  ),
                                                                  TextFormField(
                                                                    controller:
                                                                        _telephoneDirecteurController,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      suffixIcon:
                                                                          Icon(
                                                                        Icons
                                                                            .phone_android,
                                                                        color: Colors
                                                                            .blue,
                                                                      ),
                                                                      labelText:
                                                                          "Telephone",
                                                                    ),
                                                                  ),
                                                                  TextFormField(
                                                                    controller:
                                                                        _emailDirecteurController,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      suffixIcon:
                                                                          Icon(
                                                                        Icons
                                                                            .email,
                                                                        color: Colors
                                                                            .blue,
                                                                      ),
                                                                      labelText:
                                                                          "Email Directeur",
                                                                    ),
                                                                  ),
                                                                  TextFormField(
                                                                    onTap: () {
                                                                      _selectDateNaissance(
                                                                          context);
                                                                    },
                                                                    controller:
                                                                        _dateNaissanceDirecteurController,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      suffixIcon:
                                                                          Icon(
                                                                        Icons
                                                                            .date_range_outlined,
                                                                        color: Colors
                                                                            .blue,
                                                                      ),
                                                                      labelText:
                                                                          "Date Naissance",
                                                                    ),
                                                                  ),
                                                                  TextFormField(
                                                                    onTap: () {
                                                                      _selectDateNaissance(
                                                                          context);
                                                                    },
                                                                    controller:
                                                                        _dateEmbaucheDirecteurController,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      suffixIcon:
                                                                          Icon(
                                                                        Icons
                                                                            .date_range_outlined,
                                                                        color: Colors
                                                                            .blue,
                                                                      ),
                                                                      labelText:
                                                                          "Date Embauche",
                                                                    ),
                                                                  ),
                                                                  TextFormField(
                                                                    controller:
                                                                        _prixParHeureDirecteurController,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      suffixIcon:
                                                                          Icon(
                                                                        Icons
                                                                            .price_change_outlined,
                                                                        color: Colors
                                                                            .blue,
                                                                      ),
                                                                      labelText:
                                                                          "Prix par heure",
                                                                    ),
                                                                  ),
                                                                  TextFormField(
                                                                    controller:
                                                                        _numCnssDirecteurController,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      suffixIcon:
                                                                          Icon(
                                                                        Icons
                                                                            .accessibility_sharp,
                                                                        color: Colors
                                                                            .blue,
                                                                      ),
                                                                      labelText:
                                                                          "Numéro Cnss",
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          title: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                    'Modifier Directeur'),
                                                                Text(
                                                                    _codeDirecteurController
                                                                        .text)
                                                              ]),
                                                          actions: <Widget>[
                                                            Center(
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            14),
                                                                color:
                                                                    Colors.blue,
                                                                child: InkWell(
                                                                  child: Center(
                                                                    child: Text(
                                                                      'Modifier',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  ),
                                                                  onTap: () {
                                                                    update(
                                                                      int.parse(
                                                                        filteredDirecteurs![index]
                                                                            .code
                                                                            .toString(),
                                                                      ),
                                                                    );
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                new DirecteurScreen(0)));
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      });
                                                    });
                                              },
                                              color1: Color(0xff374ABE),
                                              color2: Color(0xff64B6FF),
                                              text: "Modifier",
                                            ),
                                            GradientButton(
                                              press: () {
                                                deleteDirecteur(int.parse(
                                                    filteredDirecteurs![index]
                                                        .code
                                                        .toString()));
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            new DirecteurScreen(
                                                                0)));
                                              },
                                              color1: Color(0xffbe3772),
                                              color2: Color(0xffff6464),
                                              text: "Supprimer",
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                                });
                          },
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(_borderRadius),
                                      gradient: LinearGradient(
                                          colors: [
                                            Color(0xff6DC8F3),
                                            Colors.purple
                                          ],
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
                                          _borderRadius,
                                          Color(0xff6DC8F3),
                                          Colors.purple),
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                ' default',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Avenir',
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                              Text(
                                                ' default',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Avenir',
                                                ),
                                              ),
                                              Text(
                                                ' default',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Avenir',
                                                ),
                                              ),
                                              Text(
                                                ' default',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Avenir',
                                                ),
                                              ),
                                              SizedBox(height: 16),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.price_change_outlined,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                  Text(
                                                    " Prix Par Heure : ",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Flexible(
                                                    child: Text(
                                                      ' default',
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
                                                    fontWeight:
                                                        FontWeight.w700),
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
