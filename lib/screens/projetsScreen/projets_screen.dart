import 'package:flutter/material.dart';
import 'package:projectpfe/models/Projet.dart';
import 'package:projectpfe/screens/projetsScreen/components/datatable_projets.dart';
import 'package:projectpfe/screens/projetsScreen/components/edit_form.dart';
import 'package:projectpfe/screens/projetsScreen/components/from_projets.dart';

import '../../constants.dart';

class ProjetsScreen extends StatefulWidget {
  late final int currentTab;
  ProjetsScreen(List<Projet>? selectedProjets, this.currentTab) : super();

  @override
  _ProjetsScreenState createState() => _ProjetsScreenState();
}

class _ProjetsScreenState extends State<ProjetsScreen> {
  final List<Widget> screens = [
    DataTableProjets(selectedProjets),
    FormProjets(selectedProjets),
    EditFormProjects(selectedProjets)
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = DataTableProjets(selectedProjets);
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
                                builder: (context) =>
                                    new ProjetsScreen(selectedProjets, 0)));
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.table_rows_rounded,
                          color: widget.currentTab == 0
                              ? Colors.white
                              : Colors.black,
                        ),
                        Text(
                          'Table Projets',
                          style: TextStyle(
                              color: widget.currentTab == 0
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
                                    new ProjetsScreen(selectedProjets, 1)));
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          color: widget.currentTab == 1
                              ? Colors.white
                              : Colors.black,
                        ),
                        Text(
                          'Form Projets',
                          style: TextStyle(
                              color: widget.currentTab == 1
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
                                    new ProjetsScreen(selectedProjets, 2)));
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit,
                          color: widget.currentTab == 2
                              ? Colors.white
                              : Colors.black,
                        ),
                        Text(
                          'Edit Project',
                          style: TextStyle(
                              color: widget.currentTab == 2
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
    selectedProjets;
    if (widget.currentTab == 0)
      currentScreen = DataTableProjets(selectedProjets);
    else if (widget.currentTab == 1)
      currentScreen = FormProjets(selectedProjets);
    else if (widget.currentTab == 2)
      currentScreen = EditFormProjects(selectedProjets);
  }
}
