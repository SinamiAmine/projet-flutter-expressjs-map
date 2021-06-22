import 'package:flutter/material.dart';
import 'package:projectpfe/models/Foncier.dart';
import 'package:projectpfe/screens/foncierScreen/components/datatable_fonciers.dart';
import 'package:projectpfe/screens/foncierScreen/components/edit_form.dart';
import 'package:projectpfe/screens/foncierScreen/components/from_fonciers.dart';

import '../../constants.dart';

class FonciersScreen extends StatefulWidget {
  late final int currentTabF;

  FonciersScreen(List<Foncier>? selectedFonciers, this.currentTabF) : super();

  @override
  _FonciersScreenState createState() => _FonciersScreenState();
}

class _FonciersScreenState extends State<FonciersScreen> {
  final List<Widget> screens = [
    DataTableFoncier(selectedFonciers),
    FormFonciers(selectedFonciers, '', ''),
    EditFormFoncier(selectedFonciers)
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = DataTableFoncier(selectedFonciers);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      /* floatingActionButton: selectedProjets!.length != 0
          ? FloatingActionButton(
              child: Icon(Icons.edit),
              onPressed: () {},
            )
          : SizedBox(),*/
      resizeToAvoidBottomInset: false,
      body: PageStorage(bucket: bucket, child: currentScreen),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.purple, Colors.blue])),
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new FonciersScreen(
                                      selectedFonciers,
                                      0,
                                    )));
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.table_rows_rounded,
                          color: widget.currentTabF == 0
                              ? Colors.white
                              : Colors.black,
                        ),
                        Text(
                          'Table Fonciers',
                          style: TextStyle(
                              color: widget.currentTabF == 0
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    new FonciersScreen(selectedFonciers, 1)));
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          color: widget.currentTabF == 1
                              ? Colors.white
                              : Colors.black,
                        ),
                        Text(
                          'Form Foncier',
                          style: TextStyle(
                              color: widget.currentTabF == 1
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    new FonciersScreen(selectedFonciers, 2)));
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit,
                          color: widget.currentTabF == 2
                              ? Colors.white
                              : Colors.black,
                        ),
                        Text(
                          'Edit Foncier',
                          style: TextStyle(
                              color: widget.currentTabF == 2
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    selectedFonciers;
    if (widget.currentTabF == 0)
      currentScreen = DataTableFoncier(selectedFonciers);
    else if (widget.currentTabF == 1)
      currentScreen = FormFonciers(selectedFonciers, '', '');
    else if (widget.currentTabF == 2)
      currentScreen = EditFormFoncier(selectedFonciers);
  }
}
