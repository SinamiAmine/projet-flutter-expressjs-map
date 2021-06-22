import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projectpfe/constants.dart';
import 'package:projectpfe/models/Projet.dart';
import 'package:projectpfe/screens/dashboard/dashboard_screen.dart';

import '../../../Utils.dart';
import '../projets_screen.dart';

class DataTableProjets extends StatefulWidget {
  DataTableProjets(List<Projet>? selectedProjets) : super();

  final String title = "Data Table Projets";

  @override
  DataTableProjetsState createState() => DataTableProjetsState();
}

class DataTableProjetsState extends State<DataTableProjets> {
  List? _projets;

  int? sortColumnIndex;
  bool isAscending = false;
/*  loadDataProjet() async {
    String url = ipAddress + "/projets";
    http.Response response = await http.post(Uri.parse(url));
    setState(() {
      projets = json.decode(response.body);
      print('datatable projet  :${projets}');
      print('datatable projet  Length :${projets.length}');
    });
  }*/

  @override
  void initState() {
    sort = false;
    _projets = [];
    selectedProjets = [];
    fetchInfo();
    selectedProjets;
  }

  static List<Projet>? parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Projet>((json) => Projet.fromJson(json)).toList();
  }

  //Future method to read the URL
  fetchInfo() async {
    final response = await http.get(Uri.http(ipAddress, "projets"));
    final jsonresponse = parseResponse(response.body);
    setState(() {
      _projets = jsonresponse;
    });
  }

  deleteProjet(int idProjet) async {
    try {
      var map = Map<String, dynamic>();
      map['idProjet'] = idProjet;
      final response =
          await http.delete(Uri.http(ipAddress, "projets/d/${idProjet}"));
      print('deleteProjets Response: ${response.body}');
      if (200 == response.statusCode) {
        fetchInfo();
        AwesomeDialog(
          context: context,
          animType: AnimType.LEFTSLIDE,
          headerAnimationLoop: false,
          dialogType: DialogType.ERROR,
          showCloseIcon: true,
          title: 'Succès Supression',
          desc: 'Le Projet a été supprimé avec succès ...',
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

  /* getProjetsData() async {
    var response = await http.get(Uri.http("192.168.1.5:5000", 'projets'));
    var jsonData = jsonDecode(response.body);
    Map<String, dynamic> data = new Map<String, dynamic>.from(jsonData);
    List<Projet> prjs = [];

    for (var i in data.values) {
      Projet projet = Projet(
          i["idProjet"],
          i["nomProjet"],
          i["surfaceTitreFoncier"],
          i["surfacePlancher"],
          i["surfacePlancher"],
          i["delai"],
          i["budget"],
          i["numAutorisationConstruire"],
          i["dateAutorisationConstruire"],
          i["numAutorisationLotir"],
          i["dateAutorisationLotir"],
          i["observation"],
          i["maitreOuvrage"],
          i["directeur"],
          i["foncier"]);
      prjs.add(projet);
    }
    print("success : ${prjs.length}");
  }*/

  late bool sort;

/*  onSortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        _projets.sort((a, b) => a.nomProjet.compareTo(b.nomProjet));
      } else {
        _projets.sort((a, b) => b.nomProjet.compareTo(a.nomProjet));
      }
    }
  }*/
/*

  onSelectedRow(bool selected, Projet projet) async {
    setState(() {
      if (selected) {
        selectedUsers.add(projet);
      } else {
        selectedUsers.remove(projet);
      }
    });
  }

  deleteSelected() async {
    setState(() {
      if (selectedUsers.isNotEmpty) {
        List<Projet> temp = [];
        temp.addAll(selectedUsers);
        for (Projet user in temp) {
          _projets.remove(user);
          selectedUsers.remove(user);
        }
      }
    });
  }
*/

  SingleChildScrollView dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      child: DataTable2(
        onSelectAll: (isSelectedAll) {
          setState(() => selectedProjets =
              isSelectedAll! ? _projets as List<Projet>? : []);
          Utils.showSnackBar(context, 'All Selected: $isSelectedAll');
        },
        sortColumnIndex: sortColumnIndex,
        sortAscending: isAscending,
        minWidth: 3,
        dataRowHeight: 80,
        dataTextStyle: TextStyle(fontSize: 13),
        headingTextStyle: TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        dividerThickness: 1,
        showCheckboxColumn: true,
        horizontalMargin: 8,
        columnSpacing: 3,
        columns: [
          DataColumn(
              label: Text("Projets"),
              numeric: false,
              tooltip: "This is Name Of Projet",
              onSort: onSort),
          DataColumn(
              label: Text("Numéro"),
              numeric: false,
              tooltip: "This is Numero",
              onSort: onSort),
          DataColumn(
            label: Text("Directeur"),
            numeric: false,
            tooltip: "This is Directeur",
          ),
          DataColumn(
            label: Text("Surface"),
            numeric: false,
            tooltip: "This is Surface",
          ),
          DataColumn(
            label: Text("Budget"),
            numeric: false,
            tooltip: "This is Surface",
          ),
        ],
        rows: _projets!
            .map(
              (projet) => DataRow(
                  selected: selectedProjets!.contains(projet),
                  onSelectChanged: (isSelected) => setState(() {
                        final isAdding = isSelected != null && isSelected;
                        isAdding
                            ? selectedProjets!.add(projet)
                            : selectedProjets!.remove(projet);
                        print(selectedProjets!.length);
                      }),
                  cells: [
                    DataCell(
                      GestureDetector(
                        child: Container(
                          width: 100,
                          child: Text("${projet.nomProjet}"),
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                          width: 100,
                          child: Text("${projet.numAutorisationLotir}")),
                    ),
                    DataCell(
                      Text(
                          "${projet.directeur["nom"]} ${projet.directeur["prenom"]}"),
                    ),
                    DataCell(
                      Text("${projet.surfaceTitreFoncier}"),
                    ),
                    DataCell(
                      Text("${projet.budget}"),
                    ),
                  ]),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => new DashboardScreen()));
            },
            child: Icon(Icons.keyboard_return)),
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Colors.purple, Colors.blue]))),
        title: Text("Liste Des Projets"),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          SizedBox(
            height: 6,
          ),
          Expanded(
            child: dataBody(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSubmit(),
              buildDelete(),
            ],
          ),
          SizedBox(
            height: 17,
          )
        ],
      ),
    );
  }

  Widget buildSubmit() => Container(
        width: 195,
        padding: EdgeInsets.all(10),
        color: bgColor,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: StadiumBorder(),
            minimumSize: Size.fromHeight(40),
          ),
          child: Text('Update ${selectedProjets!.length} Projet'),
          onPressed: () {
            final id = selectedProjets!.map((projet) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProjetsScreen(selectedProjets, 2),
                )));
            Utils.showSnackBar(context, 'Selected Projets: $id');
          },
        ),
      );
  Widget buildDelete() => Container(
        width: 195,
        padding: EdgeInsets.all(10),
        color: bgColor,
        child: RaisedButton(
          shape: StadiumBorder(),
          color: Colors.red,
          child: Text('Delete ${selectedProjets!.length} Projets'),
          onPressed: () {
            final id =
                selectedProjets!.map((projet) => projet.idProjet).join(', ');
            deleteProjet(int.parse(id));
            // Utils.showSnackBar(context, 'Selected countries: $id');
          },
        ),
      );

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      _projets!.sort((user1, user2) =>
          compareString(ascending, user1.nomProjet, user2.nomProjet));
    } else if (columnIndex == 1) {
      _projets!.sort((user1, user2) => compareString(
          ascending, user1.numAutorisationLotir, user2.numAutorisationLotir));
    } else if (columnIndex == 2) {
      _projets!.sort((user1, user2) =>
          compareString(ascending, '${user1.nomProjet}', '${user2.nomProjet}'));
    }
    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
