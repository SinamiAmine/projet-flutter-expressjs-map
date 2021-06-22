import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projectpfe/models/Operation.dart';
import 'package:projectpfe/screens/OperationScreen/components/datatable_operations.dart';
import 'package:projectpfe/screens/OperationScreen/components/edit_form.dart';
import 'package:projectpfe/screens/OperationScreen/components/from_operations.dart';

import '../../constants.dart';

class OperationScreen extends StatefulWidget {
  late final int currentTab;
  OperationScreen(List<Operation>? selectedOperations, this.currentTab)
      : super();

  @override
  _OperationScreenState createState() => _OperationScreenState();
}

class _OperationScreenState extends State<OperationScreen> {
  final List<Widget> screens = [
    DataTableOperations(selectedOperations),
    FormOperation(selectedOperations),
    EditFormOperation(selectedOperations)
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = DataTableOperations(selectedOperations);
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => new OperationScreen(
                                    selectedOperations, 0)));
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
                          'TableOperation',
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
                                builder: (context) => new OperationScreen(
                                    selectedOperations, 1)));
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
                          'FormOperation',
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
                                builder: (context) => new OperationScreen(
                                    selectedOperations, 2)));
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
                          'EditOperation',
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
      currentScreen = DataTableOperations(selectedOperations);
    else if (widget.currentTab == 1)
      currentScreen = FormOperation(selectedOperations);
    else if (widget.currentTab == 2)
      currentScreen = EditFormOperation(selectedOperations);
  }
}
