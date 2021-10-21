import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ta_salon/DropDown.dart';
import 'package:ta_salon/HomeMember.dart';
import 'package:ta_salon/Pesanansaya.dart';
import 'package:ta_salon/Profile.dart';
import 'main_variable.dart' as main_variable;
import 'dart:async';
import 'package:ta_salon/dashboardadmin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Dashboardmember extends StatefulWidget {
  @override
  DashboardmemberState createState() => DashboardmemberState();
}

class DashboardmemberState extends State<Dashboardmember> {
  int index = 0;
  final bottomBar = [Homemember(), Pesanansaya(), DropDown(), Profile()];

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
              icon: Icon(Icons.list), title: Text("Pesanan")),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), title: Text("My Favorite")),
          BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle_rounded),
              title: Text("Profile"))
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: _onTapItem,
      ),
    );
  }
}
