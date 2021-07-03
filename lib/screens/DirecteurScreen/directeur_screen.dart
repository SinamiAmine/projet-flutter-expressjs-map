import 'package:flutter/material.dart';
import 'package:projectpfe/screens/DirecteurScreen/components/edit-page.dart';
import 'package:projectpfe/screens/DirecteurScreen/components/form-add.dart';
import 'package:projectpfe/screens/DirecteurScreen/components/list-page.dart';

import '../../constants.dart';

class DirecteurScreen extends StatefulWidget {
  late final int currentTab;
  DirecteurScreen(this.currentTab) : super();

  @override
  _DirecteurScreenState createState() => _DirecteurScreenState();
}

class _DirecteurScreenState extends State<DirecteurScreen> {
  final List<Widget> screens = [ListPage(), FormAdd(), EditPage()];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = ListPage();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Scaffold(
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      new DirecteurScreen(0)));
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
                            'Liste Directeur',
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
              ],
            ),
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
      currentScreen = ListPage();
    else if (widget.currentTab == 1)
      currentScreen = FormAdd();
    else if (widget.currentTab == 2) currentScreen = EditPage();
  }
}
