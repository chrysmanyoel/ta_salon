import 'package:ta_salon/ClassAbsensiPegawai.dart';
import 'package:ta_salon/ClassPegawai.dart';
import 'package:ta_salon/ClassSalon.dart';
import 'package:ta_salon/ClassAbsensiPegawai.dart';
import 'package:ta_salon/ClassDetailPegawai.dart';
import 'package:flutter/material.dart';
import 'main_variable.dart' as main_variable;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:ta_salon/ClassPilihJenjangPeruntukan.dart';
import 'package:ta_salon/ClassLayananSalon.dart';
import 'package:ta_salon/ClassLayananSalon.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ta_salon/ClassDataPegawai.dart';
import 'ClassBookingService.dart';
import 'package:ta_salon/warnalayer.dart';
import 'package:ta_salon/ServiceSalon.dart';
import 'package:ta_salon/ClassKategori.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InsertPegawai extends StatefulWidget {
  @override
  InsertPegawaiState createState() => InsertPegawaiState();
}

class InsertPegawaiState extends State<InsertPegawai> {
  TextEditingController myNama1 = new TextEditingController();
  TextEditingController myNama2 = new TextEditingController();
  TextEditingController myNama3 = new TextEditingController();

  TextEditingController myAlamat1 = new TextEditingController();
  TextEditingController myAlamat2 = new TextEditingController();
  TextEditingController myAlamat3 = new TextEditingController();

  TextEditingController myTelp1 = new TextEditingController();
  TextEditingController myTelp2 = new TextEditingController();
  TextEditingController myTelp3 = new TextEditingController();

  TextEditingController myStatus1 = new TextEditingController();
  TextEditingController myStatus2 = new TextEditingController();
  TextEditingController myStatus3 = new TextEditingController();
  TextEditingController myIdkategori = new TextEditingController();
  TextEditingController mykateg = new TextEditingController();
  TextEditingController keterangan = new TextEditingController();

  TextEditingController myTgl = new TextEditingController();
  TextEditingController myTime = new TextEditingController();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = new TimeOfDay.now();

  ClassPegawai selectarrpeg = null;
  ClassDataPegawai selectarrpeg1 = null;
  bool isAktif = true;
  bool isNonAktif = false;
  bool iscreambath = false;
  bool ispotong = false;
  bool ismenikur = false;
  bool ispedikur = false;
  bool _like = false;

  String status = "", idSalon;
  String idpeg, idkat;
  String namaservicekirim, total;
  String kirimidpeg_absen = "";
  int _radioValue = 0;

  List<ClassPegawai> arrpegawai = new List(); //INI DIPAKE BUAT COMBOBOX ABSEN
  List<ClassAbsensiPegawai> arrabsen = new List();
  List<ClassDataPegawai> arrdatapeg = new List(); //INI DIPAKE BUAT TAMBAH SKILL
  List<ClassLayanansalon> arr = new List();
  List<ClassKategori> arrkategori = new List();
  List<ClassKategori> arridkategori = new List();
  List<ClassBookingService> arrbooking = new List();

  ClassSalon datalama = new ClassSalon("", "", "", "", "", "", "", "", "", "");
  ClassDetailPegawai datalama1 = new ClassDetailPegawai("", "", "");

  void initState() {
    super.initState();
    getpegawai();
    getabsenpegawai();
    getdatapegawai();
    //getallkategori();
    getallidkategori();
    arridkategori.add(new ClassKategori("id", "idkategori", "namakategori"));

    print("datapegwai : " + arrpegawai.toString());
    print("id salon : " + main_variable.idsalonlogin);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
        });

    if (picked_s != null && picked_s != selectedTime)
      setState(() {
        print(picked_s);
        selectedTime = picked_s;
        myTime.text = selectedTime.hour.toString().padLeft(2, "0") +
            ":" +
            selectedTime.minute.toString().padLeft(2, "0");
      });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2021, 12));
    //lastDate: DateTime( .year, date.month - 1, date.day));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        myTgl.text = selectedDate.toString().substring(0, 10);
      });
  }

  // Future<String> getallkategori() async {
  //   var idpegawai = "";
  //   if (selectarrpeg1 != null) {
  //     idpegawai = selectarrpeg1.id;
  //   }
  //   Map paramData = {'idpegawai': idpegawai};
  //   var parameter = json.encode(paramData);

  //   arrkategori.clear();
  //   http
  //       .post(main_variable.ipnumber + "/getallkategori",
  //           headers: {"Content-Type": "application/json"}, body: parameter)
  //       .then((res) {
  //     var data = json.decode(res.body);
  //     data = data[0]['status'];
  //     print(res.body);
  //     print(data.length);

  //     for (int i = 0; i < data.length; i++) {
  //       ClassKategori databaru = new ClassKategori(
  //           data[i]['id'].toString(),
  //           data[i]['idkategori'].toString(),
  //           data[i]['namakategori'].toString());
  //       databaru.aktif = data[i]['aktif'];
  //       this.arrkategori.add(databaru);
  //     }
  //     setState(() => this.arrkategori = arrkategori);
  //     print("arrkategori : " + arrkategori.toString());

  //     return arrkategori;
  //   }).catchError((err) {
  //     print(err);
  //   });
  // }

  Future<String> getallidkategori() async {
    List<ClassKategori> arrtemp = new List();
    var idpegawai = "";
    if (selectarrpeg1 != null) {
      idpegawai = selectarrpeg1.id;
    }
    Map paramData = {'idpegawai': idpegawai};
    var parameter = json.encode(paramData);

    arridkategori.clear();
    http
        .post(main_variable.ipnumber + "/getallidkategori",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];
      print(res.body);
      print(data.length);

      for (int i = 0; i < data.length; i++) {
        ClassKategori databaru = new ClassKategori(
            data[i]['id'].toString(),
            data[i]['idkategori'].toString(),
            data[i]['namakategori'].toString());
        databaru.aktif = data[i]['aktif'];
        arrtemp.add(databaru);
      }
      setState(() => this.arridkategori = arrtemp);
      print("arrkategori : " + arrkategori.toString());

      return arrtemp;
    }).catchError((err) {
      print(err);
    });
  }

  Future<String> getpegawai() async {
    Map paramData = {
      'idsalon': main_variable.idsalonlogin,
    };
    var parameter = json.encode(paramData);
    this.arrpegawai.clear();
    http
        .post(main_variable.ipnumber + "/getpegawai",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];
      print(res.body);
      print(data.length);

      for (int i = 0; i < data.length; i++) {
        ClassPegawai databaru = new ClassPegawai(
            data[i]['id'].toString(),
            data[i]['idsalon'].toString(),
            data[i]['nama'].toString(),
            data[i]['alamat'].toString(),
            data[i]['telp'].toString(),
            data[i]['status'].toString());
        this.arrpegawai.add(databaru);
      }
      setState(() => this.arrpegawai = arrpegawai);

      return arrpegawai;
    }).catchError((err) {
      print(err);
    });
  }

  Future<ClassAbsensiPegawai> getabsenpegawai() async {
    Map paramData = {
      'idsalon': main_variable.idsalonlogin,
    };
    var parameter = json.encode(paramData);
    this.arrabsen.clear();
    http
        .post(main_variable.ipnumber + "/getabsensipegawai",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];
      print(res.body);
      print(data.length);

      for (int i = 0; i < data.length; i++) {
        ClassAbsensiPegawai databaru = new ClassAbsensiPegawai(
            data[i]['id'].toString(),
            data[i]['idpegawai'].toString(),
            data[i]['idsalon'].toString(),
            data[i]['nama'].toString(),
            data[i]['tanggal'].toString(),
            data[i]['waktu'].toString(),
            data[i]['keterangan'].toString());
        this.arrabsen.add(databaru);
      }
      setState(() => this.arrabsen = arrabsen);

      return arrabsen;
    }).catchError((err) {
      print(err);
    });
  }

  Future<String> getdatapegawai() async {
    Map paramData = {
      'idsalon': main_variable.idsalonlogin,
    };
    var parameter = json.encode(paramData);
    List<ClassDataPegawai> arrtemp = new List();

    http
        .post(main_variable.ipnumber + "/getdatapegawai_tampil",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];
      print(res.body);
      print(data.length);
      print("aple");

      for (int i = 0; i < data.length; i++) {
        var flagada = false;
        for (int j = 0; j < this.arrdatapeg.length; j++) {
          print("compare = " +
              data[i]['id'].toString() +
              " --- " +
              this.arrdatapeg[j].id.toString());
          if (this.arrdatapeg[j].id.toString() == data[i]['id'].toString()) {
            print("sama idnya");
            flagada = true;
            this.arrdatapeg[j].idkategori =
                this.arrdatapeg[j].idkategori + " " + data[i]['idkategori'];
          }
        }

        if (flagada == false) {
          ClassDataPegawai databaru = new ClassDataPegawai(
              data[i]['id'].toString(),
              data[i]['idsalon'].toString(),
              data[i]['nama'].toString(),
              data[i]['alamat'].toString(),
              data[i]['telp'].toString(),
              data[i]['status'].toString(),
              data[i]['idkategori'].toString());
          this.arrdatapeg.add(databaru);
        }
      }
      setState(() => this.arrdatapeg = arrdatapeg);
      print("total : " + arrdatapeg.length.toString());

      return arrdatapeg;
    }).catchError((err) {
      print(err);
    });
  }

  Future<String> insertpegawai() async {
    Map paramData = {
      'idsalon': main_variable.idsalonlogin,
      'nama': myNama2.text,
      'alamat': myAlamat2.text,
      'telp': myTelp2.text,
      'status': status,
    };
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/insertpegawai",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print("ini res insertpeg : " + res.body);
      var data = json.decode(res.body);
      data = data[0]['status'];

      if (data == "sukses") {
        Fluttertoast.showToast(
            msg: "Pegawai Berhasil Di Input",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Gagal Input Pegawai",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }

      return data;
    }).catchError((err) {
      print(err);
    });
  }

  Future<String> insertabsenpegawai() async {
    Map paramData = {
      'idpegawai': kirimidpeg_absen,
      'idsalon': main_variable.idsalonlogin,
      'nama': myNama1.text,
      'tanggal': myTgl.text,
      'waktu': myTime.text,
      'keterangan': keterangan.text,
    };
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/insertabsenpegawai",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print("ini res insertpeg : " + res.body);
      var data = json.decode(res.body);
      data = data[0]['status'];

      if (data == "sukses") {
        Fluttertoast.showToast(
            msg: "Berhasil memasukan data",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.blue[200],
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (data == "gagal") {
        Fluttertoast.showToast(
            msg: "Gagal, Pegawai telah absen hari ini",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red[200],
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        showDialogFunc();
      }

      return data;
    }).catchError((err) {
      print(err);
    });
  }

  Future<String> getlistbookingsalon() async {
    Map paramData = {
      'usernamesalon': main_variable.userlogin,
    };
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/getlistbookingsalon",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];
      print(res.body);
      print(data.length);

      for (int i = 0; i < data.length; i++) {
        ClassBookingService databaru = new ClassBookingService(
            data[i]['id'].toString(),
            data[i]['tanggal'].toString(),
            data[i]['username'].toString(),
            data[i]['namauser'].toString(),
            data[i]['usenamesalon'].toString(),
            data[i]['idservice'].toString(),
            data[i]['tanggalbooking'].toString(),
            data[i]['jambooking'].toString(),
            data[i]['jambookingselesai'].toString(),
            data[i]['requestpegawai'].toString(),
            data[i]['total'].toString(),
            data[i]['usernamecancel'].toString(),
            data[i]['status'].toString(),
            data[i]['pembayaran'].toString(),
            data[i]['jamres'].toString());
        this.arrbooking.add(databaru);
      }
      setState(() => this.arrbooking = arrbooking);

      return arrbooking;
    }).catchError((err) {
      print(err);
    });
  }

  Future<String> cancelsemuabooking() async {
    Map paramData = {
      'usernamesalon': main_variable.userlogin,
      'requestpegawai': myNama1.text,
      'tanggal': myTgl.text,
    };
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/cancelsemuabooking",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];
      print(res.body);
      print(data.length);

      if (data == "sukses") {
        insertabsenpegawai();
        Fluttertoast.showToast(
            msg: "Berhasil memasukan data",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.blue[200],
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        insertabsenpegawai();
        Fluttertoast.showToast(
            msg: "Berhasil Mengcancel Semua Booking Pegawai " + myNama1.text,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.blue[200],
            textColor: Colors.white,
            fontSize: 16.0);
      }

      return data;
    }).catchError((err) {
      print(err);
    });
  }

  Future<String> insertdetailpegawai() async {
    String data = jsonEncode(arridkategori);
    Map paramData = {
      'idpegawai': idpeg,
      'idkategori': data,
    };
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/insertdetailpegawai",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];

      return "";
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: 200,
                    width: 400,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("images/background.png"),
                            fit: BoxFit.cover)),
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                        Colors.black.withOpacity(0.0),
                        Colors.black.withOpacity(0.0),
                        Colors.black.withOpacity(0.5),
                        Colors.black.withOpacity(1.0),
                        Colors.black.withOpacity(1.0),
                      ], begin: Alignment.topRight, end: Alignment.bottomLeft)),
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    left: 20,
                    child: RichText(
                      text: TextSpan(
                          text: "Wellcome Back, ",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                              fontSize: 20),
                          children: [
                            TextSpan(
                                text: main_variable.userlogin.toString() +
                                    "\nHave A Nice Day",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24))
                          ]),
                    ),
                  )
                ],
              ),
              Transform.translate(
                offset: Offset(0.0, -(height * 0.3 - height * 0.26)),
                child: Container(
                  width: width,
                  padding: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: DefaultTabController(
                      length: 4,
                      child: Column(
                        children: <Widget>[
                          TabBar(
                            labelColor: Colors.black,
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                            unselectedLabelColor: Colors.grey[400],
                            unselectedLabelStyle: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 15),
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorColor: Colors.transparent,
                            tabs: <Widget>[
                              Tab(
                                child: Text(" Absensi \nPegawai"),
                              ),
                              Tab(
                                child: Text("   Add \nPegawai"),
                              ),
                              Tab(
                                child: Text("  Detail \nPegawai"),
                              ),
                              Tab(
                                child: Text("    List \nPegawai"),
                                //ini nanti di isi semua list pegawai dan detail setiap pegawai
                              ),
                            ],
                          ),
                          Container(
                            height: height * 0.7,
                            child: TabBarView(
                              children: <Widget>[
                                //ini hal pertama
                                Container(
                                  child: ListView(
                                    children: <Widget>[
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(30, 0, 0, 0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "List Pegawai ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.2,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(30, 0, 30, 10),
                                        width: double.infinity,
                                        child: DropdownButton<ClassPegawai>(
                                          hint: Text(
                                              "Pilih Pegawai Yang Tidak Masuk Hari Ini / Ijin"),
                                          value: selectarrpeg,
                                          onChanged: (ClassPegawai Value) {
                                            setState(() {
                                              selectarrpeg = Value;
                                              myAlamat1.text = Value.alamat;
                                              myNama1.text = Value.nama;
                                              myTelp1.text = Value.telp;
                                              kirimidpeg_absen = Value.id;
                                            });
                                          },
                                          items: arrpegawai
                                              .map((ClassPegawai arrpegawai) {
                                            return DropdownMenuItem<
                                                ClassPegawai>(
                                              value: arrpegawai,
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    arrpegawai.nama,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(30, 0, 0, 0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Nama Pegawai ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.2,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 10, 30, 0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 60,
                                          child: buildTextField(
                                              MaterialCommunityIcons
                                                  .account_outline,
                                              "Nama Pegawai",
                                              false,
                                              false,
                                              false,
                                              myNama1),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(30, 0, 0, 0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Alamat ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.2,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 10, 30, 0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 60,
                                          child: buildTextField(
                                              MaterialCommunityIcons.routes,
                                              "Alamat",
                                              false,
                                              false,
                                              false,
                                              myAlamat1),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(30, 0, 0, 0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Telephone ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.2,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 10, 30, 0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 60,
                                          child: buildTextField(
                                              MaterialCommunityIcons.phone,
                                              "Telephone",
                                              false,
                                              false,
                                              false,
                                              myTelp1),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(30, 0, 0, 0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Tanggal Absen ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.2,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 30, right: 20),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 6,
                                              child: Center(
                                                child: TextFormField(
                                                  controller: myTgl,
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          'Tanggal Absen'),
                                                  style: TextStyle(
                                                    letterSpacing: 1.0,
                                                  ),
                                                  enabled: false,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10.0),
                                            Expanded(
                                              flex: 1,
                                              child: Center(
                                                child: Center(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      _selectDate(context);
                                                    },
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0.0,
                                                              20.0,
                                                              10.0,
                                                              .0),
                                                      height: 30,
                                                      width: 30,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(0),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.5),
                                                                blurRadius: 5,
                                                                spreadRadius: 1)
                                                          ]),
                                                      child: Icon(
                                                        Icons.date_range,
                                                        size: 28,
                                                        color: (_like)
                                                            ? Colors.red
                                                            : Colors.grey[600],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(30, 0, 0, 0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Waktu ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.2,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 30, right: 20),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 6,
                                              child: Center(
                                                child: TextFormField(
                                                  controller: myTime,
                                                  decoration: InputDecoration(
                                                      labelText: 'Waktu'),
                                                  style: TextStyle(
                                                    letterSpacing: 1.0,
                                                  ),
                                                  enabled: false,
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10.0),
                                            Expanded(
                                              flex: 1,
                                              child: Center(
                                                child: Center(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      _selectTime(context);
                                                    },
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.fromLTRB(
                                                              0.0,
                                                              20.0,
                                                              10.0,
                                                              0.0),
                                                      height: 30,
                                                      width: 30,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(0),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.5),
                                                                blurRadius: 5,
                                                                spreadRadius: 1)
                                                          ]),
                                                      child: Icon(
                                                        Icons.timer,
                                                        size: 28,
                                                        color: (_like)
                                                            ? Colors.red
                                                            : Colors.grey[600],
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
                                        margin:
                                            EdgeInsets.fromLTRB(30, 10, 0, 0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Keterangan ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.2,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 10, 30, 0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 60,
                                          child: buildTextField(
                                              MaterialCommunityIcons
                                                  .bookmark_minus_outline,
                                              "Keterangan",
                                              false,
                                              false,
                                              true,
                                              keterangan),
                                        ),
                                      ),
                                      //ini button 1
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 10, 20, 20),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 350,
                                              height: 50,
                                              child: RaisedButton(
                                                onPressed: () {
                                                  insertabsenpegawai();
                                                },
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            80.0)),
                                                padding: EdgeInsets.all(0.0),
                                                child: Ink(
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color(0xff374ABE),
                                                          Color(0xff64B6FF)
                                                        ],
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0)),
                                                  child: Container(
                                                    constraints: BoxConstraints(
                                                        maxWidth: 350.0,
                                                        minHeight: 50.0),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Submit Button",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(80, 20, 0, 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              '--- Daftar Pegawai Absen ---',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                //fontWeight: FontWeight.bold,
                                                foreground: Paint()
                                                  ..color = Colors.black
                                                  ..strokeWidth = 2.0
                                                  ..style =
                                                      PaintingStyle.stroke,
                                                letterSpacing: 1.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      DataTable(
                                        columns: [
                                          DataColumn(label: Text("Nama")),
                                          DataColumn(label: Text("tanggal")),
                                          DataColumn(label: Text("waktu")),
                                          DataColumn(label: Text("keterangan")),
                                        ],
                                        columnSpacing: 20,
                                        rows: arrabsen
                                            .map<DataRow>((element) =>
                                                DataRow(cells: [
                                                  DataCell(Text(
                                                      element.nama.toString())),
                                                  DataCell(Text(element.tanggal
                                                      .toString())),
                                                  DataCell(Text(element.waktu
                                                      .toString())),
                                                  DataCell(Text(element
                                                      .keterangan
                                                      .toString())),
                                                ]))
                                            .toList(),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 50, 10, 100),
                                      ),
                                    ],
                                  ),
                                ),
                                //ini halaman kedua
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(30, 20, 0, 0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Nama Pegawai ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.2,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 10, 20, 0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 60,
                                          child: buildTextField(
                                              MaterialCommunityIcons
                                                  .account_outline,
                                              "Nama Pegawai",
                                              false,
                                              false,
                                              true,
                                              myNama2),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(30, 0, 0, 0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Alamat ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.2,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 10, 20, 0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 60,
                                          child: buildTextField(
                                              MaterialCommunityIcons.routes,
                                              "Alamat",
                                              false,
                                              false,
                                              true,
                                              myAlamat2),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(30, 0, 0, 0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Telephone ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.2,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 10, 20, 0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 60,
                                          child: buildTextField(
                                              MaterialCommunityIcons.phone,
                                              "Telephone",
                                              false,
                                              false,
                                              true,
                                              myTelp2),
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(30, 0, 0, 0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Status Pegawai",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.2,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                      //ini Status
                                      Container(
                                        padding: const EdgeInsets.only(
                                            top: 10, left: 10),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isAktif = true;
                                                  isNonAktif = false;
                                                  status = "aktif";
                                                  print("ini status akt: " +
                                                      status);
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    margin: EdgeInsets.fromLTRB(
                                                        50, 5, 8, 10),
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            0, 0, 0, 0),
                                                    decoration: BoxDecoration(
                                                        color: isAktif
                                                            ? Warnalayer
                                                                .textColor2
                                                            : Colors
                                                                .transparent,
                                                        border: Border.all(
                                                            width: 1,
                                                            color: isAktif
                                                                ? Colors
                                                                    .transparent
                                                                : Warnalayer
                                                                    .textColor1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                    child: Icon(
                                                      MaterialCommunityIcons
                                                          .account_outline,
                                                      color: isAktif
                                                          ? Colors.white
                                                          : Warnalayer
                                                              .iconColor,
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 17, 0),
                                                      child: Text('Aktif',
                                                          style: TextStyle(
                                                              color: Warnalayer
                                                                  .textColor1))),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  isAktif = false;
                                                  isNonAktif = true;
                                                  status = "non-aktif";
                                                  print("ini status nonak: " +
                                                      status);
                                                });
                                              },
                                              child: Row(
                                                children: [
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    margin: EdgeInsets.only(
                                                        right: 8),
                                                    decoration: BoxDecoration(
                                                        color: isAktif
                                                            ? Colors.transparent
                                                            : Warnalayer
                                                                .textColor2,
                                                        border: Border.all(
                                                            width: 1,
                                                            color: isAktif
                                                                ? Warnalayer
                                                                    .textColor1
                                                                : Colors
                                                                    .transparent),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                    child: Icon(
                                                      MaterialCommunityIcons
                                                          .account_outline,
                                                      color: isAktif
                                                          ? Warnalayer.iconColor
                                                          : Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Non-Aktif",
                                                    style: TextStyle(
                                                        color: Warnalayer
                                                            .textColor1),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      //ini button 2
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 20, 20, 20),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 350,
                                              height: 50,
                                              child: RaisedButton(
                                                onPressed: () {
                                                  insertpegawai();
                                                },
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            80.0)),
                                                padding: EdgeInsets.all(0.0),
                                                child: Ink(
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color(0xff374ABE),
                                                          Color(0xff64B6FF)
                                                        ],
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0)),
                                                  child: Container(
                                                    constraints: BoxConstraints(
                                                        maxWidth: 350.0,
                                                        minHeight: 50.0),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Tambah Pegawai",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
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
                                ),
                                //ini halaman ke tiga
                                Container(
                                  child: ListView(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(40, 0, 0, 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              '--- Penambahan Kategori Pegawai ---',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                //fontWeight: FontWeight.bold,
                                                foreground: Paint()
                                                  ..color = Colors.black
                                                  ..strokeWidth = 2.0
                                                  ..style =
                                                      PaintingStyle.stroke,
                                                letterSpacing: 1.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(30, 20, 0, 0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "List Nama Pegawai ",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.2,
                                                  color: Colors.black),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(30, 0, 30, 10),
                                        width: double.infinity,
                                        child: DropdownButton<ClassDataPegawai>(
                                          hint: Text(
                                              "Pilih Pegawai Yang Akan Ditambahkan"),
                                          value: selectarrpeg1,
                                          onChanged: (ClassDataPegawai Value) {
                                            setState(() {
                                              selectarrpeg1 = Value;
                                              myAlamat3.text = Value.alamat;
                                              myNama3.text = Value.nama;
                                              //getallkategori();
                                              getallidkategori();
                                              myTelp3.text = Value.telp;
                                              idpeg = Value.id;
                                            });
                                          },
                                          items: arrdatapeg.map(
                                              (ClassDataPegawai arrdatapeg) {
                                            return DropdownMenuItem<
                                                ClassDataPegawai>(
                                              value: arrdatapeg,
                                              child: Row(
                                                children: <Widget>[
                                                  Text(
                                                    arrdatapeg.nama,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 200,
                                        height: 100,
                                        child: GridView.count(
                                            crossAxisCount: 2,
                                            padding: EdgeInsets.zero,
                                            mainAxisSpacing: 0.0,
                                            crossAxisSpacing: 0.0,
                                            childAspectRatio: 4,
                                            children: List.generate(
                                                arridkategori.length, (index) {
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: new CheckboxListTile(
                                                      value:
                                                          arridkategori[index]
                                                              .getFlagAktif(),
                                                      activeColor:
                                                          Colors.blue[600],
                                                      title: Text(
                                                        //arrkategori[index]
                                                        //.namakategori,
                                                        arridkategori[index]
                                                            .idkategori,
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                      onChanged: (bool value) {
                                                        if (value == true) {
                                                          setState(() {
                                                            arridkategori[index]
                                                                .aktif = "1";

                                                            print("arrkat : " +
                                                                arridkategori[
                                                                        index]
                                                                    .namakategori);
                                                          });
                                                        } else {
                                                          setState(() {
                                                            arridkategori[index]
                                                                .aktif = "0";
                                                            print("arrkat : " +
                                                                arridkategori[
                                                                        index]
                                                                    .namakategori);
                                                          });
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              );
                                            })),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 10, 0, 5),
                                        child: RichText(
                                          maxLines: 1,
                                          text: TextSpan(
                                            text: "Keterangan ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                15, 20, 0, 0),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: "HAIR             : ",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          RichText(
                                            maxLines: 2,
                                            text: TextSpan(
                                              text:
                                                  "Potong Rambut - Creambat - Rebounding "
                                                      .capitalizeFirstofEach1,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                15, 20, 0, 0),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: "                       ",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          RichText(
                                            maxLines: 1,
                                            text: TextSpan(
                                              text:
                                                  "                     - Coloring"
                                                      .capitalizeFirstofEach1,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                15, 20, 0, 0),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: "Nail               : ",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          RichText(
                                            maxLines: 1,
                                            text: TextSpan(
                                              text: "Menicure - Pedicure"
                                                  .capitalizeFirstofEach1,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                15, 20, 0, 0),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: "FACE             : ",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          RichText(
                                            maxLines: 1,
                                            text: TextSpan(
                                              text:
                                                  "Make Up Artist - Mask - Totok Wajah"
                                                      .capitalizeFirstofEach1,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                15, 20, 0, 0),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: "BODY CARE : ",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          RichText(
                                            maxLines: 1,
                                            text: TextSpan(
                                              text: "SPA - Totok Badan"
                                                  .capitalizeFirstofEach1,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                      //ini button 3
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 20, 20, 20),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 350,
                                              height: 50,
                                              child: RaisedButton(
                                                onPressed: () {
                                                  insertdetailpegawai();
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Berhasil Ditambahkan",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                      backgroundColor:
                                                          Colors.blue[300],
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                  getdatapegawai();
                                                  print("arrkategori : " +
                                                      arrkategori.length
                                                          .toString());
                                                },
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            80.0)),
                                                padding: EdgeInsets.all(0.0),
                                                child: Ink(
                                                  decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Color(0xff374ABE),
                                                          Color(0xff64B6FF)
                                                        ],
                                                        begin: Alignment
                                                            .centerLeft,
                                                        end: Alignment
                                                            .centerRight,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.0)),
                                                  child: Container(
                                                    constraints: BoxConstraints(
                                                        maxWidth: 350.0,
                                                        minHeight: 50.0),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Input Kategori Pegawai",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(70, 00, 0, 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              '--- Data Kategori Pegawai ---',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                //fontWeight: FontWeight.bold,
                                                foreground: Paint()
                                                  ..color = Colors.black
                                                  ..strokeWidth = 2.0
                                                  ..style =
                                                      PaintingStyle.stroke,
                                                letterSpacing: 1.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      DataTable(
                                        columns: [
                                          DataColumn(label: Text("Nama")),
                                          DataColumn(label: Text("Telphone")),
                                          DataColumn(
                                              label:
                                                  Text("Kategori / Keahlian")),
                                        ],
                                        columnSpacing: 20,
                                        rows: arrdatapeg
                                            .map<DataRow>((element) =>
                                                DataRow(cells: [
                                                  DataCell(Text(
                                                      element.nama.toString())),
                                                  DataCell(Text(
                                                      element.telp.toString())),
                                                  DataCell(Text(element
                                                              .idkategori
                                                              .isEmpty ||
                                                          element.idkategori ==
                                                              null
                                                      ? "-"
                                                      : element.idkategori
                                                              .toString() +
                                                          ",")),
                                                ]))
                                            .toList(),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 50, 10, 100),
                                      ),
                                    ],
                                  ),
                                ),
                                //ini hal empat
                                Container(
                                  child: ListView(
                                    children: <Widget>[
                                      SizedBox(
                                          height: 500,
                                          child: Scaffold(
                                              body: ListView(
                                            children: <Widget>[
                                              // Text("test")
                                              Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height -
                                                    140,
                                                child: ListView(
                                                  padding: EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 20.0,
                                                      top: 30.0),
                                                  children: <Widget>[
                                                    Card(
                                                      elevation: 10,
                                                      shadowColor: Colors.black,
                                                      //warna luar gojek
                                                      color:
                                                          Colors.lightBlue[300],
                                                      child: SizedBox(
                                                        width: 300,
                                                        height: 130,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(1.0),
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                height: 3,
                                                              ),
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          10.0),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                              "Gopaypay",
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.bold,
                                                                              ))
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 3,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          10.0),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          Text(
                                                                              "Rp 278.000",
                                                                              style: TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.bold,
                                                                              ))
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Card(
                                                                elevation: 7,
                                                                shadowColor:
                                                                    Colors
                                                                        .black,
                                                                //warna dalem gojek
                                                                color: Colors
                                                                    .blue[900],
                                                                child: SizedBox(
                                                                  width: 350,
                                                                  height: 73,
                                                                  child: Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Expanded(
                                                                        flex: 2,
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(10.0),
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              Icon(
                                                                                Icons.motorcycle_sharp,
                                                                                color: Colors.green,
                                                                                size: 30.0,
                                                                              ),
                                                                              Text("Go Ride",
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ))
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex: 2,
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(10.0),
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              Icon(
                                                                                Icons.car_repair,
                                                                                color: Colors.white,
                                                                                size: 30.0,
                                                                              ),
                                                                              Text("Go Car",
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ))
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        flex: 2,
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(10.0),
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              Icon(
                                                                                Icons.food_bank_outlined,
                                                                                color: Colors.red,
                                                                                size: 30.0,
                                                                              ),
                                                                              Text("Go Food",
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ))
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
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
                                          ))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                    child: Text(
                        "Yakin mau absen ? Jika pegawai absen maka semua jadwal booking pegawai " +
                            myNama1.text +
                            " akan tercancel",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
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
                                  cancelsemuabooking();
                                  Navigator.pop(context);
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
                                      "Iya",
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
                                  Navigator.pop(context);
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
                                      "Tidak",
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

  Widget buildTextField(IconData icon, String hintText, bool isPassword,
      bool isEmail, bool enable, TextEditingController myControll) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        obscureText: isPassword,
        controller: myControll,
        enabled: enable,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Warnalayer.iconColor,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Warnalayer.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Warnalayer.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          contentPadding: EdgeInsets.all(10),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 14, color: Warnalayer.textColor1),
        ),
      ),
    );
  }
}
