import 'package:flutter/material.dart';
import 'package:projectpfe/models/Marche.dart';
import 'package:projectpfe/screens/MarcheScreen/components/datatable_marches.dart';
import 'package:projectpfe/screens/MarcheScreen/components/edit_form.dart';
import 'package:projectpfe/screens/MarcheScreen/components/from_marches.dart';

import '../../constants.dart';

class MarcheScreen extends StatefulWidget {
  late final int currentTab;
  MarcheScreen(List<Marche>? selectedMarches, this.currentTab) : super();

  @override
  _MarcheScreenState createState() => _MarcheScreenState();
}

class _MarcheScreenState extends State<MarcheScreen> {
  final List<Widget> screens = [
    DataTableMarches(selectedMarches),
    FormMarche(selectedMarches),
    EditFormMarche(selectedMarches)
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = DataTableMarches(selectedMarches);
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
                                    new MarcheScreen(selectedMarches, 0)));
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
                          'Table Marche',
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
                                    new MarcheScreen(selectedMarches, 1)));
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
                          'Form Marche',
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
                                    new MarcheScreen(selectedMarches, 2)));
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
                          'Edit Marche',
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
    selectedMarches;
    if (widget.currentTab == 0)
      currentScreen = DataTableMarches(selectedMarches);
    else if (widget.currentTab == 1)
      currentScreen = FormMarche(selectedMarches);
    else if (widget.currentTab == 2)
      currentScreen = EditFormMarche(selectedMarches);
  }
}
