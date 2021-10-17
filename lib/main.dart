import 'package:flutter/material.dart';
import 'package:ta_salon/DashboardMember.dart';
import 'package:ta_salon/DashboardSalon.dart';
import 'package:ta_salon/EditProfileSalon.dart';
import 'package:ta_salon/EditProfileMember.dart';
import 'package:ta_salon/JamKerjaSalon.dart';
import 'dart:async';
import 'package:ta_salon/LoginRegis.dart';
import 'package:ta_salon/DashboardAdmin.dart';
import 'package:flutter_svg/svg.dart';

void main() {
  runZoned(() {
    runApp(MaterialApp(
      title: 'TA',
      home: MyApp(),
    ));
  }, onError: (dynamic error, dynamic stack) {
    print(error);
    print(stack);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'routing',
      theme: ThemeData(backgroundColor: Colors.white),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginRegis(),
        '/DashboardAdmin': (context) => Dashboardadmin(),
        '/DashboardSalon': (context) => Dashboardsalon(),
        '/DashboardMember': (context) => Dashboardmember(),
        '/EditProfileMember': (context) => EditprofileMember(),
        '/EditProfileSalon': (context) => EditprofileSalon(),
        '/JamKerjaSalon': (context) => JamKerjaSalon(),
      },
    );
  }
}
