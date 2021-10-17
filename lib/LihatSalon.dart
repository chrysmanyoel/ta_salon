import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ta_salon/ClassSalon.dart';
import 'package:ta_salon/ClassSalonJoinUser.dart';
import 'package:ta_salon/DetailSalon.dart';
import 'main_variable.dart' as main_variable;
import 'dart:async';
import 'package:ta_salon/ClassUser.dart';
import 'ClassUser.dart';
import 'Classjoinusersalon.dart';
import 'dart:io';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:ta_salon/dashboardadmin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ta_salon/warnalayer.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:path/path.dart';
//import 'package:getflutter/components/rating/gf_rating.dart';

class LihatSalon extends StatefulWidget {
  @override
  LihatSalonState createState() => LihatSalonState();
}

class LihatSalonState extends State<LihatSalon> {
  TextEditingController myEmail = new TextEditingController();
  TextEditingController myUsername = new TextEditingController();
  TextEditingController myNama = new TextEditingController();
  TextEditingController mySalon = new TextEditingController();
  TextEditingController myAlamat = new TextEditingController();
  TextEditingController myCari = new TextEditingController();
  List<ClassUser> arrsalon = new List();
  List<ClassSalonJoinUser> arrcari = new List();
  int _selectedIndexcarousel = 0;
  double _rating = 1;
  String foto = main_variable.ipnumber + "/gambar/default.png";

  void initState() {
    super.initState();
    getallsalonuser();
    print(main_variable.namauser);
  }

  Text _buildRatingStars(int rating) {
    String stars = '';
    for (int i = 0; i < rating; i++) {
      stars += '⭐ ';
    }
    stars.trim();
    return Text(stars);
  }

  Future<ClassUser> getallsalonuser() async {
    Map paramData = {};
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/getallsalonuser",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      // print("salah getallsalonuser");
      print(res.body.substring(500));
      var data = json.decode(res.body);
      data = data[0]['status'];
      print(data.length);

      for (int i = 0; i < data.length; i++) {
        ClassUser databaru = new ClassUser(
            data[i]['email'].toString(),
            data[i]['username'].toString(),
            data[i]['password'].toString(),
            data[i]['nama'].toString(),
            data[i]['alamat'].toString(),
            data[i]['kota'].toString(),
            data[i]['telp'].toString(),
            data[i]['foto'].toString(),
            data[i]['saldo'].toString(),
            data[i]['tgllahir'].toString(),
            data[i]['jeniskelamin'].toString(),
            data[i]['role'].toString(),
            data[i]['status'].toString());
        this.arrsalon.add(databaru);
        foto = main_variable.ipnumber + "/gambar/" + arrsalon[i].foto;
      }
      setState(() => this.arrsalon = arrsalon);

      return arrsalon;
    }).catchError((err) {
      print(err);
    });
  }

  Future<ClassSalonJoinUser> carisalon() async {
    Map paramData = {
      'username': myCari.text,
    };
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/carisalon",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];
      print(data.length);

      for (int i = 0; i < data.length; i++) {
        ClassSalonJoinUser databaru = new ClassSalonJoinUser(
            data[i]['id'].toString(),
            data[i]['username'].toString(),
            data[i]['namasalon'].toString(),
            data[i]['alamat'].toString(),
            data[i]['kota'].toString(),
            data[i]['telp'].toString(),
            data[i]['longitude'].toString(),
            data[i]['latitude'].toString(),
            data[i]['keterangan'].toString(),
            data[i]['status'].toString(),
            data[i]['foto'].toString());
        this.arrcari.add(databaru);
        foto = main_variable.ipnumber + "/gambar/" + arrcari[i].foto;
      }
      setState(() => this.arrcari = arrcari);

      return arrcari;
    }).catchError((err) {
      print(err);
    });
  }

  ///JADIIN LISTVIEW BIAR BISA KEBAWAH
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warnalayer.backgroundColor,
      body: Center(
        child: ListView(
          children: [
            Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      height: 160,
                      width: 400,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30)),
                          image: DecorationImage(
                              image: AssetImage("images/background.png"),
                              fit: BoxFit.cover)),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.0),
                                Colors.black.withOpacity(0.0),
                                Colors.black.withOpacity(0.1),
                                Colors.black.withOpacity(0.5),
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft),
                          borderRadius: BorderRadius.circular(30.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0.0, 6.0),
                              blurRadius: 8.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20.0,
                      top: 90,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            //widget.destination.city,
                            "Welcome, " + main_variable.namauser,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                MaterialCommunityIcons.directions,
                                size: 15.0,
                                color: Colors.white70,
                              ),
                              SizedBox(width: 5.0),
                              Text(
                                //"Bandung",
                                main_variable.kotauser,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Daftar Salon',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print('Masuk On Tap');
                        },
                        child: Text(
                          'See All',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 18, top: 0, right: 18, bottom: 10),
                      child: TextField(
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 3),
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  print("search Salon");
                                },
                              ),
                            ),
                            hintText: "Search Salon",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    width: 1.0, color: Colors.grey[400]))),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
