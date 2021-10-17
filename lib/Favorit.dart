import 'package:flutter/material.dart';
import 'package:ta_salon/DetailSalon.dart';
import 'package:ta_salon/HomeSalon.dart';
import 'package:ta_salon/ServiceSalon.dart';
import 'ClassSalon.dart';
import 'main_variable.dart' as main_variable;
import 'dart:async';
import 'package:ta_salon/warnalayer.dart';
import 'package:ta_salon/ClassUser.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'ClassFavoritJoinSalonJoinUser.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class Favorit extends StatefulWidget {
  @override
  FavoritState createState() => FavoritState();
}

class FavoritState extends State<Favorit> {
  bool _like = true;
  String idfavorit = "";
  List<ClassFavoritJoinSalonJoinUser> arrfav = new List();

  void initState() {
    super.initState();
    getFavorit();
  }

  Future<ClassFavoritJoinSalonJoinUser> getFavorit() async {
    arrfav.clear();
    Map paramData = {
      'username': main_variable.userlogin,
    };
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/getallfavoritjoinuser",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];
      print(res.body);
      print(data.length);

      for (int i = 0; i < data.length; i++) {
        ClassFavoritJoinSalonJoinUser databaru =
            new ClassFavoritJoinSalonJoinUser(
          data[i]['idfavorit'].toString(),
          data[i]['isalon'].toString(),
          data[i]['username'].toString(),
          data[i]['namasalon'].toString(),
          data[i]['kota'].toString(),
          data[i]['alamat'].toString(),
          data[i]['usernamesalon'].toString(),
          data[i]['foto'].toString(),
        );

        setState(() {
          this.arrfav.add(databaru);
        });
      }

      return arrfav;
    }).catchError((err) {
      print(err);
    });
  }

  Future<ClassFavoritJoinSalonJoinUser> deletefav() async {
    Map paramData = {'idfavorit': idfavorit};
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/deletefav",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];
      print(res.body);
      print(data.length);

      return arrfav;
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Warnalayer.backgroundColor,
      appBar: AppBar(
        title: Text(
          "My Favorite",
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              color: Warnalayer.backgroundColor,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: arrfav.length == 0 ? 1 : arrfav.length,
                itemBuilder: (BuildContext context, int index) => arrfav
                            .length ==
                        0
                    ? Card(
                        child: Text("ITEM KOSONG"),
                      )
                    : Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            shadowColor: Colors.black,
                            color: Colors.white,
                            child: SizedBox(
                              width: 370,
                              height: 255,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          5.0, 5.0, 5.0, 0.0),
                                      width: 370,
                                      height: 250,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.all(10),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(13.0),
                                              child: Image.network(
                                                main_variable.ipnumber +
                                                    "/gambar/" +
                                                    arrfav[0].foto,
                                                width: 400.0,
                                                height: 170,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              children: [
                                                Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                15, 0, 0, 0),
                                                        child: Text(
                                                          arrfav[index]
                                                              .namasalon,
                                                          style: TextStyle(
                                                            fontSize: 18.0,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            //fontWeight: FontWeight.bold,
                                                            letterSpacing: 1.5,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                15, 0, 0, 0),
                                                        child: Text(
                                                          arrfav[index].alamat,
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            color: Colors.black,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            //fontWeight: FontWeight.bold,
                                                            letterSpacing: 1.5,
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                15, 0, 0, 0),
                                                        child: Text(
                                                          arrfav[index].kota,
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            color: Colors.black,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                            //fontWeight: FontWeight.bold,
                                                            letterSpacing: 1.5,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      20, 0, 20, 10),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      print("masuk booking");
                                                      main_variable
                                                              .usernamesalon =
                                                          arrfav[index]
                                                              .usernamesalon;
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => DetailSalon(
                                                                  namasalonkirim:
                                                                      arrfav[index]
                                                                          .namasalon,
                                                                  kotakrim: arrfav[
                                                                          index]
                                                                      .kota)));
                                                    },
                                                    style: TextButton.styleFrom(
                                                        side: BorderSide(
                                                            width: 1,
                                                            color: Colors.grey),
                                                        minimumSize:
                                                            Size(40, 35),
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        primary: Colors.white,
                                                        backgroundColor:
                                                            Colors.blue[500]),
                                                    child: Center(
                                                      child: Text(
                                                        "Booking  ",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      right: 35,
                                      top: 30,
                                      child: GestureDetector(
                                        onTap: () {
                                          print("masuk unlike");
                                          idfavorit = arrfav[index].idfavorit;
                                          deletefav();
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Berhasil Menghapus Dari Favorit",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.CENTER,
                                              backgroundColor: Colors.red[500],
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                          setState(() {
                                            getFavorit();
                                          });
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(35),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    blurRadius: 5,
                                                    spreadRadius: 1)
                                              ]),
                                          child: Icon(
                                            Icons.favorite,
                                            size: 25,
                                            color: (_like)
                                                ? Colors.red
                                                : Colors.grey[600],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
