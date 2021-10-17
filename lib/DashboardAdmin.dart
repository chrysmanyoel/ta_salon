import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ta_salon/HomeAdmin.dart';
import 'package:ta_salon/Profile.dart';
import 'main_variable.dart' as main_variable;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Dashboardadmin extends StatefulWidget {
  @override
  DashboardadminState createState() => DashboardadminState();
}

class DashboardadminState extends State<Dashboardadmin> {
  int index = 0;
  final bottomBar = [Homeadmin(), Homeadmin(), Profile()];

  void _onTapItem(int idx) {
    setState(() {
      index = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bottomBar.elementAt(index),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("Home")),
          BottomNavigationBarItem(
              icon: Icon(Icons.report), title: Text("Laporan")),
          BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings),
              title: Text("Block/Unblock"))
        ],
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.white,
        backgroundColor: Colors.grey,
        currentIndex: index,
        onTap: _onTapItem,
      ),
    );
  }
}
