import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projectpfe/constants.dart';
import 'package:projectpfe/models/Foncier.dart';
import 'package:projectpfe/screens/dashboard/dashboard_screen.dart';

import '../../../Utils.dart';
import '../fonicer_screen.dart';

class DataTableFoncier extends StatefulWidget {
  DataTableFoncier(List<Foncier>? selectedFonciers) : super();

  final String title = "Data Table Projets";

  @override
  _DataTableFonciertsState createState() => _DataTableFonciertsState();
}

class _DataTableFonciertsState extends State<DataTableFoncier> {
  List? _fonciers;

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
    _fonciers = [];
    selectedFonciers = [];
    fetchInfo();
    selectedFonciers;
  }

  static List<Foncier>? parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Foncier>((json) => Foncier.fromJson(json)).toList();
  }

  //Future method to read the URL
  fetchInfo() async {
    final response = await http.get(Uri.http(ipAddress, "fonciers"));
    final jsonresponse = parseResponse(response.body);
    if (mounted) {
      setState(() {
        _fonciers = jsonresponse;
      });
    }
  }

  deleteFoncier(int codeFoncier) async {
    try {
      var map = Map<String, dynamic>();
      map['codeFocnier'] = codeFoncier;
      final response =
          await http.delete(Uri.http(ipAddress, "fonciers/d/${codeFoncier}"));
      print('deleteFoncier Response: ${response.body}');
      if (200 == response.statusCode) {
        fetchInfo();
        AwesomeDialog(
          context: context,
          animType: AnimType.LEFTSLIDE,
          headerAnimationLoop: false,
          dialogType: DialogType.ERROR,
          showCloseIcon: true,
          title: 'Succès Supression',
          desc: 'Foncier a été supprimé avec succès ...',
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
          setState(() => selectedFonciers =
              isSelectedAll! ? _fonciers as List<Foncier>? : []);
          Utils.showSnackBar(context, 'All Selected: $isSelectedAll');
        },
        sortColumnIndex: sortColumnIndex,
        sortAscending: isAscending,
        dataRowHeight: 80,
        dataTextStyle: TextStyle(fontSize: 13),
        headingTextStyle: TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        dividerThickness: 1,
        showCheckboxColumn: true,
        horizontalMargin: 12,
        columnSpacing: 10,
        columns: [
          DataColumn(
              label: Container(
                  alignment: Alignment.center, child: Text("Localite")),
              numeric: false,
              onSort: onSort),
          DataColumn(
              label:
                  Container(alignment: Alignment.center, child: Text("Titre")),
              numeric: false,
              tooltip: "This is Numero",
              onSort: onSort),
          DataColumn(
            label: Container(
              alignment: Alignment.centerLeft,
              child: Text("Dénomination"),
            ),
            numeric: false,
            tooltip: "This is Foncier",
          ),
          DataColumn(
            label: Container(alignment: Alignment.center, child: Text("Etat")),
            numeric: false,
            tooltip: "This is Directeur",
          ),
          DataColumn(
            label: Text("Surface"),
            numeric: false,
            tooltip: "This is Surface",
          ),
        ],
        rows: _fonciers!
            .map(
              (foncier) => DataRow(
                  selected: selectedFonciers!.contains(foncier),
                  onSelectChanged: (isSelected) => setState(() {
                        final isAdding = isSelected != null && isSelected;
                        isAdding
                            ? selectedFonciers!.add(foncier)
                            : selectedFonciers!.remove(foncier);
                        print(selectedFonciers!.length);
                      }),
                  cells: [
                    DataCell(
                      GestureDetector(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          width: 100,
                          child: Text("${foncier.localite}"),
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                          width: 100, child: Text("${foncier.titreFoncier}")),
                    ),
                    DataCell(
                      Container(
                          width: 100, child: Text("${foncier.denomination}")),
                    ),
                    DataCell(Container(
                      alignment: Alignment.center,
                      height: 25,
                      width: 60,
                      color: Colors.green,
                      child: Text(
                        "${foncier.etat}",
                        style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    )),
                    DataCell(Text(
                      "${double.parse(foncier.surfaceTf.toStringAsFixed(0))} M ",
                    )),
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
        title: Text("Liste Des Fonciers"),
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
          child: Text('Update ${selectedFonciers!.length} Foncier'),
          onPressed: () {
            final id = selectedFonciers!.map((foncier) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FonciersScreen(selectedFonciers, 2),
                )));
            Utils.showSnackBar(context, 'Selected Fonciers: $id');
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
          child: Text('Delete ${selectedFonciers!.length} Fonciers'),
          onPressed: () {
            final id = selectedFonciers!
                .map((foncier) => foncier.codeFoncier)
                .join(', ');
            deleteFoncier(int.parse(id));
            // Utils.showSnackBar(context, 'Selected countries: $id');
          },
        ),
      );

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      _fonciers!.sort((user1, user2) =>
          compareString(ascending, user1.localite, user2.localite));
    } else if (columnIndex == 1) {
      _fonciers!.sort((user1, user2) =>
          compareString(ascending, user1.titreFoncier, user2.titreFoncier));
    } else if (columnIndex == 2) {
      _fonciers!.sort((user1, user2) =>
          compareString(ascending, '${user1.localite}', '${user2.localite}'));
    }
    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
