import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projectpfe/responsive.dart';
import 'package:shimmer/shimmer.dart';

import '../../constants.dart';
import 'components/header.dart';
import 'components/my_fiels.dart';
import 'components/recent_files.dart';
import 'components/storage_details.dart';

class DashboardScreen extends StatefulWidget {
  final bool? isLoading;

  const DashboardScreen({Key? key, this.isLoading = false}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
  void initState() {
    // TODO: implement initState
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Duration d = Duration(seconds: 4);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
            .apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      home: Scaffold(
        body: SafeArea(
          bottom: false,
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                _start == 5
                    ? Shimmer.fromColors(
                        period: Duration(seconds: 6),
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Header())
                    : _start == 0
                        ? Header()
                        : Shimmer.fromColors(
                            period: Duration(seconds: 6),
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Header()),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        flex: 5,
                        child: _start == 5
                            ? Shimmer.fromColors(
                                period: Duration(seconds: 6),
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Column(
                                  children: [
                                    MyFiels(),
                                    SizedBox(height: defaultPadding),
                                    RecentFiles(),
                                    /*      if (Responsive.isMobile(context))
                              SizedBox(height: defaultPadding),
                            if (Responsive.isMobile(context)) StarageDetails(),*/
                                  ],
                                ),
                              )
                            : _start == 0
                                ? Column(
                                    children: [
                                      MyFiels(),
                                      SizedBox(
                                        height: defaultPadding,
                                      ),
                                      RecentFiles(),
                                    ],
                                  )
                                : Shimmer.fromColors(
                                    period: Duration(seconds: 6),
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Column(
                                      children: [
                                        MyFiels(),
                                        SizedBox(height: defaultPadding),
                                        RecentFiles(),
                                        /*      if (Responsive.isMobile(context))
                              SizedBox(height: defaultPadding),
                            if (Responsive.isMobile(context)) StarageDetails(),*/
                                      ],
                                    ),
                                  )),
                    if (!Responsive.isMobile(context))
                      SizedBox(width: defaultPadding),
                    // On Mobile means if the screen is less than 850 we dont want to show it
                    if (!Responsive.isMobile(context))
                      Expanded(
                        flex: 2,
                        child: StarageDetails(),
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
