import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ta_salon/ClassLayananWithUsers.dart';
import 'package:ta_salon/ClassSalon.dart';
import 'package:ta_salon/ClassUser.dart';
import 'package:ta_salon/DashboardSalon.dart';
import 'package:ta_salon/DetailServiceSalon.dart';
import 'package:ta_salon/DetailServiceSalon_salon.dart';
import 'package:ta_salon/EditServiceSalon.dart';
import 'package:ta_salon/IklanSalon.dart';
import 'package:ta_salon/ServiceSalon.dart';
import 'package:ta_salon/TambahLayananSalon.dart';
import 'package:ta_salon/WithdrawSalon.dart';
import 'main_variable.dart' as main_variable;
import 'dart:async';
import 'package:ta_salon/dashboardadmin.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'ClassKategori.dart';
import 'package:intl/intl.dart';
import 'ClassLayananSalon.dart';
import 'dart:convert';

class Homesalon extends StatefulWidget {
  @override
  HomesalonState createState() => HomesalonState();
}

class HomesalonState extends State<Homesalon> {
  ClassKategori selectedKategori;
  ClassLayanansalon datalama =
      new ClassLayanansalon("", "", "", "", "", "", "", "", "", "", "", "", "");

  NumberFormat numberFormat = NumberFormat(',000');

  TextEditingController myUsername = new TextEditingController();
  TextEditingController myNamalayanan = new TextEditingController();
  TextEditingController myJenjangusia = new TextEditingController();
  TextEditingController myHargapriadewasa = new TextEditingController();
  TextEditingController myHargapriaanak = new TextEditingController();
  TextEditingController myHargawanitadewasa = new TextEditingController();
  TextEditingController myHargawanitaanak = new TextEditingController();
  TextEditingController myDurasi = new TextEditingController();
  TextEditingController myDeskripsi = new TextEditingController();

  List<ClassLayanansalon> arr = new List();
  List<ClassSalon> arrsalon = new List();
  List<ClassUser> arrsaldo = new List();

  double _rating = 1;
  int _radioValue = 0;
  int _radioValue1 = 0;
  int _radioValue2 = 0;

  String peruntukan = "";
  String jenjang = "";
  String status = "";
  String kategori;
  String foto = main_variable.ipnumber + "/gambar/default.png";

  bool aktifpriadewasa = true;
  bool aktifwanitadewasa = true;
  bool aktifpriaanak = true;
  bool aktifwanitaanak = true;
  bool _isLoading = false;

  void initState() {
    super.initState();
    arr.add(new ClassLayanansalon("id", "username", "namalayanan", "peruntukan",
        "kategori", "0", "0", "deskripsi", "status", "0", "0", "0", "0"));
    arrsalon.add(new ClassSalon("id", "username", "namasalon", "alamat", "kota",
        "telp", "0", "0", "keterangan", "status"));
    arrsaldo.add(new ClassUser(
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
    main_variable.usernamesalon = main_variable.userlogin;
    dataLoadFunction();
  }

  dataLoadFunction() async {
    setState(() {
      _isLoading = true; // your loader has started to load
    });
    // fetch you data over here
    getsaldouser();
    getlayanansalon();
    getidsalon();
    setState(() {
      _isLoading = false; // your loder will stop to finish after the data fetch
    });
  }

  Future<ClassSalon> getidsalon() async {
    List<ClassSalon> arrtemp = new List();

    Map paramData = {
      'username': main_variable.userlogin,
    };
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/getidsalon",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];

      for (int i = 0; i < data.length; i++) {
        ClassSalon databaru = new ClassSalon(
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
        );
        arrtemp.add(databaru);
      }
      setState(() => this.arrsalon = arrtemp);
      setState(() => main_variable.idsalonlogin = arrsalon[0].id.toString());
      // print("ini status1 : " + arrsalon[0].status);

      return arrtemp;
    }).catchError((err) {
      print(err);
    });
  }

  Future<ClassUser> getsaldouser() async {
    List<ClassUser> arrtemp = new List();
    Map paramData = {
      'username': main_variable.userlogin,
    };
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/getsaldouser",
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
          data[i]['status'].toString(),
        );
        arrtemp.add(databaru);
      }
      setState(() => this.arrsaldo = arrtemp);

      return arrtemp;
    }).catchError((err) {
      print(err);
    });
  }

  Future<ClassSalon> statussalon() async {
    Map paramData = {
      'username': main_variable.userlogin,
      'status': status,
    };
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/statussalon",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];
      print("ini resbody : " + res.body);

      for (int i = 0; i < data.length; i++) {
        // ClassSalon databaru = new ClassSalon(
        //   data[i]['id'].toString(),
        //   data[i]['username'].toString(),
        //   data[i]['namasalon'].toString(),
        //   data[i]['alamat'].toString(),
        //   data[i]['kota'].toString(),
        //   data[i]['telp'].toString(),
        //   data[i]['longitude'].toString(),
        //   data[i]['latitude'].toString(),
        //   data[i]['keterangan'].toString(),
        //   data[i]['status'].toString(),
        // );
        // this.arrsalon.add(databaru);
        setState(() {
          arrsalon[0].setstatus(data[i]['status'].toString());
        });
      }
      print(arrsalon.length.toString() + "ini length arr");

      return arrsalon;
    }).catchError((err) {
      print(err);
    });
  }

  Future<ClassLayanansalon> getlayanansalon() async {
    List<ClassLayanansalon> arrtemp = new List();
    Map paramData = {
      'username': main_variable.userlogin,
    };
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/getlayanansalon",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];

      for (int i = 0; i < data.length; i++) {
        ClassLayanansalon databaru = new ClassLayanansalon(
            data[i]['id'].toString(),
            data[i]['username'].toString(),
            data[i]['namalayanan'].toString(),
            data[i]['peruntukan'].toString(),
            data[i]['kategori'].toString(),
            data[i]['jenjangusia'].toString(),
            data[i]['durasi'].toString(),
            data[i]['deskripsi'].toString(),
            data[i]['status'].toString(),
            data[i]['hargapriadewasa'].toString(),
            data[i]['hargawanitadewasa'].toString(),
            data[i]['hargapriaanak'].toString(),
            data[i]['hargawanitaanak'].toString());
        arrtemp.add(databaru);
      }
      setState(() => this.arr = arrtemp);

      return arrtemp;
    }).catchError((err) {
      print(err);
    });
  }

  showDialogFunc() {
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
              height: 300,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 150,
                    width: 450,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        image: DecorationImage(
                            image: AssetImage("images/sad.jpg"),
                            fit: BoxFit.cover)),
                    child: Container(),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text("Yakin mau tutup salon ?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                        )),
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 20, 10, 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 35,
                              child: RaisedButton(
                                onPressed: () {
                                  // print("aple");
                                  //getidsalon();
                                  // print(arrsalon[0].status + " ahaha");
                                  status = "tutup";
                                  if (arrsalon[0].status == status) {
                                    print("a");
                                    print("perbanidngan = " +
                                        arrsalon[0].status +
                                        " : " +
                                        status);
                                    Fluttertoast.showToast(
                                        msg:
                                            "Gagal Menutup Salon, Karena Salon Anda Sudah Tutup",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.CENTER,
                                        backgroundColor: Colors.red[300],
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    Navigator.pop(context);
                                  } else {
                                    print("b");
                                    print("perbanidngan = " +
                                        arrsalon[0].status +
                                        " : " +
                                        status);
                                    statussalon();
                                    if (status == "aktif") {
                                      Fluttertoast.showToast(
                                          msg: "Berhasil Membuka Salon",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.CENTER,
                                          backgroundColor: Colors.blue[300],
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Berhasil Menutup Salon",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.CENTER,
                                          backgroundColor: Colors.blue[300],
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                    status = "";
                                    Navigator.pop(context);
                                  }

                                  print("tutup");
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80.0)),
                                padding: EdgeInsets.all(0.0),
                                child: Ink(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xff374ABE),
                                          Color(0xff64B6FF)
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 150.0, minHeight: 50.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Tutup",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 20, 10, 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 35,
                              child: RaisedButton(
                                onPressed: () {
                                  //getidsalon();
                                  // print(arrsalon[0].status + " hihi");
                                  status = "aktif";
                                  if (arrsalon[0].status == status) {
                                    print("c");
                                    print("perbanidngan = " +
                                        arrsalon[0].status +
                                        " : " +
                                        status);
                                    Fluttertoast.showToast(
                                        msg:
                                            "Gagal Membuka Salon, Karena Salon Anda Sudah Buka",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.CENTER,
                                        backgroundColor: Colors.red[300],
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    Navigator.pop(context);
                                  } else {
                                    print("perbanidngan = " +
                                        arrsalon[0].status +
                                        " : " +
                                        status);
                                    print("d");
                                    statussalon();
                                    if (status == "aktif") {
                                      Fluttertoast.showToast(
                                          msg: "Berhasil Membuka Salon",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.CENTER,
                                          backgroundColor: Colors.blue[300],
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Berhasil Menutup Salon",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.CENTER,
                                          backgroundColor: Colors.blue[300],
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                    status = "";
                                    Navigator.pop(context);
                                  }
                                  print("buka");
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80.0)),
                                padding: EdgeInsets.all(0.0),
                                child: Ink(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xff374ABE),
                                          Color(0xff64B6FF)
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                  child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 320.0, minHeight: 50.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Buka",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
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
    return Scaffold(
      body: _isLoading
          ? SpinKitFadingCube(
              color: Colors.lightGreen[100],
              size: 50.0) // this will show when loading is true
          : Column(
              children: [
                Stack(
                  children: <Widget>[
                    Container(
                      height: 160,
                      width: 400,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          image: DecorationImage(
                              image: AssetImage("images/paris.png"),
                              fit: BoxFit.cover)),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.0),
                                Colors.black.withOpacity(0.0),
                                Colors.black.withOpacity(0.1),
                                Colors.black.withOpacity(0.3),
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
                          RichText(
                            text: TextSpan(
                                text: "Wellcome Back, ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 22),
                                children: [
                                  TextSpan(
                                      text: main_variable.userlogin.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 24)),
                                ]),
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
                Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                ),
                //gojek
                Column(
                  children: <Widget>[
                    // Text("test")
                    Container(
                      height: 240,
                      child: ListView(
                        physics: ScrollPhysics(),
                        padding:
                            EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0),
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
                                                Text("MidTrans",
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
                                                    "Rp. " +
                                                        numberFormat.format(
                                                            int.parse(
                                                                arrsaldo[0]
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
                                                                        WithdrawSalon(),
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
                                                                    .attach_money_rounded,
                                                                color: Colors
                                                                    .green,
                                                                size: 30.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text("Saldo",
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
                                                          print("masuk2");
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
                                                                    .book_online_outlined,
                                                                color: Colors
                                                                        .lightBlue[
                                                                    200],
                                                                size: 30.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text("Laporan",
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
                                                                        IklanSalon(),
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
                                                                    .tv_outlined,
                                                                color:
                                                                    Colors.blue,
                                                                size: 30.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text("Iklan Salon",
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
                                                                    .chat_outlined,
                                                                color: Colors
                                                                        .yellow[
                                                                    900],
                                                                size: 30.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text("Chat",
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
                                                                Icons
                                                                    .report_gmailerrorred_rounded,
                                                                color: Colors
                                                                    .red[300],
                                                                size: 30.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text("Lapor Pengguna",
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
//                                                    getidsalon();
                                                          print("masuk6");
                                                          print(arrsalon[0]
                                                                  .status +
                                                              " - " +
                                                              status);
                                                          showDialogFunc();
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
                                                                    .sensor_door,
                                                                color: Colors
                                                                        .orangeAccent[
                                                                    200],
                                                                size: 30.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Text("Tutup / Buka",
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
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Layanan Salon',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TambahLayananSalon(),
                              ));
                          print('Masuk On Tap');
                        },
                        child: Text(
                          'Tambah',
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
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
                    itemCount: arr.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(40.0, 5.0, 20.0, 5.0),
                            height: 150.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white70,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Padding(
                              padding:
                                  EdgeInsets.fromLTRB(100.0, 15.0, 20.0, 20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.fromLTRB(
                                            0.0, 0.0, 0.0, 0.0),
                                        width: 120.0,
                                        child: Text(
                                          "Nama Layanan : ",
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            arr[index].namalayanan,
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.fromLTRB(
                                            0.0, 0.0, 0.0, 0.0),
                                        width: 120.0,
                                        child: Text(
                                          "Kategori             : ",
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            arr[index].kategori,
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.fromLTRB(
                                            0.0, 0.0, 0.0, 0.0),
                                        width: 120.0,
                                        child: Text(
                                          "Jenjang              : ",
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            arr[index].jenjangusia,
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.fromLTRB(
                                            0.0, 0.0, 0.0, 0.0),
                                        width: 120.0,
                                        child: Text(
                                          "Deskripsi           : ",
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                      Column(
                                        children: <Widget>[
                                          Text(
                                            //arr[index].deskripsi,
                                            arr[index].deskripsi.length > 10
                                                ? arr[index]
                                                        .deskripsi
                                                        .substring(0, 10) +
                                                    '...'
                                                : arr[index].deskripsi,
                                            //" Ini adalah des... ",
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(
                                    children: <Widget>[
                                      RaisedButton(
                                        onPressed: () {
                                          print('ini button booking ' +
                                              index.toString());
                                          print("nama layanan : " +
                                              arr[index].namalayanan);
                                          print("nama id : " + arr[index].id);
                                          print("nama kategori : " +
                                              arr[index].kategori);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DetailServiceSalon_salon(
                                                          namaservicekirim:
                                                              arr[index]
                                                                  .namalayanan,
                                                          idservice:
                                                              arr[index].id,
                                                          kodelayanan:
                                                              arr[index]
                                                                  .kategori)));
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(80.0)),
                                        padding: EdgeInsets.all(0.0),
                                        child: Ink(
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xff374ABE),
                                                  Color(0xff64B6FF)
                                                ],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(30.0)),
                                          child: Container(
                                            constraints: BoxConstraints(
                                                maxWidth: 100.0,
                                                minHeight: 35.0),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Booking",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
                                      RaisedButton(
                                        onPressed: () {
                                          print('ini button edit ' +
                                              index.toString());
                                          print("nama layanan : " +
                                              arr[index].namalayanan);
                                          print("nama id : " + arr[index].id);
                                          print("nama kategori : " +
                                              arr[index].kategori);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditServiceSalon(
                                                          namaservicekirim:
                                                              arr[index]
                                                                  .namalayanan,
                                                          idservice:
                                                              arr[index].id,
                                                          kodelayanan:
                                                              arr[index]
                                                                  .kategori)));
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(80.0)),
                                        padding: EdgeInsets.all(0.0),
                                        child: Ink(
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Color(0xff374ABE),
                                                  Color(0xff64B6FF)
                                                ],
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(30.0)),
                                          child: Container(
                                            constraints: BoxConstraints(
                                                maxWidth: 100.0,
                                                minHeight: 35.0),
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Edit",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                letterSpacing: 1.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            left: 20.0,
                            top: 15.0,
                            bottom: 15.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: Image(
                                width: 110.0,
                                image: AssetImage("images/background.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
