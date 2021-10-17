import 'dart:developer';
import 'package:ta_salon/HomeSalon.dart';
import 'package:ta_salon/InsertPegawai.dart';
import 'package:flutter/material.dart';
import 'package:ta_salon/ListBookingSalon.dart';
import 'package:ta_salon/Profile.dart';
import 'package:ta_salon/ProfileSalon.dart';
import 'main_variable.dart' as main_variable;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Dashboardsalon extends StatefulWidget {
  @override
  DashboardsalonState createState() => DashboardsalonState();
}

class DashboardsalonState extends State<Dashboardsalon> {
  int index = 0;
  final bottomBar = [
    Homesalon(),
    ListBookingSalon(),
    InsertPegawai(),
    ProfileSalon()
  ];

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
              icon: Icon(Icons.list_alt_rounded), title: Text("Pemesanan")),
          BottomNavigationBarItem(
              icon: Icon(Icons.admin_panel_settings),
              title: Text("Data Pegawai")),
          BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle_rounded),
              title: Text("Peofile"))
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
