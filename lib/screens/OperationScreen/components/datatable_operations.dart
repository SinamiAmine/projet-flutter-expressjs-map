import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:projectpfe/constants.dart';
import 'package:projectpfe/models/Operation.dart';
import 'package:projectpfe/screens/OperationScreen/operation_screen.dart';
import 'package:projectpfe/screens/dashboard/dashboard_screen.dart';

import '../../../Utils.dart';

class DataTableOperations extends StatefulWidget {
  DataTableOperations(List<Operation>? selectedOperations) : super();

  final String title = "Data Table Projets";

  @override
  DataTableOperationsState createState() => DataTableOperationsState();
}

class DataTableOperationsState extends State<DataTableOperations> {
  List? _operations;

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
    _operations = [];
    selectedOperations = [];
    fetchInfo();
    selectedOperation;
  }

  static List<Operation>? parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Operation>((json) => Operation.fromJson(json)).toList();
  }

  //Future method to read the URL
  fetchInfo() async {
    final response = await http.get(Uri.http(ipAddress, "operations"));
    final jsonresponse = parseResponse(response.body);
    setState(() {
      _operations = jsonresponse;
      print("boliss${_operations}");
    });
  }

  deleteOperation(int idOperation) async {
    try {
      var map = Map<String, dynamic>();
      map['idOperation'] = idOperation;
      final response =
          await http.delete(Uri.http(ipAddress, "operations/d/${idOperation}"));
      print('deleteMarches Response: ${response.body}');
      if (200 == response.statusCode) {
        fetchInfo();
        AwesomeDialog(
          context: context,
          animType: AnimType.LEFTSLIDE,
          headerAnimationLoop: false,
          dialogType: DialogType.ERROR,
          showCloseIcon: true,
          title: 'Succès Supression',
          desc: "L'Operation a été supprimé avec succès ...",
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
          setState(() => selectedOperations =
              isSelectedAll! ? _operations as List<Operation>? : []);
          Utils.showSnackBar(context, 'All Selected: $isSelectedAll');
        },
        sortColumnIndex: sortColumnIndex,
        sortAscending: isAscending,
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
        columnSpacing: 10,
        columns: [
          DataColumn(
              label: Text("Name"),
              numeric: false,
              tooltip: "This is Name Of Projet",
              onSort: onSort),
          DataColumn(
              label: Text("Surface"),
              numeric: false,
              tooltip: "This is Numero",
              onSort: onSort),
          DataColumn(
            label: Text("Foncier"),
            numeric: false,
            tooltip: "This is Foncier",
          ),
          DataColumn(
            label: Text("Projet"),
            numeric: false,
            tooltip: "This is Directeur",
          ),
          DataColumn(
            label: Text("Maitre "),
            numeric: false,
            tooltip: "This is Surface",
          ),
        ],
        rows: _operations!
            .map(
              (operation) => DataRow(
                  selected: selectedOperations!.contains(operation),
                  onSelectChanged: (isSelected) => setState(() {
                        final isAdding = isSelected != null && isSelected;
                        isAdding
                            ? selectedOperations!.add(operation)
                            : selectedOperations!.remove(operation);
                        print(selectedOperations!.length);
                      }),
                  cells: [
                    DataCell(
                      GestureDetector(
                        child: Container(
                          child: Text("${operation.nomOperation}"),
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                          child: Text("${operation.surfaceTitreFoncier}")),
                    ),
                    DataCell(
                      Container(
                          color: Colors.white,
                          child: Text(
                            "${operation.foncier['localite']}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          )),
                    ),
                    DataCell(
                      Text("${operation.projet["nomProjet"]}"),
                    ),
                    DataCell(
                      Text("${operation.maitre["raisonSocial"]}"),
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
        title: Text("Liste Des Operations"),
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
          child: Text('Update ${selectedOperations!.length} Operation'),
          onPressed: () {
            final id = selectedOperations!.map((projet) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OperationScreen(selectedOperations, 2),
                )));
            Utils.showSnackBar(context, 'Selected Operations: $id');
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
          child: Text('Delete ${selectedOperations!.length} Operations'),
          onPressed: () {
            final id =
                selectedOperations!.map((op) => op.idOperation).join(', ');
            deleteOperation(int.parse(id));
            // Utils.showSnackBar(context, 'Selected countries: $id');
          },
        ),
      );

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      _operations!.sort((user1, user2) =>
          compareString(ascending, user1.nomOperation, user2.nomOperation));
    } else if (columnIndex == 1) {
      _operations!.sort((user1, user2) => compareString(
          ascending, user1.surfaceTitreFoncier, user2.surfaceTitreFoncier));
    } else if (columnIndex == 2) {
      _operations!.sort((user1, user2) =>
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
