import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ta_salon/AccIklan.dart';
import 'package:ta_salon/AccSaldo.dart';
import 'package:ta_salon/InsertKategori.dart';
import 'main_variable.dart' as main_variable;
import 'dart:async';
import 'ClassUser.dart';
import 'dart:io';
import 'package:ta_salon/DashboardAdmin.dart';
import 'package:http/http.dart' as http;
import 'package:ta_salon/warnalayer.dart';
import 'dart:convert';
import 'ClassIklan.dart';
import 'package:image_picker/image_picker.dart';
import 'package:badges/badges.dart';
import 'package:path/path.dart';

class Homeadmin extends StatefulWidget {
  @override
  HomeadminState createState() => HomeadminState();
}

class HomeadminState extends State<Homeadmin> {
  TextEditingController myNama = new TextEditingController();
  String status, username;
  String foto = main_variable.ipnumber + "/gambar/default.png";
  File _image;
  List<ClassUser> arr = new List();
  List<ClassIklan> arriklan = new List();

  void initState() {
    super.initState();
    getuser();
    getiklan_admin();
  }

  Future<ClassIklan> getiklan_admin() async {
    arriklan.clear();
    Map paramData = {};
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/getiklan_admin",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];
      print(res.body);
      print(data.length);

      for (int i = 0; i < data.length; i++) {
        ClassIklan databaru = new ClassIklan(
          data[i]['idiklan'].toString(),
          data[i]['tanggal'].toString(),
          data[i]['username'].toString(),
          data[i]['hargaiklan'].toString(),
          data[i]['tanggal_awal'].toString(),
          data[i]['tanggal_akhir'].toString(),
          data[i]['foto'].toString(),
          data[i]['status'].toString(),
        );
        setState(() {
          this.arriklan.add(databaru);
        });
      }
      print("length : " + arriklan.length.toString());

      return arriklan;
    }).catchError((err) {
      print(err);
    });
  }

  Future<String> getuser() async {
    Map paramData = {
      'username': main_variable.userlogin,
    };
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/getuser",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];
      print(res.body);
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
        this.arr.add(databaru);
        foto = main_variable.ipnumber + "/gambar/" + arr[i].foto;
      }
      setState(() => this.arr = arr);

      return arr;
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Warnalayer.backgroundColor,
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: Colors.blueAccent[200],
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(80),
                  bottomLeft: Radius.circular(80),
                ),
                gradient: LinearGradient(
                    colors: [
                      const Color(0xFF00CCFF),
                      const Color(0xFF3366FF),
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30, 50, 0, 0),
              child: SizedBox(
                height: 70,
                width: 70,
                child: Stack(
                  fit: StackFit.expand,
                  overflow: Overflow.visible,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(60.0),
                      child: Image.network(
                        this.foto,
                        width: 150,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(110, 50, 0, 0),
              child: Column(
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Text(
                              arr[0].nama,
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                  color: Colors.black),
                            )),
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              arr[0].email,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 16,
                                  //fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 130, 10, 0),
              child: SizedBox(
                height: 700,
                width: 350,
                child: Expanded(
                  flex: 1,
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 10,
                    primary: false,
                    children: <Widget>[
                      GestureDetector(
                          onTap: () {
                            print("promo");
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "images/promo.png",
                                  height: 128,
                                  width: 130,
                                ),
                                SizedBox(height: 3),
                                Text(
                                  "Promo / Kupon",
                                  style: TextStyle(
                                      fontSize: 17, color: Colors.black),
                                )
                              ],
                            ),
                          )),
                      GestureDetector(
                        onTap: () {
                          print("iklan");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AccIklan(),
                              )).then((value) => getiklan_admin());
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Image.asset(
                                    "images/iklan.png",
                                    height: 128,
                                    width: 130,
                                  ),
                                  new Positioned(
                                    right: 0,
                                    child: new Container(
                                      padding: EdgeInsets.all(1),
                                      decoration: new BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 18,
                                        minHeight: 18,
                                      ),
                                      //ini badges
                                      child: new Text(
                                        arriklan.length.toString(),
                                        style: new TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Text(
                                "Iklan Salon",
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print("acc saldo");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AccSaldo(),
                              ));
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                "images/saldo.png",
                                height: 128,
                                width: 130,
                              ),
                              SizedBox(height: 3),
                              Text(
                                "Accept Saldo",
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print("kategori");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InsertKategori(),
                              ));
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                "images/laporan.png",
                                height: 128,
                                width: 130,
                              ),
                              SizedBox(height: 3),
                              Text(
                                "Insert Kategori",
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print("Blok");
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                "images/block.png",
                                height: 128,
                                width: 130,
                              ),
                              SizedBox(height: 3),
                              Text(
                                "Block / Unblock",
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print("Moderasi");
                        },
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                "images/moderasi.png",
                                height: 128,
                                width: 130,
                              ),
                              SizedBox(height: 3),
                              Text(
                                "Moderasi",
                                style: TextStyle(
                                    fontSize: 17, color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
