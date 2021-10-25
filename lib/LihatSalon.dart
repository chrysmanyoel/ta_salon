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
  TextEditingController myCari = new TextEditingController();
  List<ClassUser> arrsalon = new List();
  List<ClassSalonJoinUser> arrcari = new List();
  int _selectedIndexcarousel = 0;
  double _rating = 1;
  String foto = main_variable.ipnumber + "/gambar/default.png";

  void initState() {
    super.initState();
    setState(() {
      arrcari.add(new ClassSalonJoinUser(
          "id",
          "username",
          "namasalon",
          "alamat",
          "kota",
          "telp",
          "0",
          "0",
          "keterangan",
          "status",
          "default.png",
          "pembayaran",
          "jambuka",
          "jamtutup",
          "hari",
          'kategori'));
    });
    carisalon();
    //getallsalonuser();
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
    List<ClassSalonJoinUser> arrtemp = new List();
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
      print("c " + data.toString());

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
            data[i]['foto'].toString(),
            data[i]['pembayaran'].toString(),
            data[i]['jambuka'].toString(),
            data[i]['jamtutup'].toString(),
            data[i]['hari'].toString(),
            data[i]['kategori'].toString());
        arrtemp.add(databaru);
        foto = main_variable.ipnumber + "/gambar/" + arrtemp[i].foto;
      }
      setState(() => this.arrcari = arrtemp);

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
                      left: 20,
                      top: 10,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.keyboard_backspace,
                          size: 32,
                          color: Colors.white,
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
                              SizedBox(width: 8.0),
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
                        'Search Salon',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
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
                        controller: myCari,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 3),
                            prefixIcon: Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  print("search Salon");
                                  carisalon();
                                  print(
                                      "jumlah : " + arrcari.length.toString());
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
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 60, 20, 10),
                      width: 350,
                      height: 510,
                      //color: Colors.red,
                      child: ListView(
                        children: [
                          Container(
                            color: Warnalayer.backgroundColor,
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount:
                                    arrcari.length == 0 ? 1 : arrcari.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        arrcari.length == 0
                                            ? Container(
                                                child: Card(
                                                  elevation: 5,
                                                  shadowColor: Colors.black,
                                                  child: SizedBox(
                                                    width: 350,
                                                    height: 500,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 50),
                                                          height: 350,
                                                          width: 300,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                              image: DecorationImage(
                                                                  image: AssetImage(
                                                                      "images/kosong.jpg"),
                                                                  fit: BoxFit
                                                                      .cover)),
                                                          child: Container(),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 10, 0, 00),
                                                          child: Text(
                                                              "Oops, Tidak Ada Data Yang Dicari",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize: 20,
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              )
                                            //INI TAMPILAN KALO DAPET SERACH
                                            : Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    10, 10, 10, 10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height -
                                                    620,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    print("masukk coy-" +
                                                        arrcari[index]
                                                            .namasalon);
                                                    main_variable
                                                            .usernamesalon =
                                                        arrcari[index].username;
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              DetailSalon(
                                                            namasalonkirim:
                                                                arrcari[index]
                                                                    .namasalon,
                                                            kotakrim:
                                                                arrcari[index]
                                                                    .kota,
                                                          ),
                                                        ));
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                          width: 400,
                                                          margin: EdgeInsets
                                                              .fromLTRB(10, 10,
                                                                  10, 0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Kategori : " +
                                                                    arrcari[index]
                                                                        .kategori,
                                                                style:
                                                                    TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      1,
                                                                  fontSize: 15,
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                      Divider(
                                                        color: Colors.grey,
                                                      ),
                                                      Container(
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              flex: 2,
                                                              child: Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        10,
                                                                        0,
                                                                        10,
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
                                                                        arrcari[index]
                                                                            .foto,
                                                                    width:
                                                                        170.0,
                                                                    height: 150,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              flex: 3,
                                                              child: Container(
                                                                //color: Colors.red,
                                                                height: 150,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Container(
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            10),
                                                                        child:
                                                                            Text(
                                                                          arrcari[index]
                                                                              .namasalon,
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                16,
                                                                            letterSpacing:
                                                                                1,
                                                                          ),
                                                                        )),
                                                                    Container(
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            5),
                                                                        child:
                                                                            Text(
                                                                          arrcari[index]
                                                                              .alamat,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.grey,
                                                                            fontSize:
                                                                                14,
                                                                            letterSpacing:
                                                                                1,
                                                                          ),
                                                                        )),
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .fromLTRB(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              5),
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Icon(
                                                                            MaterialCommunityIcons.directions,
                                                                            size:
                                                                                15.0,
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                          SizedBox(
                                                                              width: 10.0),
                                                                          Text(
                                                                            arrcari[index].kota,
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 14.0,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Icon(
                                                                            MaterialCommunityIcons.cellphone,
                                                                            size:
                                                                                15.0,
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                          SizedBox(
                                                                              width: 10.0),
                                                                          Text(
                                                                            arrcari[index].telp,
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.grey,
                                                                              fontSize: 14.0,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      margin: EdgeInsets
                                                                          .fromLTRB(
                                                                              0,
                                                                              10,
                                                                              0,
                                                                              10),
                                                                      child:
                                                                          _buildRatingStars(
                                                                              4),
                                                                    ),
                                                                    Row(
                                                                      children: <
                                                                          Widget>[
                                                                        Container(
                                                                            child:
                                                                                Text(
                                                                          arrcari[index].hari +
                                                                              " : ",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            fontSize:
                                                                                14,
                                                                            letterSpacing:
                                                                                1,
                                                                          ),
                                                                        )),
                                                                        Container(
                                                                          padding: EdgeInsets.fromLTRB(
                                                                              0,
                                                                              5,
                                                                              0,
                                                                              5),
                                                                          width:
                                                                              50.0,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.lightBlueAccent,
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                          ),
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child: Text(arrcari[index].jambuka.substring(
                                                                              0,
                                                                              5)),
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                3.0),
                                                                        Container(
                                                                          child:
                                                                              Text(
                                                                            " - ",
                                                                            style:
                                                                                TextStyle(fontSize: 18),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                3.0),
                                                                        Container(
                                                                          padding:
                                                                              EdgeInsets.all(5.0),
                                                                          width:
                                                                              50.0,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.lightBlueAccent,
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                          ),
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child: Text(arrcari[index].jamtutup.substring(
                                                                              0,
                                                                              5)),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
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
              ],
            )
          ],
        ),
      ),
    );
  }
}
