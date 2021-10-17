import 'package:flutter/material.dart';
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
import 'ClassIklan.dart';
import 'package:path/path.dart';
import 'dart:convert';

class AccIklan extends StatefulWidget {
  @override
  AccIklanState createState() => AccIklanState();
}

class AccIklanState extends State<AccIklan> {
  List<ClassIklan> arriklan = new List();
  List<ClassIklan> arriklanacc = new List();
  String idiklan = '0', status = "";

  void initState() {
    super.initState();
    getiklan_admin();
    getiklan_admin_acc();
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
      print("aple");
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

  Future<ClassIklan> terima_iklan() async {
    Map paramData = {
      'username': main_variable.userlogin,
      'idiklan': idiklan,
      'status': status,
    };
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/terima_iklan",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];
      print(res.body);
      print(data.length);

      getiklan_admin();
      getiklan_admin_acc();

      return arriklan;
    }).catchError((err) {
      print(err);
    });
  }

  Future<ClassIklan> getiklan_admin_acc() async {
    arriklanacc.clear();
    Map paramData = {};
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/getiklan_admin_acc",
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
          this.arriklanacc.add(databaru);
        });
      }

      return arriklanacc;
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
          "Halaman Iklan",
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                shadowColor: Colors.black,
                color: Colors.white,
                child: SizedBox(
                  width: 350,
                  height: 50,
                  child: Container(
                    //margin: EdgeInsets.only(left: 60),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text(
                            'Sisa Kuota Iklan : ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..color = Colors.black
                                ..strokeWidth = 2.0,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text(
                            arriklanacc.length.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..color = Colors.black
                                ..strokeWidth = 2.0,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text(
                            '/',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..color = Colors.black
                                ..strokeWidth = 2.0,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text(
                            '10',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..color = Colors.red
                                ..strokeWidth = 2.0,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 95, 20, 0),
              height: 350,
              width: 350,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: arriklan.length,
                itemBuilder: (BuildContext context, int index) => Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Container(
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      //shadowColor: Colors.black,
                      color: Colors.white,
                      child: SizedBox(
                        width: 340,
                        height: 350,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(70, 10, 0, 5),
                                child: Text(
                                  'Konfirmasi Iklan Salon',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..color = Colors.black
                                      ..strokeWidth = 2.0,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.black,
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(30, 5, 0, 0),
                                color: Colors.black,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    main_variable.ipnumber +
                                        "/gambar/" +
                                        arriklan[index].foto,
                                    width: 280,
                                    height: 150,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(30, 20, 0, 5),
                                child: Text(
                                  'Nama Salon    : ' + arriklan[index].username,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    foreground: Paint()
                                      ..color = Colors.black
                                      ..strokeWidth = 2.0,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(30, 10, 0, 5),
                                child: Text(
                                  'Tanggal Sewa : ' +
                                      arriklan[index].tanggal_awal +
                                      " - " +
                                      arriklan[index].tanggal_akhir,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    foreground: Paint()
                                      ..color = Colors.black
                                      ..strokeWidth = 2.0,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(80, 0, 10, 10),
                                      child: TextButton(
                                        onPressed: () {
                                          print("masuk terima");
                                          idiklan = arriklan[index].idiklan;
                                          status = 'aktif';
                                          terima_iklan();

                                          // setState(() {

                                          //});
                                        },
                                        style: TextButton.styleFrom(
                                            side: BorderSide(
                                                width: 1, color: Colors.grey),
                                            minimumSize: Size(40, 35),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            primary: Colors.white,
                                            backgroundColor: Color(0xff374ABE)),
                                        child: Center(
                                          child: Text(
                                            "Terima",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(20, 0, 20, 10),
                                      child: TextButton(
                                        onPressed: () {
                                          print("masuk tolak");

                                          idiklan = arriklan[index].idiklan;
                                          status = 'reject';
                                          terima_iklan();

                                          setState(() {
                                            terima_iklan();
                                            getiklan_admin();
                                            getiklan_admin_acc();
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                            side: BorderSide(
                                                width: 1, color: Colors.grey),
                                            minimumSize: Size(40, 35),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            primary: Colors.white,
                                            backgroundColor: Colors.red[600]),
                                        child: Center(
                                          child: Text(
                                            "Tolak  ",
                                            textAlign: TextAlign.center,
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
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(20, 470, 20, 0),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                shadowColor: Colors.black,
                color: Colors.white,
                child: SizedBox(
                  width: 350,
                  height: 250,
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(10, 10, 0, 5),
                          child: Text(
                            'List Iklan Yang Berlangsung',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              foreground: Paint()
                                ..color = Colors.black
                                ..strokeWidth = 2.0,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.black,
                        ),
                        Container(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: arriklanacc.length,
                            itemBuilder: (BuildContext context, int index) =>
                                Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(20, 10, 0, 5),
                                      child: Row(
                                        children: [
                                          Text(
                                            '• ',
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                              foreground: Paint()
                                                ..color = Colors.black
                                                ..strokeWidth = 2.0,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                          Text(
                                            arriklanacc[index].username,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              foreground: Paint()
                                                ..color = Colors.black
                                                ..strokeWidth = 2.0,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(35, 0, 0, 5),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Tanggal : ',
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              foreground: Paint()
                                                ..color = Colors.black
                                                ..strokeWidth = 2.0,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                          Text(
                                            arriklanacc[index].tanggal_awal +
                                                " - " +
                                                arriklanacc[index]
                                                    .tanggal_akhir,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              foreground: Paint()
                                                ..color = Colors.red
                                                ..strokeWidth = 2.0,
                                              letterSpacing: 0.2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
