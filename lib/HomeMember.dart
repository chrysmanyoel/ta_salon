import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ta_salon/ClassSalon.dart';
import 'package:ta_salon/ClassUser.dart';
import 'package:ta_salon/ClassUserJoinSalonJoinJadwalsalon.dart';
import 'package:ta_salon/DetailSalon.dart';
import 'package:ta_salon/Favorit.dart';
import 'package:ta_salon/LihatSalon.dart';
import 'ClassGetJadwalSalon.dart';
import 'package:ta_salon/Topup.dart';
import 'main_variable.dart' as main_variable;
import 'dart:async';
import 'ClassUserJoinSalonJoinJadwalsalon.dart';
import 'dart:io';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:ta_salon/dashboardadmin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'ClassSalonJoinIklan.dart';
import 'package:ta_salon/warnalayer.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:path/path.dart';
//import 'package:getflutter/components/rating/gf_rating.dart';

class Homemember extends StatefulWidget {
  @override
  HomememberState createState() => HomememberState();
}

class HomememberState extends State<Homemember> {
  NumberFormat numberFormat = NumberFormat(',000');
  TextEditingController myEmail = new TextEditingController();
  TextEditingController myUsername = new TextEditingController();
  TextEditingController myNama = new TextEditingController();
  TextEditingController mySalon = new TextEditingController();
  TextEditingController myAlamat = new TextEditingController();

  List<ClassUserJoinSalonJoinJadwalsalon> arrsalon = new List();
  List<ClassGetJadwalSalon> arrhari = new List();
  List<ClassSalonJoinIklan> arrsaloniklan = new List();
  List<ClassUser> arruser = new List();

  int _selectedIndexcarousel = 0;
  double _rating = 1;
  String foto = main_variable.ipnumber + "/gambar/default.png";

  void initState() {
    super.initState();
    setState(() {
      arrsalon.add(new ClassUserJoinSalonJoinJadwalsalon(
          "email",
          "username",
          "password",
          "nama",
          "alamat",
          "kota",
          "telp",
          "default.png",
          "saldo",
          "tgllahir",
          "jeniskelamin",
          "role",
          "status",
          "idsalon",
          "hari",
          "jambuka",
          "jamtutup"));
      arrsaloniklan.add(new ClassSalonJoinIklan(
          "idiklan",
          "tanggal",
          "username",
          "hargaiklan",
          "tanggal_awal",
          "tanggal_akhir",
          "default.png",
          "status",
          "namasalon",
          "kota",
          "alamat",
          'username'));
      arruser.add(new ClassUser(
          "email",
          "username",
          "password",
          "nama",
          "alamat",
          "kota",
          "telp",
          "default.png",
          "0",
          "tgllahir",
          "jeniskelamin",
          "role",
          "status"));
    });

    getallsalonuser();
    getalliklansalon();
    getuser();
    print("ini userlogin : " +
        main_variable.userlogin +
        ' - ' +
        main_variable.kotauser);
  }

  Text _buildRatingStars(int rating) {
    String stars = '';
    for (int i = 0; i < rating; i++) {
      stars += '⭐ ';
    }
    stars.trim();
    return Text(stars);
  }

  Future<ClassUserJoinSalonJoinJadwalsalon> getallsalonuser() async {
    List<ClassUserJoinSalonJoinJadwalsalon> arrtemp = new List();
    Map paramData = {};
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/getallsalonuser",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];
      print(data.length);

      for (int i = 0; i < data.length; i++) {
        ClassUserJoinSalonJoinJadwalsalon databaru =
            new ClassUserJoinSalonJoinJadwalsalon(
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
                data[i]['status'].toString(),
                data[i]['idsalon'].toString(),
                data[i]['hari'].toString(),
                data[i]['jambuka'].toString(),
                data[i]['jamtutup'].toString());
        arrtemp.add(databaru);
        foto = main_variable.ipnumber + "/gambar/" + arrtemp[i].foto;
      }
      setState(() => this.arrsalon = arrtemp);
      print("ini jum arrslaon : " + this.arrsalon.length.toString());

      return arrtemp;
    }).catchError((err) {
      print(err);
    });
  }

  Future<ClassUser> getuser() async {
    List<ClassUser> arrtemp = new List();
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
          data[i]['status'].toString(),
        );
        arrtemp.add(databaru);
        foto = main_variable.ipnumber + "/gambar/" + arrtemp[i].foto;
      }
      setState(() => this.arruser = arrtemp);

      return arrtemp;
    }).catchError((err) {
      print(err);
    });
  }

  Future<ClassSalonJoinIklan> getalliklansalon() async {
    List<ClassSalonJoinIklan> arrtemp = new List();
    Map paramData = {};
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/getalliklansalon",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];
      print(data.length);

      for (int i = 0; i < data.length; i++) {
        ClassSalonJoinIklan databaru = new ClassSalonJoinIklan(
            data[i]['idiklan'].toString(),
            data[i]['tanggal'].toString(),
            data[i]['idsalon'].toString(),
            data[i]['hargaiklan'].toString(),
            data[i]['tanggal_awal'].toString(),
            data[i]['tanggal_akhir'].toString(),
            data[i]['foto'].toString(),
            data[i]['status'].toString(),
            data[i]['namasalon'].toString(),
            data[i]['kota'].toString(),
            data[i]['alamat'].toString(),
            data[i]['username'].toString());
        arrtemp.add(databaru);
        foto = main_variable.ipnumber + "/gambar/" + arrtemp[i].foto;
      }
      setState(() => this.arrsaloniklan = arrtemp);

      return arrtemp;
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
//                          borderRadius: BorderRadius.circular(20),
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
                Column(
                  children: <Widget>[
                    //ini itampilan salon yang bayar iklan
                    SizedBox(
                      height: 20,
                    ),
                    CarouselSlider(
                        items: arrsaloniklan.map((ClassSalonJoinIklan j) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                  width: 400,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 2.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.transparent,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.4),
                                          blurRadius: 2),
                                    ],
                                  ),
                                  child: SizedBox(
                                    child: GestureDetector(
                                      onTap: () {
                                        main_variable.usernamesalon =
                                            arrsaloniklan[
                                                    _selectedIndexcarousel]
                                                .username;
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => DetailSalon(
                                                namasalonkirim: arrsaloniklan[
                                                        _selectedIndexcarousel]
                                                    .namasalon,
                                                idsalon: arrsaloniklan[
                                                        _selectedIndexcarousel]
                                                    .idsalon,
                                                kotakrim: arrsaloniklan[
                                                        _selectedIndexcarousel]
                                                    .kota,
                                              ),
                                            ));
                                      },
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.network(
                                              main_variable.ipnumber +
                                                  "/gambar/" +
                                                  j.foto,
                                              width: 500,
                                              height: 200,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          // Container(
                                          //   margin: EdgeInsets.fromLTRB(
                                          //       10, 125, 0, 0),
                                          //   child: Text(
                                          //     j.namasalon,
                                          //     style: TextStyle(
                                          //       fontSize: 16.0,
                                          //       color: Colors.black,
                                          //       fontWeight: FontWeight.bold,
                                          //       fontStyle: FontStyle.italic,
                                          //       //fontWeight: FontWeight.bold,
                                          //       letterSpacing: 1.5,
                                          //       shadows: <Shadow>[
                                          //         Shadow(
                                          //           offset: Offset(1.0, 1.0),
                                          //           blurRadius: 1.0,
                                          //           color: Colors.white,
                                          //         ),
                                          //         Shadow(
                                          //           offset: Offset(1.0, 1.0),
                                          //           blurRadius: 2.0,
                                          //           color: Colors.white,
                                          //         ),
                                          //       ],
                                          //     ),
                                          //   ),
                                          // ),
                                          // Container(
                                          //   margin: EdgeInsets.fromLTRB(
                                          //       10, 143, 0, 0),
                                          //   child: Text(
                                          //     j.alamat,
                                          //     style: TextStyle(
                                          //       fontSize: 12.0,
                                          //       color: Colors.black,
                                          //       fontStyle: FontStyle.italic,
                                          //       //fontWeight: FontWeight.bold,
                                          //       letterSpacing: 1.5,
                                          //       shadows: <Shadow>[
                                          //         Shadow(
                                          //           offset: Offset(1.0, 1.0),
                                          //           blurRadius: 1.0,
                                          //           color: Colors.white,
                                          //         ),
                                          //         Shadow(
                                          //           offset: Offset(1.0, 1.0),
                                          //           blurRadius: 2.0,
                                          //           color: Colors.white,
                                          //         ),
                                          //       ],
                                          //     ),
                                          //   ),
                                          // ),
                                          // Container(
                                          //   margin: EdgeInsets.fromLTRB(
                                          //       10, 157, 0, 0),
                                          //   child: Text(
                                          //     j.kota,
                                          //     style: TextStyle(
                                          //       fontSize: 12.0,
                                          //       color: Colors.black,
                                          //       fontStyle: FontStyle.italic,
                                          //       //fontWeight: FontWeight.bold,
                                          //       letterSpacing: 1.5,
                                          //       shadows: <Shadow>[
                                          //         Shadow(
                                          //           offset: Offset(1.0, 1.0),
                                          //           blurRadius: 1.0,
                                          //           color: Colors.white,
                                          //         ),
                                          //         Shadow(
                                          //           offset: Offset(1.0, 1.0),
                                          //           blurRadius: 2.0,
                                          //           color: Colors.white,
                                          //         ),
                                          //       ],
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                          );
                        }).toList(),
                        options: CarouselOptions(
                          height: 200,
                          aspectRatio: 18 / 9,
                          viewportFraction: 0.8,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 200),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          onPageChanged: (prev, next) {
                            _selectedIndexcarousel = prev;
                          },
                          scrollDirection: Axis.horizontal,
                        )),

                    // Text("test")
                    Container(
                      height: 240,
                      child: ListView(
                        physics: ScrollPhysics(),
                        padding:
                            EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                        children: <Widget>[
                          Card(
                            elevation: 10,
                            shadowColor: Colors.black,
                            //warna luar gojek
                            color: Colors.white,
                            child: SizedBox(
                              //ini ukuran biru muda
                              width: 300,
                              height: 220,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Saldo",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                5, 5, 5, 0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                    "Rp. " + arruser[0].saldo ==
                                                            "0"
                                                        ? "Rp. 0"
                                                        : "Rp. " +
                                                            numberFormat.format(
                                                                int.parse(
                                                                    arruser[0]
                                                                        .saldo)),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    //gojek
                                    Card(
                                      //efek shadow
                                      elevation: 5,
                                      shadowColor: Colors.black,
                                      //warna dalem gojek
                                      color: Colors.lightBlueAccent[50],
                                      //ini ukuran biru tua
                                      child: SizedBox(
                                        width: 350,
                                        height: 160,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(children: [
                                              Expanded(
                                                flex: 1,
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 10, 10, 0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          print("masuk0");
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Topup(),
                                                              ));
                                                        },
                                                        child: Column(
                                                          children: <Widget>[
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(2.0),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5)),
                                                                  border: Border.all(
                                                                      width: 2,
                                                                      color: Colors
                                                                              .grey[
                                                                          400])),
                                                              child: Icon(
                                                                Icons
                                                                    .account_balance_wallet_outlined,
                                                                color: Colors
                                                                    .green,
                                                                size: 30.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text("Top Up",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 10, 10, 0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          print("24 Jam");
                                                        },
                                                        child: Column(
                                                          children: <Widget>[
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(2.0),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5)),
                                                                  border: Border.all(
                                                                      width: 2,
                                                                      color: Colors
                                                                              .grey[
                                                                          400])),
                                                              child: Icon(
                                                                Icons
                                                                    .schedule_rounded,
                                                                color: Colors
                                                                        .deepOrangeAccent[
                                                                    400],
                                                                size: 30.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text("24 Jam",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 1,
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 10, 10, 0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          print("masuk3");
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Favorit(),
                                                              ));
                                                        },
                                                        child: Column(
                                                          children: <Widget>[
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(2.0),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5)),
                                                                  border: Border.all(
                                                                      width: 2,
                                                                      color: Colors
                                                                              .grey[
                                                                          400])),
                                                              child: Icon(
                                                                Icons.favorite,
                                                                color:
                                                                    Colors.blue,
                                                                size: 30.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text("My Favorite",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ]),
                                            Row(children: [
                                              Expanded(
                                                flex: 2,
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 10, 10, 0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          print("masuk4");
                                                        },
                                                        child: Column(
                                                          children: <Widget>[
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(2.0),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5)),
                                                                  border: Border.all(
                                                                      width: 2,
                                                                      color: Colors
                                                                              .grey[
                                                                          400])),
                                                              child: Icon(
                                                                Icons
                                                                    .new_releases,
                                                                color: Colors
                                                                        .amberAccent[
                                                                    400],
                                                                size: 30.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text("Baru Buka",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 10, 10, 0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          print("masuk5");
                                                        },
                                                        child: Column(
                                                          children: <Widget>[
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(2.0),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5)),
                                                                  border: Border.all(
                                                                      width: 2,
                                                                      color: Colors
                                                                              .grey[
                                                                          400])),
                                                              child: Icon(
                                                                Icons.near_me,
                                                                color: Colors
                                                                    .blue[300],
                                                                size: 30.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text("Terdekat",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 2,
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      10, 10, 10, 0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          print("masuk6");
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        LihatSalon(),
                                                              ));
                                                        },
                                                        child: Column(
                                                          children: <Widget>[
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(2.0),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5)),
                                                                  border: Border.all(
                                                                      width: 2,
                                                                      color: Colors
                                                                              .grey[
                                                                          400])),
                                                              child: Icon(
                                                                Icons
                                                                    .list_alt_rounded,
                                                                color:
                                                                    Colors.red,
                                                                size: 30.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text("Cari Salon",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ]),
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
                    )
                  ],
                ),
                //Carousel
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Terpopuler',
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
                CarouselSlider(
                    items: arrsaloniklan.map((ClassSalonJoinIklan j) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                              width: 400,
                              //margin: EdgeInsets.symmetric(horizontal: 5.0),
                              margin: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.transparent,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.4),
                                      blurRadius: 2),
                                ],
                              ),
                              child: SizedBox(
                                child: GestureDetector(
                                  onTap: () {
                                    main_variable.usernamesalon = j.username;
                                    main_variable.idsalonlogin = j.idsalon;
                                    print('namasalon : ' +
                                        j.namasalon +
                                        ' - idsalon :  ' +
                                        j.idsalon +
                                        ' -kotasalon : ' +
                                        j.kota);
                                    print('ini selectec index car : ' +
                                        _selectedIndexcarousel.toString());
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailSalon(
                                            namasalonkirim: j.namasalon,
                                            idsalon: j.idsalon,
                                            kotakrim: j.kota,
                                          ),
                                        ));
                                  },
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                          main_variable.ipnumber +
                                              "/gambar/" +
                                              j.foto,
                                          width: 500,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 125, 0, 0),
                                        child: Text(
                                          j.namasalon,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic,
                                            //fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5,
                                            shadows: <Shadow>[
                                              Shadow(
                                                offset: Offset(1.0, 1.0),
                                                blurRadius: 1.0,
                                                color: Colors.white,
                                              ),
                                              Shadow(
                                                offset: Offset(1.0, 1.0),
                                                blurRadius: 2.0,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 143, 0, 0),
                                        child: Text(
                                          j.alamat,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.black,
                                            fontStyle: FontStyle.italic,
                                            //fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5,
                                            shadows: <Shadow>[
                                              Shadow(
                                                offset: Offset(1.0, 1.0),
                                                blurRadius: 1.0,
                                                color: Colors.white,
                                              ),
                                              Shadow(
                                                offset: Offset(1.0, 1.0),
                                                blurRadius: 2.0,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 157, 0, 0),
                                        child: Text(
                                          j.kota,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.black,
                                            fontStyle: FontStyle.italic,
                                            //fontWeight: FontWeight.bold,
                                            letterSpacing: 1.5,
                                            shadows: <Shadow>[
                                              Shadow(
                                                offset: Offset(1.0, 1.0),
                                                blurRadius: 1.0,
                                                color: Colors.white,
                                              ),
                                              Shadow(
                                                offset: Offset(1.0, 1.0),
                                                blurRadius: 2.0,
                                                color: Colors.white,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                        },
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 200,
                      aspectRatio: 18 / 9,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      //autoPlay: true,
                      //autoPlayInterval: Duration(seconds: 3),
                      //autoPlayAnimationDuration: Duration(milliseconds: 200),
                      //autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      onPageChanged: (prev, next) {
                        _selectedIndexcarousel = prev;
                      },
                      scrollDirection: Axis.horizontal,
                    )),
                //Listview Horizontal
                Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Selalu Diskon',
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
                      Container(
                        child: SizedBox(
                          height: 350,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: arrsalon.length,
                            itemBuilder: (BuildContext context, int index) =>
                                Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  print("masuk");
                                },
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          10.0, 5.0, 10.0, 0.0),
                                      width: 200,
                                      height: 350,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            15.0, 180.0, 0.0, 0.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  width: 120.0,
                                                  child: Text(
                                                    arrsalon[index].nama,
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                  ),
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    IconButton(
                                                      icon: Icon(Icons
                                                          .favorite_border),
                                                      onPressed: () {
                                                        print("ini index ke " +
                                                            index.toString() +
                                                            " masuk fav");
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Text(
                                              arrsalon[index].alamat,
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              arrsalon[index].kota,
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                            _buildRatingStars(4),
                                            SizedBox(height: 10.0),
                                            Row(
                                              children: <Widget>[
                                                Container(
                                                  padding: EdgeInsets.all(5.0),
                                                  width: 70.0,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Colors.lightBlueAccent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(arrsalon[index]
                                                      .jambuka
                                                      .substring(0, 5)),
                                                ),
                                                SizedBox(width: 3.0),
                                                Container(
                                                  child: Text(
                                                    " - ",
                                                    style:
                                                        TextStyle(fontSize: 18),
                                                  ),
                                                ),
                                                SizedBox(width: 3.0),
                                                Container(
                                                  padding: EdgeInsets.all(5.0),
                                                  width: 70.0,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Colors.lightBlueAccent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(arrsalon[index]
                                                      .jamtutup
                                                      .substring(0, 5)),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 20.0,
                                      top: 20,
                                      bottom: 150.0,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: Image.network(
                                          main_variable.ipnumber +
                                              "/gambar/" +
                                              arrsalon[index].foto,
                                          width: 180.0,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                //carousel3
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Lihat Semua',
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
                CarouselSlider(
                    items: arrsalon.map((ClassUserJoinSalonJoinJadwalsalon i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                              width: 500,
                              //margin: EdgeInsets.symmetric(horizontal: 5.0),
                              margin: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                //color: Colors.amber,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.4),
                                      blurRadius: 2),
                                ],
                              ),
                              child: SizedBox(
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        main_variable.ipnumber +
                                            "/gambar/" +
                                            i.foto,
                                        width: 500,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(10, 125, 0, 0),
                                      child: Text(
                                        i.nama,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.amber,
                                          fontStyle: FontStyle.italic,
                                          //fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(10, 143, 0, 0),
                                      child: Text(
                                        i.alamat,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.amber,
                                          fontStyle: FontStyle.italic,
                                          //fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(10, 157, 0, 0),
                                      child: Text(
                                        i.kota,
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.amber,
                                          fontStyle: FontStyle.italic,
                                          //fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                        },
                      );
                    }).toList(),
                    options: CarouselOptions(
                      height: 200,
                      aspectRatio: 18 / 9,
                      viewportFraction: 0.8,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: false,
                      //autoPlayInterval: Duration(seconds: 3),
                      //autoPlayAnimationDuration: Duration(milliseconds: 200),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      //onPageChanged: callbackFunction,
                      scrollDirection: Axis.horizontal,
                    )),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
