import 'dart:developer';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ta_salon/ClassSalon.dart';
import 'package:ta_salon/ClassUserJoinSalonJoinJadwalsalon.dart';
import 'package:ta_salon/DetailSalon.dart';
import 'ClassListBookingWithLayanan.dart';
import 'package:ta_salon/LihatSalon.dart';
import 'main_variable.dart' as main_variable;
import 'dart:async';
import 'ClassUserJoinSalonJoinJadwalsalon.dart';
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

class Pesanansaya extends StatefulWidget {
  @override
  PesanansayaState createState() => PesanansayaState();
}

class PesanansayaState extends State<Pesanansaya> {
  NumberFormat numberFormat = NumberFormat(',000');
  TextEditingController myEmail = new TextEditingController();
  TextEditingController myUsername = new TextEditingController();
  TextEditingController myNama = new TextEditingController();
  TextEditingController mySalon = new TextEditingController();
  TextEditingController myAlamat = new TextEditingController();
  List<ClassUserJoinSalonJoinJadwalsalon> arrsalon = new List();
  List<ClassListBookingWithLayanan> arrbooking = new List();
  List<ClassListBookingWithLayanan> arrselesai = new List();
  List<int> arrkosong = [];
  List<String> arr = ['semua', 'dibatalkan', 'selesai'];
  String arrcmb = null;
  int _selectedIndexcarousel = 0;
  double _rating = 1;
  String foto = main_variable.ipnumber + "/gambar/default.png";

  void initState() {
    super.initState();
    getlistbookinguser();
    getlistbookingselesai();
    print(main_variable.userlogin);
  }

  Future<String> getlistbookinguser() async {
    Map paramData = {
      'user': main_variable.userlogin,
    };
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/getlistbookingwithlayananuser",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      //print(res.body.substring(100));
      var data = json.decode(res.body);
      data = data[0]['status'];
      print(res.body);
      print(data.length);

      for (int i = 0; i < data.length; i++) {
        ClassListBookingWithLayanan databaru = new ClassListBookingWithLayanan(
            data[i]['id'].toString(),
            data[i]['tanggal'].toString(),
            data[i]['username'].toString(),
            data[i]['namauser'].toString(),
            data[i]['usenamesalon'].toString(),
            data[i]['idservice'].toString(),
            data[i]['tanggalbooking'].toString(),
            data[i]['jambooking'].toString(),
            data[i]['requestpegawai'].toString(),
            data[i]['total'].toString(),
            data[i]['namalayanan'].toString(),
            data[i]['status'].toString(),
            data[i]['pembayaran'].toString(),
            data[i]['foto'].toString(),
            data[i]['jambookingselesai'].toString(),
            data[i]['total_cancel'].toString());
        this.arrbooking.add(databaru);
        // myNamauser.text = arrsemua[i].namauser;
      }
      setState(() => this.arrbooking = arrbooking);

      return arrbooking;
    }).catchError((err) {
      print(err);
    });
  }

  Future<String> getlistbookingselesai() async {
    Map paramData = {
      'user': main_variable.userlogin,
    };
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/getlistbookingwithlayananuserselesai",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      //print(res.body.substring(100));
      var data = json.decode(res.body);
      data = data[0]['status'];
      print(res.body);
      print(data.length);

      for (int i = 0; i < data.length; i++) {
        ClassListBookingWithLayanan databaru = new ClassListBookingWithLayanan(
            data[i]['id'].toString(),
            data[i]['tanggal'].toString(),
            data[i]['username'].toString(),
            data[i]['namauser'].toString(),
            data[i]['usenamesalon'].toString(),
            data[i]['idservice'].toString(),
            data[i]['tanggalbooking'].toString(),
            data[i]['jambooking'].toString(),
            data[i]['requestpegawai'].toString(),
            data[i]['total'].toString(),
            data[i]['namalayanan'].toString(),
            data[i]['status'].toString(),
            data[i]['pembayaran'].toString(),
            data[i]['foto'].toString(),
            data[i]['jambookingselesai'].toString(),
            data[i]['total_cancel'].toString());
        this.arrselesai.add(databaru);
        // myNamauser.text = arrsemua[i].namauser;
      }
      setState(() => this.arrselesai = arrselesai);

      return arrselesai;
    }).catchError((err) {
      print(err);
    });
  }

  showDialogFunc(context, img, title, desc) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              height: 280,
              width: MediaQuery.of(context).size.width * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.asset(
                      img,
                      width: 150,
                      height: 150,
                    ),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    //width: 200,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        desc,
                        maxLines: 3,
                        style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // buildTextButton(MaterialCommunityIcons.check, "",
                      //     Warnalayer.facebookColor),
                      // buildTextButton1(MaterialCommunityIcons.close, "",
                      //     Warnalayer.googleColor)
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Warnalayer.backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          child: Column(children: <Widget>[
            Transform.translate(
              offset: Offset(0.0, -(height * 0.23 - height * 0.26)),
              child: Container(
                width: width,
                padding: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0))),
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: <Widget>[
                      TabBar(
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey[400],
                        unselectedLabelStyle: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 15),
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: Colors.blueAccent[200],
                        tabs: <Widget>[
                          Tab(
                            child: Text("Sedang Berjalan"),
                          ),
                          Tab(
                            child: Text("Riwayat"),
                          ),
                        ],
                      ),
                      // Container(
                      //   padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                      //   width: double.infinity,
                      //   child: DropdownButton<String>(
                      //     style: new TextStyle(
                      //       color: Colors.blueGrey[100],
                      //     ),
                      //     hint: Text("Pilih Filter"),
                      //     value: arrcmb,
                      //     onChanged: (String Value) {
                      //       setState(() {
                      //         arrcmb = Value;
                      //       });
                      //     },
                      //     items: arr.map((String arrcmb) {
                      //       return DropdownMenuItem<String>(
                      //         value: arrcmb,
                      //         child: Row(
                      //           children: <Widget>[
                      //             Text(
                      //               arrcmb,
                      //               style: TextStyle(color: Colors.black),
                      //             ),
                      //           ],
                      //         ),
                      //       );
                      //     }).toList(),
                      //   ),
                      // ),
                      Container(
                        height: height * 0.9,
                        child: TabBarView(
                          children: <Widget>[
                            //Sedang berjalan
                            Container(
                              color: Warnalayer.backgroundColor,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: arrbooking.length == 0
                                      ? 1
                                      : arrbooking.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          arrbooking.length == 0
                                              ? Card(
                                                  child: Text("ITEM KOSONG"),
                                                )
                                              : Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      print(
                                                          "ini jum arrboking.length " +
                                                              arrbooking[index]
                                                                  .usernamesalon
                                                                  .toString());
                                                    },
                                                    child: Stack(
                                                      children: <Widget>[
                                                        Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  10.0,
                                                                  5.0,
                                                                  10.0,
                                                                  0.0),
                                                          width: 400,
                                                          height: 140,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                          ),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container(
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              13.0),
                                                                  child: Image
                                                                      .network(
                                                                    main_variable
                                                                            .ipnumber +
                                                                        "/gambar/" +
                                                                        arrbooking[index]
                                                                            .foto,
                                                                    width:
                                                                        120.0,
                                                                    height: 120,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                  // child: Image(
                                                                  //   width:
                                                                  //       120.0,
                                                                  //   height: 120,
                                                                  //   image: AssetImage(
                                                                  //       "images/background.png"),
                                                                  //   fit: BoxFit
                                                                  //       .cover,
                                                                  // ),
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        10,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      child:
                                                                          Text(
                                                                        arrbooking[index]
                                                                            .usernamesalon,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              18.0,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .fromLTRB(
                                                                              0,
                                                                              10,
                                                                              0,
                                                                              0),
                                                                      child:
                                                                          Text(
                                                                        'Layanan        : ' +
                                                                            arrbooking[index].namalayanan,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .fromLTRB(
                                                                              0,
                                                                              0,
                                                                              50,
                                                                              0),
                                                                      child:
                                                                          Text(
                                                                        'Pembayaran : ' +
                                                                            arrbooking[index].pembayaran,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .fromLTRB(
                                                                              0,
                                                                              0,
                                                                              50,
                                                                              0),
                                                                      child:
                                                                          Text(
                                                                        'Total : Rp. ' +
                                                                            numberFormat.format(int.parse(arrbooking[index].total)),
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      padding: EdgeInsets
                                                                          .only(
                                                                              top: 10),
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            print("button1");
                                                                          },
                                                                          style: TextButton.styleFrom(
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                                              primary: Colors.white,
                                                                              backgroundColor: Color(0xff374ABE)),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                "Beri penilaian",
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          padding: EdgeInsets.fromLTRB(
                                                                              0,
                                                                              0,
                                                                              10,
                                                                              0),
                                                                        ),
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            print("button 2");
                                                                          },
                                                                          style: TextButton.styleFrom(
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                                              primary: Colors.white,
                                                                              backgroundColor: Colors.red[600]),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                "Pesan Lagi",
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                            ),
                            //Riwayaat
                            Container(
                              color: Warnalayer.backgroundColor,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: arrselesai.length == 0
                                      ? 1
                                      : arrselesai.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          arrselesai.length == 0
                                              ? Card(
                                                  child: Text("ITEM KOSONG"),
                                                )
                                              : Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                  ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      print(
                                                          "ini jum arrboking.length " +
                                                              arrbooking[index]
                                                                  .usernamesalon
                                                                  .toString());
                                                    },
                                                    child: Stack(
                                                      children: <Widget>[
                                                        Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  10.0,
                                                                  5.0,
                                                                  10.0,
                                                                  0.0),
                                                          width: 400,
                                                          height: 140,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20.0),
                                                          ),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Container(
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(
                                                                            10),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              13.0),
                                                                  child: Image
                                                                      .network(
                                                                    main_variable
                                                                            .ipnumber +
                                                                        "/gambar/" +
                                                                        arrbooking[index]
                                                                            .foto,
                                                                    width:
                                                                        120.0,
                                                                    height: 120,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                  // child: Image(
                                                                  //   width:
                                                                  //       120.0,
                                                                  //   height: 120,
                                                                  //   image: AssetImage(
                                                                  //       "images/background.png"),
                                                                  //   fit: BoxFit
                                                                  //       .cover,
                                                                  // ),
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        10,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      child:
                                                                          Text(
                                                                        arrbooking[index]
                                                                            .usernamesalon,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              18.0,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .fromLTRB(
                                                                              0,
                                                                              10,
                                                                              0,
                                                                              0),
                                                                      child:
                                                                          Text(
                                                                        'Layanan        : ' +
                                                                            arrbooking[index].namalayanan,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .fromLTRB(
                                                                              0,
                                                                              0,
                                                                              50,
                                                                              0),
                                                                      child:
                                                                          Text(
                                                                        'Pembayaran : ' +
                                                                            arrbooking[index].pembayaran,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .fromLTRB(
                                                                              0,
                                                                              0,
                                                                              50,
                                                                              0),
                                                                      child:
                                                                          Text(
                                                                        'Total : Rp. ' +
                                                                            numberFormat.format(int.parse(arrbooking[index].total)),
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      padding: EdgeInsets
                                                                          .only(
                                                                              top: 10),
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            print("button1");
                                                                          },
                                                                          style: TextButton.styleFrom(
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                                              primary: Colors.white,
                                                                              backgroundColor: Color(0xff374ABE)),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                "Beri penilaian",
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          padding: EdgeInsets.fromLTRB(
                                                                              0,
                                                                              0,
                                                                              10,
                                                                              0),
                                                                        ),
                                                                        TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            print("button 2");
                                                                          },
                                                                          style: TextButton.styleFrom(
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                                              primary: Colors.white,
                                                                              backgroundColor: Colors.red[600]),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                "Pesan Lagi",
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
