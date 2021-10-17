import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:ta_salon/ClassPilihJenjangPeruntukan.dart';
import 'main_variable.dart' as main_variable;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'ClassLayananSalon.dart';
import 'ClassBookingService.dart';
import 'package:ta_salon/warnalayer.dart';
import 'package:intl/intl.dart';
import 'ClassPilihJenjangPeruntukan.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'ClassUser.dart';
import 'ClassPegawai.dart';

import 'dart:convert';

class EditServiceSalon extends StatefulWidget {
  final int index;
  final String namaservicekirim, idservice, kodelayanan;

  EditServiceSalon(
      {Key key,
      this.index,
      @required this.namaservicekirim,
      @required this.idservice,
      @required this.kodelayanan})
      : super(key: key);

  @override
  EditServiceSalonState createState() => EditServiceSalonState(
      this.namaservicekirim, this.idservice, this.kodelayanan);
}

//ini buat proper kata / Kapitalisasi 2 kata jadi besar
extension CapExtension on String {
  String get inCaps =>
      this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
  String get capitalizeFirstofEach => this
      .replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.inCaps)
      .join(" ");
}

class EditServiceSalonState extends State<EditServiceSalon> {
  NumberFormat numberFormat = NumberFormat(',000');
  String cekpembayaran = "";
  bool _like = false;
  ClassPegawai selectarrpeg = null;
  String namaservicekirim, idservice, kotakrim, total = "0", kodelayanan;
  EditServiceSalonState(
      this.namaservicekirim, this.idservice, this.kodelayanan);
  List<ClassLayanansalon> arr = new List();
  List<ClassBookingService> arrbooking = new List();
  List<ClassPilihJenjangPeruntukan> arrjenjangperuntukan = new List();
  List<ClassPegawai> arrpegawai = new List();
  int saldo = 0;
  List<ClassUser> arrsaldo = new List();
  ClassPilihJenjangPeruntukan selectedarr = null;

  String peruntukan = "";
  String jenjang = "";
  String tgl, jam, reqmua, pembayarankirim = "";

  int _radioValue = 0;
  int _radioValue1 = 0;
  // radiovalue1 => dewasa = 0 || anak-anak = 1 || semua = 2 (JENJANGUSIA)
  // radiovalue => pria = 0    || wanita = 1    || semua = 2 (PERUNTUKAN)

  bool aktifpriadewasa = true;
  bool aktifwanitadewasa = true;
  bool aktifpriaanak = true;
  bool aktifwanitaanak = true;

  TextEditingController myNamalayanan = new TextEditingController();
  TextEditingController myJenjangusia = new TextEditingController();
  TextEditingController myHargapriadewasa = new TextEditingController();
  TextEditingController myHargapriaanak = new TextEditingController();
  TextEditingController myHargawanitadewasa = new TextEditingController();
  TextEditingController myHargawanitaanak = new TextEditingController();
  TextEditingController myDurasi = new TextEditingController();
  TextEditingController myDeskripsi = new TextEditingController();

  ClassLayanansalon datalama =
      new ClassLayanansalon("", "", "", "", "", "", "", "", "", "", "", "", "");

  void initState() {
    super.initState();
    getlayanansalondetail();
    getperuntukanjenjang();
    getpegawai_halamanmember();
    print("idsalon : " + main_variable.idsalonlogin);
    print("ini kodelayanan : " + kodelayanan);
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      if (_radioValue1 == 0 && _radioValue == 0) {
        jenjang = "dewasa";
        peruntukan = "pria";
        myHargawanitadewasa.text = "Rp. 0";
        myHargawanitaanak.text = "Rp. 0";
        myHargapriaanak.text = "Rp. 0";
        myHargapriadewasa.text = "";

        aktifpriadewasa = true;
        aktifpriaanak = false;
        aktifwanitaanak = false;
        aktifwanitadewasa = false;
      } else if (_radioValue1 == 1 && _radioValue == 0) {
        jenjang = "anak-anak";
        peruntukan = "pria";
        myHargawanitadewasa.text = "Rp. 0";
        myHargawanitaanak.text = "Rp. 0";
        myHargapriaanak.text = "";
        myHargapriadewasa.text = "Rp. 0";

        aktifpriadewasa = false;
        aktifpriaanak = true;
        aktifwanitaanak = false;
        aktifwanitadewasa = false;
      } else if (_radioValue1 == 2 && _radioValue == 0) {
        jenjang = "semua";
        peruntukan = "pria";
        myHargawanitadewasa.text = "Rp. 0";
        myHargawanitaanak.text = "Rp. 0";
        myHargapriaanak.text = "";
        myHargapriadewasa.text = "";

        aktifpriadewasa = true;
        aktifpriaanak = true;
        aktifwanitaanak = false;
        aktifwanitadewasa = false;
      } else if (_radioValue1 == 0 && _radioValue == 1) {
        jenjang = "dewasa";
        peruntukan = "wanita";
        myHargawanitadewasa.text = "";
        myHargawanitaanak.text = "Rp. 0";
        myHargapriaanak.text = "Rp. 0";
        myHargapriadewasa.text = "Rp. 0";

        aktifpriadewasa = false;
        aktifpriaanak = false;
        aktifwanitaanak = false;
        aktifwanitadewasa = true;
      } else if (_radioValue1 == 1 && _radioValue == 1) {
        jenjang = "anak-anak";
        peruntukan = "wanita";
        myHargawanitadewasa.text = "Rp. 0";
        myHargawanitaanak.text = "";
        myHargapriaanak.text = "Rp. 0";
        myHargapriadewasa.text = "Rp. 0";

        aktifpriadewasa = false;
        aktifpriaanak = false;
        aktifwanitaanak = true;
        aktifwanitadewasa = false;
      } else if (_radioValue1 == 2 && _radioValue == 1) {
        jenjang = "semua";
        peruntukan = "wanita";
        myHargawanitadewasa.text = "";
        myHargawanitaanak.text = "";
        myHargapriaanak.text = "Rp. 0";
        myHargapriadewasa.text = "Rp. 0";

        aktifpriadewasa = false;
        aktifpriaanak = false;
        aktifwanitaanak = true;
        aktifwanitadewasa = true;
      } else if (_radioValue1 == 0 && _radioValue == 2) {
        jenjang = "dewasa";
        peruntukan = "semua";
        myHargawanitadewasa.text = "";
        myHargawanitaanak.text = "Rp. 0";
        myHargapriaanak.text = "Rp. 0";
        myHargapriadewasa.text = "";

        aktifpriadewasa = true;
        aktifpriaanak = false;
        aktifwanitaanak = false;
        aktifwanitadewasa = true;
      } else if (_radioValue1 == 1 && _radioValue == 2) {
        jenjang = "anak-anak";
        peruntukan = "semua";
        myHargawanitadewasa.text = "Rp. 0";
        myHargawanitaanak.text = "";
        myHargapriaanak.text = "";
        myHargapriadewasa.text = "Rp. 0";

        aktifpriadewasa = false;
        aktifpriaanak = true;
        aktifwanitaanak = true;
        aktifwanitadewasa = false;
      } else if (_radioValue1 == 2 && _radioValue == 2) {
        jenjang = "semua";
        peruntukan = "semua";
        myHargawanitadewasa.text = "";
        myHargawanitaanak.text = "";
        myHargapriaanak.text = "";
        myHargapriadewasa.text = "";

        aktifpriadewasa = true;
        aktifpriaanak = true;
        aktifwanitaanak = true;
        aktifwanitadewasa = true;
      }
    });
  }

  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue1 = value;

      if (_radioValue1 == 0 && _radioValue == 0) {
        jenjang = "dewasa";
        peruntukan = "pria";
        myHargawanitadewasa.text = "Rp. 0";
        myHargawanitaanak.text = "Rp. 0";
        myHargapriaanak.text = "Rp. 0";
        myHargapriadewasa.text = "";

        aktifpriadewasa = true;
        aktifpriaanak = false;
        aktifwanitaanak = false;
        aktifwanitadewasa = false;
      } else if (_radioValue1 == 1 && _radioValue == 0) {
        jenjang = "anak-anak";
        peruntukan = "pria";
        myHargawanitadewasa.text = "Rp. 0";
        myHargawanitaanak.text = "Rp. 0";
        myHargapriaanak.text = "";
        myHargapriadewasa.text = "Rp. 0";

        aktifpriadewasa = false;
        aktifpriaanak = true;
        aktifwanitaanak = false;
        aktifwanitadewasa = false;
      } else if (_radioValue1 == 2 && _radioValue == 0) {
        jenjang = "semua";
        peruntukan = "pria";
        myHargawanitadewasa.text = "Rp. 0";
        myHargawanitaanak.text = "Rp. 0";
        myHargapriaanak.text = "";
        myHargapriadewasa.text = "";

        aktifpriadewasa = true;
        aktifpriaanak = true;
        aktifwanitaanak = false;
        aktifwanitadewasa = false;
      } else if (_radioValue1 == 0 && _radioValue == 1) {
        jenjang = "dewasa";
        peruntukan = "wanita";
        myHargawanitadewasa.text = "";
        myHargawanitaanak.text = "Rp. 0";
        myHargapriaanak.text = "Rp. 0";
        myHargapriadewasa.text = "Rp. 0";

        aktifpriadewasa = false;
        aktifpriaanak = false;
        aktifwanitaanak = false;
        aktifwanitadewasa = true;
      } else if (_radioValue1 == 1 && _radioValue == 1) {
        jenjang = "anak-anak";
        peruntukan = "wanita";
        myHargawanitadewasa.text = "Rp. 0";
        myHargawanitaanak.text = "";
        myHargapriaanak.text = "Rp. 0";
        myHargapriadewasa.text = "Rp. 0";

        aktifpriadewasa = false;
        aktifpriaanak = false;
        aktifwanitaanak = true;
        aktifwanitadewasa = false;
      } else if (_radioValue1 == 2 && _radioValue == 1) {
        jenjang = "semua";
        peruntukan = "wanita";
        myHargawanitadewasa.text = "";
        myHargawanitaanak.text = "";
        myHargapriaanak.text = "Rp. 0";
        myHargapriadewasa.text = "Rp. 0";

        aktifpriadewasa = false;
        aktifpriaanak = false;
        aktifwanitaanak = true;
        aktifwanitadewasa = true;
      } else if (_radioValue1 == 0 && _radioValue == 2) {
        jenjang = "dewasa";
        peruntukan = "semua";
        myHargawanitadewasa.text = "";
        myHargawanitaanak.text = "Rp. 0";
        myHargapriaanak.text = "Rp. 0";
        myHargapriadewasa.text = "";

        aktifpriadewasa = true;
        aktifpriaanak = false;
        aktifwanitaanak = false;
        aktifwanitadewasa = true;
      } else if (_radioValue1 == 1 && _radioValue == 2) {
        jenjang = "anak-anak";
        peruntukan = "semua";
        myHargawanitadewasa.text = "Rp. 0";
        myHargawanitaanak.text = "";
        myHargapriaanak.text = "";
        myHargapriadewasa.text = "Rp. 0";

        aktifpriadewasa = false;
        aktifpriaanak = true;
        aktifwanitaanak = true;
        aktifwanitadewasa = false;
      } else if (_radioValue1 == 2 && _radioValue == 2) {
        jenjang = "semua";
        peruntukan = "semua";
        myHargawanitadewasa.text = "";
        myHargawanitaanak.text = "";
        myHargapriaanak.text = "";
        myHargapriadewasa.text = "";

        aktifpriadewasa = true;
        aktifpriaanak = true;
        aktifwanitaanak = true;
        aktifwanitadewasa = true;
      }
    });
  }

  Future<ClassLayanansalon> getlayanansalondetail() async {
    Map paramData = {
      'username': main_variable.usernamesalon,
      'namalayanan': namaservicekirim.toString(),
    };
    var parameter = json.encode(paramData);
    this.arr.clear();
    http
        .post(main_variable.ipnumber + "/getlayanansalondetail",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];
      print(res.body);
      print(data.length);

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
        this.arr.add(databaru);
      }

      setState(() {
        this.arr = arr;
        // radiovalue => pria = 0    || wanita = 1    || semua = 2
        // radiovalue1 => dewasa = 0 || anak-anak = 1 || semua = 2
        if (arr[0].peruntukan == "wanita" && arr[0].jenjangusia == "semua") {
          _radioValue = 1;
          _radioValue1 = 2;
          myHargapriaanak.text = "Rp. 0";
          myHargapriadewasa.text = "Rp. 0";
        } else if (arr[0].peruntukan == "pria" &&
            arr[0].jenjangusia == "semua") {
          _radioValue = 0;
          _radioValue1 = 2;
        } else if (arr[0].peruntukan == "wanita" &&
            arr[0].jenjangusia == "dewasa") {
          _radioValue = 1;
          _radioValue1 = 0;
        } else if (arr[0].peruntukan == "pria" &&
            arr[0].jenjangusia == "dewasa") {
          _radioValue = 0;
          _radioValue1 = 0;
        } else if (arr[0].peruntukan == "pria" &&
            arr[0].jenjangusia == "anak-anak") {
          _radioValue = 0;
          _radioValue1 = 1;
        } else if (arr[0].peruntukan == "wanita" &&
            arr[0].jenjangusia == "anak-anak") {
          _radioValue = 1;
          _radioValue1 = 1;
        } else if (arr[0].peruntukan == "semua" &&
            arr[0].jenjangusia == "anak-anak") {
          _radioValue = 2;
          _radioValue1 = 1;
        } else if (arr[0].peruntukan == "semua" &&
            arr[0].jenjangusia == "semua") {
          _radioValue = 2;
          _radioValue1 = 2;
        } else if (arr[0].peruntukan == "semua" &&
            arr[0].jenjangusia == "dewasa") {
          _radioValue = 2;
          _radioValue1 = 0;
        }
        // 00 V
        // 01 V
        // 02 V
        // 10 V
        // 11 V
        // 12 V
        // 20 V
        // 21 V
        // 22 V
      });
      print("nangka");

      return arr;
    }).catchError((err) {
      print(err);
    });
  }

  Future<ClassPilihJenjangPeruntukan> getperuntukanjenjang() async {
    Map paramData = {
      'username': main_variable.usernamesalon,
      'namalayanan': namaservicekirim.toString(),
    };
    var parameter = json.encode(paramData);
    this.arr.clear();
    http
        .post(main_variable.ipnumber + "/getlayanansalondetail",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];
      print(res.body);
      print(data.length);

      for (int i = 0; i < data.length; i++) {
        if (data[i]['hargawanitadewasa'].toString() != "0") {
          ClassPilihJenjangPeruntukan databaru =
              new ClassPilihJenjangPeruntukan(
                  "Wanita", "Dewasa", data[i]['hargawanitadewasa'].toString());
          this.arrjenjangperuntukan.add(databaru);
        }
        if (data[i]['hargapriadewasa'].toString() != "0") {
          ClassPilihJenjangPeruntukan databaru =
              new ClassPilihJenjangPeruntukan(
                  "Pria", "Dewasa", data[i]['hargapriadewasa'].toString());
          this.arrjenjangperuntukan.add(databaru);
        }
        if (data[i]['hargawanitaanak'].toString() != "0") {
          ClassPilihJenjangPeruntukan databaru =
              new ClassPilihJenjangPeruntukan(
                  "Anak", "Perempuan", data[i]['hargawanitaanak'].toString());
          this.arrjenjangperuntukan.add(databaru);
        }
        if (data[i]['hargapriaanak'].toString() != "0") {
          ClassPilihJenjangPeruntukan databaru =
              new ClassPilihJenjangPeruntukan(
                  "Anak", "Laki-Laki", data[i]['hargapriaanak'].toString());
          this.arrjenjangperuntukan.add(databaru);
        }
      }

      setState(() {
        this.arrjenjangperuntukan = arrjenjangperuntukan;
      });
      print("aple");

      return arrjenjangperuntukan;
    }).catchError((err) {
      print(err);
    });
  }

  Future<ClassBookingService> insertbookingservice() async {
    Map paramData = {
      // 'username': main_variable.userlogin,
      // 'idservice': idservice.toString(),
      // 'namauser': myNamauser.text,
      // 'usernamesalon': main_variable.usernamesalon,
      // 'tanggalbooking': myTgl.text,
      // 'jambooking': myTime.text,
      // 'total': total,
      // 'requestpegawai': myMua.text,
      // 'pembayaran': pembayarankirim,
    };
    var parameter = json.encode(paramData);

    ClassBookingService databaru = new ClassBookingService(
        "id",
        "tanggal",
        "username",
        "namauser",
        "usernamesalon",
        "idservice",
        "tanggalbooking",
        "jambooking",
        "requestpegawai",
        "total",
        "usernamecancel",
        "status",
        "pembayaran");

    http
        .post(main_variable.ipnumber + "/insertbookingservice",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body.substring(100));
      var data = json.decode(res.body);
      data = data[0]['status'];

      if (data == "sukses") {
        Fluttertoast.showToast(msg: "Berhasil Booking");
      } else {
        Fluttertoast.showToast(msg: "Gagal Booking, Jadwal tidak tersedia");
      }

      return data;
    }).catchError((err) {
      print(err);
    });
  }

  Future<ClassPegawai> getpegawai_halamanmember() async {
    Map paramData = {
      'idsalon': main_variable.idsalonlogin,
      'kodelayanan': kodelayanan,
    };
    var parameter = json.encode(paramData);
    this.arr.clear();
    http
        .post(main_variable.ipnumber + "/getpegawai_halamanmember",
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
                            fit: BoxFit.fill)),
                    child: Container(),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text("Yakin mau hapus service ?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                        )),
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 20, 10, 0),
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
                                  // status = "tutup";
                                  // if (arrsalon[0].status == status) {
                                  //   print("a");
                                  //   print("perbanidngan = " +
                                  //       arrsalon[0].status +
                                  //       " : " +
                                  //       status);
                                  //   Fluttertoast.showToast(
                                  //       msg:
                                  //           "Gagal Menutup Salon, Karena Salon Anda Sudah Tutup",
                                  //       toastLength: Toast.LENGTH_LONG,
                                  //       gravity: ToastGravity.CENTER,
                                  //       backgroundColor: Colors.red[300],
                                  //       textColor: Colors.white,
                                  //       fontSize: 16.0);
                                  //   Navigator.pop(context);
                                  // } else {
                                  //   print("b");
                                  //   print("perbanidngan = " +
                                  //       arrsalon[0].status +
                                  //       " : " +
                                  //       status);
                                  //   statussalon();
                                  //   if (status == "aktif") {
                                  //     Fluttertoast.showToast(
                                  //         msg: "Berhasil Membuka Salon",
                                  //         toastLength: Toast.LENGTH_LONG,
                                  //         gravity: ToastGravity.CENTER,
                                  //         backgroundColor: Colors.blue[300],
                                  //         textColor: Colors.white,
                                  //         fontSize: 16.0);
                                  //   } else {
                                  //     Fluttertoast.showToast(
                                  //         msg: "Berhasil Menutup Salon",
                                  //         toastLength: Toast.LENGTH_LONG,
                                  //         gravity: ToastGravity.CENTER,
                                  //         backgroundColor: Colors.blue[300],
                                  //         textColor: Colors.white,
                                  //         fontSize: 16.0);
                                  //   }
                                  //   status = "";
                                  //   Navigator.pop(context);
                                  // }

                                  print("Tidak");
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
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 20, 10, 0),
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
                                  // status = "aktif";
                                  // if (arrsalon[0].status == status) {
                                  //   print("c");
                                  //   print("perbanidngan = " +
                                  //       arrsalon[0].status +
                                  //       " : " +
                                  //       status);
                                  //   Fluttertoast.showToast(
                                  //       msg:
                                  //           "Gagal Membuka Salon, Karena Salon Anda Sudah Buka",
                                  //       toastLength: Toast.LENGTH_LONG,
                                  //       gravity: ToastGravity.CENTER,
                                  //       backgroundColor: Colors.red[300],
                                  //       textColor: Colors.white,
                                  //       fontSize: 16.0);
                                  //   Navigator.pop(context);
                                  // } else {
                                  //   print("perbanidngan = " +
                                  //       arrsalon[0].status +
                                  //       " : " +
                                  //       status);
                                  //   print("d");
                                  //   statussalon();
                                  //   if (status == "aktif") {
                                  //     Fluttertoast.showToast(
                                  //         msg: "Berhasil Membuka Salon",
                                  //         toastLength: Toast.LENGTH_LONG,
                                  //         gravity: ToastGravity.CENTER,
                                  //         backgroundColor: Colors.blue[300],
                                  //         textColor: Colors.white,
                                  //         fontSize: 16.0);
                                  //   } else {
                                  //     Fluttertoast.showToast(
                                  //         msg: "Berhasil Menutup Salon",
                                  //         toastLength: Toast.LENGTH_LONG,
                                  //         gravity: ToastGravity.CENTER,
                                  //         backgroundColor: Colors.blue[300],
                                  //         textColor: Colors.white,
                                  //         fontSize: 16.0);
                                  //   }
                                  //   status = "";
                                  //   Navigator.pop(context);
                                  // }
                                  print("Hapus");
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
                                      "Hapus",
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: width,
          child: Stack(
            children: <Widget>[
              Container(
                height: height * 0.45,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/background.png"),
                        fit: BoxFit.cover)),
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.black.withOpacity(0.9),
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.9),
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                ),
              ),
              Container(
                width: width,
                margin: EdgeInsets.only(top: height * 0.3),
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              "Nama Layanan  : ",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                  color: Colors.black),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                              width: 300,
                              height: 60,
                              child: buildTextField(
                                  arr[0].namalayanan.capitalizeFirstofEach,
                                  false,
                                  false,
                                  true,
                                  myNamalayanan),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Deskripsi           : ",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                  color: Colors.black),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Expanded(
                              flex: 1,
                              child: SizedBox(
                                width: 180,
                                height: 100,
                                child: buildTextField1(arr[0].deskripsi, false,
                                    false, true, myDeskripsi),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Peruntukan        : ",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                  color: Colors.black),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 25,
                                  child: Row(
                                    children: [
                                      new Radio(
                                        value: 0,
                                        groupValue: _radioValue,
                                        onChanged: _handleRadioValueChange,
                                      ),
                                      new Text(
                                        'PRIA',
                                        style: new TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                  child: Row(
                                    children: [
                                      new Radio(
                                        value: 1,
                                        groupValue: _radioValue,
                                        onChanged: _handleRadioValueChange,
                                      ),
                                      new Text(
                                        'WANITA',
                                        style: new TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                  child: Row(
                                    children: [
                                      new Radio(
                                        value: 2,
                                        groupValue: _radioValue,
                                        onChanged: _handleRadioValueChange,
                                      ),
                                      new Text(
                                        'SEMUA',
                                        style: new TextStyle(
                                          fontSize: 16.0,
                                        ),
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
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Jenjang              : ",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                  color: Colors.black),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 25,
                                  child: Row(
                                    children: [
                                      new Radio(
                                        value: 0,
                                        groupValue: _radioValue1,
                                        onChanged: _handleRadioValueChange1,
                                      ),
                                      new Text(
                                        'DEWASA',
                                        style: new TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                  child: Row(
                                    children: [
                                      new Radio(
                                        value: 1,
                                        groupValue: _radioValue1,
                                        onChanged: _handleRadioValueChange1,
                                      ),
                                      new Text(
                                        'ANAK-ANAK',
                                        style: new TextStyle(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 25,
                                  child: Row(
                                    children: [
                                      new Radio(
                                        value: 2,
                                        groupValue: _radioValue1,
                                        onChanged: _handleRadioValueChange1,
                                      ),
                                      new Text(
                                        'SEMUA',
                                        style: new TextStyle(
                                          fontSize: 16.0,
                                        ),
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
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              "Durasi Layanan   : ",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                  color: Colors.black),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                              width: 300,
                              height: 60,
                              child: buildTextField(arr[0].durasi + " Menit",
                                  false, false, true, myDurasi),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              "Harga                   ",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //ini if 1 (simple if)
                          arr[0].peruntukan == "wanita" &&
                                  arr[0].jenjangusia == "dewasa"
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      left: 0, right: 0, top: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            child: Text(
                                              "Pria Dewasa        : ",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.2,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: SizedBox(
                                              width: 300,
                                              height: 60,
                                              child: buildTextField(
                                                  "Rp. " +
                                                      numberFormat.format(
                                                          int.parse(arr[0]
                                                              .hargapriadewasa)),
                                                  false,
                                                  false,
                                                  aktifpriadewasa,
                                                  myHargapriadewasa),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            child: Text(
                                              "Wanita Dewasa    : ",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.2,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: SizedBox(
                                              width: 300,
                                              height: 60,
                                              child: buildTextField(
                                                  "Rp. " +
                                                      numberFormat.format(
                                                          int.parse(arr[0]
                                                              .harganwanitadewasa)),
                                                  false,
                                                  false,
                                                  aktifwanitadewasa,
                                                  myHargawanitadewasa),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            child: Text(
                                              "Anak Perempuan : ",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.2,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: SizedBox(
                                              width: 300,
                                              height: 60,
                                              child: buildTextField(
                                                  "Rp. " +
                                                      numberFormat.format(
                                                          int.parse(arr[0]
                                                              .hargawanitaanak)),
                                                  false,
                                                  false,
                                                  aktifwanitaanak,
                                                  myHargawanitaanak),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            child: Text(
                                              "Anak Laki-Laki     : ",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 1.2,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: SizedBox(
                                              width: 300,
                                              height: 60,
                                              child: buildTextField(
                                                  "Rp. " +
                                                      numberFormat.format(
                                                          int.parse(arr[0]
                                                              .hargapriaanak)),
                                                  false,
                                                  false,
                                                  aktifpriaanak,
                                                  myHargapriaanak),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              //ini else if 1 untuk wanita
                              : arr[0].peruntukan == "wanita" &&
                                      arr[0].jenjangusia == "anak-anak"
                                  ? Padding(
                                      padding: EdgeInsets.only(
                                          left: 0, right: 0, top: 5),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                child: Text(
                                                  "Pria Dewasa        : ",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 1.2,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 1,
                                                child: SizedBox(
                                                  width: 300,
                                                  height: 60,
                                                  child: buildTextField(
                                                      "Rp. " +
                                                          numberFormat.format(
                                                              int.parse(arr[0]
                                                                  .hargapriadewasa)),
                                                      false,
                                                      false,
                                                      aktifpriadewasa,
                                                      myHargapriadewasa),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                child: Text(
                                                  "Wanita Dewasa    : ",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 1.2,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 1,
                                                child: SizedBox(
                                                  width: 300,
                                                  height: 60,
                                                  child: buildTextField(
                                                      "Rp. " +
                                                          numberFormat.format(
                                                              int.parse(arr[0]
                                                                  .harganwanitadewasa)),
                                                      false,
                                                      false,
                                                      aktifwanitadewasa,
                                                      myHargawanitadewasa),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                child: Text(
                                                  "Anak Perempuan : ",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 1.2,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 1,
                                                child: SizedBox(
                                                  width: 300,
                                                  height: 60,
                                                  child: buildTextField(
                                                      "Rp. " +
                                                          numberFormat.format(
                                                              int.parse(arr[0]
                                                                  .hargawanitaanak)),
                                                      false,
                                                      false,
                                                      aktifwanitaanak,
                                                      myHargawanitaanak),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                child: Text(
                                                  "Anak Laki-Laki     : ",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 1.2,
                                                      color: Colors.black),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 1,
                                                child: SizedBox(
                                                  width: 300,
                                                  height: 60,
                                                  child: buildTextField(
                                                      "Rp. " +
                                                          numberFormat.format(
                                                              int.parse(arr[0]
                                                                  .hargapriaanak)),
                                                      false,
                                                      false,
                                                      aktifpriaanak,
                                                      myHargapriaanak),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ////ini else if 2 untuk pria dewasa
                                  : arr[0].peruntukan == "pria" &&
                                          arr[0].jenjangusia == "dewasa"
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                              left: 0, right: 0, top: 5),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      "Pria Dewasa        : ",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 1.2,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    flex: 1,
                                                    child: SizedBox(
                                                      width: 300,
                                                      height: 60,
                                                      child: buildTextField(
                                                          "Rp. " +
                                                              numberFormat.format(
                                                                  int.parse(arr[
                                                                          0]
                                                                      .hargapriadewasa)),
                                                          false,
                                                          false,
                                                          aktifpriadewasa,
                                                          myHargapriadewasa),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      "Wanita Dewasa    : ",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 1.2,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    flex: 1,
                                                    child: SizedBox(
                                                      width: 300,
                                                      height: 60,
                                                      child: buildTextField(
                                                          "Rp. " +
                                                              numberFormat.format(
                                                                  int.parse(arr[
                                                                          0]
                                                                      .harganwanitadewasa)),
                                                          false,
                                                          false,
                                                          aktifwanitadewasa,
                                                          myHargawanitadewasa),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      "Anak Perempuan : ",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 1.2,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    flex: 1,
                                                    child: SizedBox(
                                                      width: 300,
                                                      height: 60,
                                                      child: buildTextField(
                                                          "Rp. " +
                                                              numberFormat.format(
                                                                  int.parse(arr[
                                                                          0]
                                                                      .hargawanitaanak)),
                                                          false,
                                                          false,
                                                          aktifwanitaanak,
                                                          myHargawanitaanak),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      "Anak Laki-Laki     : ",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          letterSpacing: 1.2,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    flex: 1,
                                                    child: SizedBox(
                                                      width: 300,
                                                      height: 60,
                                                      child: buildTextField(
                                                          "Rp. " +
                                                              numberFormat.format(
                                                                  int.parse(arr[
                                                                          0]
                                                                      .hargapriaanak)),
                                                          false,
                                                          false,
                                                          aktifpriaanak,
                                                          myHargapriaanak),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ////ini else if 3 untuk pria anak
                                      : arr[0].peruntukan == "pria" &&
                                              arr[0].jenjangusia == "anak-anak"
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                  left: 0, right: 0, top: 5),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        child: Text(
                                                          "Pria Dewasa        : ",
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              letterSpacing:
                                                                  1.2,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        flex: 1,
                                                        child: SizedBox(
                                                          width: 300,
                                                          height: 60,
                                                          child: buildTextField(
                                                              "Rp. " +
                                                                  numberFormat.format(
                                                                      int.parse(
                                                                          arr[0]
                                                                              .hargapriadewasa)),
                                                              false,
                                                              false,
                                                              aktifpriadewasa,
                                                              myHargapriadewasa),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        child: Text(
                                                          "Wanita Dewasa    : ",
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              letterSpacing:
                                                                  1.2,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        flex: 1,
                                                        child: SizedBox(
                                                          width: 300,
                                                          height: 60,
                                                          child: buildTextField(
                                                              "Rp. " +
                                                                  numberFormat.format(
                                                                      int.parse(
                                                                          arr[0]
                                                                              .harganwanitadewasa)),
                                                              false,
                                                              false,
                                                              aktifwanitadewasa,
                                                              myHargawanitadewasa),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        child: Text(
                                                          "Anak Perempuan : ",
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              letterSpacing:
                                                                  1.2,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        flex: 1,
                                                        child: SizedBox(
                                                          width: 300,
                                                          height: 60,
                                                          child: buildTextField(
                                                              "Rp. " +
                                                                  numberFormat.format(
                                                                      int.parse(
                                                                          arr[0]
                                                                              .hargawanitaanak)),
                                                              false,
                                                              false,
                                                              aktifwanitaanak,
                                                              myHargawanitaanak),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        child: Text(
                                                          "Anak Laki-Laki     : ",
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              letterSpacing:
                                                                  1.2,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        flex: 1,
                                                        child: SizedBox(
                                                          width: 300,
                                                          height: 60,
                                                          child: buildTextField(
                                                              "Rp. " +
                                                                  numberFormat.format(
                                                                      int.parse(
                                                                          arr[0]
                                                                              .hargapriaanak)),
                                                              false,
                                                              false,
                                                              aktifpriaanak,
                                                              myHargapriaanak),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ////ini else if 4 untuk semua tapi wanita
                                          : arr[0].peruntukan == "wanita" &&
                                                  arr[0].jenjangusia == "semua"
                                              ? Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 0,
                                                      right: 0,
                                                      top: 5),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                              "Pria Dewasa        : ",
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      1.2,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            flex: 1,
                                                            child: SizedBox(
                                                              width: 300,
                                                              height: 60,
                                                              child: buildTextField(
                                                                  "Rp. " +
                                                                      numberFormat
                                                                          .format(
                                                                              int.parse(arr[0].hargapriadewasa)),
                                                                  false,
                                                                  false,
                                                                  aktifpriadewasa,
                                                                  myHargapriadewasa),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                              "Wanita Dewasa    : ",
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      1.2,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            flex: 1,
                                                            child: SizedBox(
                                                              width: 300,
                                                              height: 60,
                                                              child: buildTextField(
                                                                  "Rp. " +
                                                                      numberFormat
                                                                          .format(
                                                                              int.parse(arr[0].harganwanitadewasa)),
                                                                  false,
                                                                  false,
                                                                  aktifwanitadewasa,
                                                                  myHargawanitadewasa),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                              "Anak Perempuan : ",
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      1.2,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            flex: 1,
                                                            child: SizedBox(
                                                              width: 300,
                                                              height: 60,
                                                              child: buildTextField(
                                                                  "Rp. " +
                                                                      numberFormat
                                                                          .format(
                                                                              int.parse(arr[0].hargawanitaanak)),
                                                                  false,
                                                                  false,
                                                                  aktifwanitaanak,
                                                                  myHargawanitaanak),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            child: Text(
                                                              "Anak Laki-Laki     : ",
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  letterSpacing:
                                                                      1.2,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          Flexible(
                                                            flex: 1,
                                                            child: SizedBox(
                                                              width: 300,
                                                              height: 60,
                                                              child: buildTextField(
                                                                  "Rp. " +
                                                                      numberFormat
                                                                          .format(
                                                                              int.parse(arr[0].hargapriaanak)),
                                                                  false,
                                                                  false,
                                                                  aktifpriaanak,
                                                                  myHargapriaanak),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ////ini else if 5 untuk semua tapi pria
                                              : arr[0].peruntukan == "pria" &&
                                                      arr[0].jenjangusia ==
                                                          "semua"
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 0,
                                                          right: 0,
                                                          top: 5),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Container(
                                                                child: Text(
                                                                  "Pria Dewasa        : ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      letterSpacing:
                                                                          1.2,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                              Flexible(
                                                                flex: 1,
                                                                child: SizedBox(
                                                                  width: 300,
                                                                  height: 60,
                                                                  child: buildTextField(
                                                                      "Rp. " +
                                                                          numberFormat
                                                                              .format(int.parse(arr[0].hargapriadewasa)),
                                                                      false,
                                                                      false,
                                                                      aktifpriadewasa,
                                                                      myHargapriadewasa),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                child: Text(
                                                                  "Wanita Dewasa    : ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      letterSpacing:
                                                                          1.2,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                              Flexible(
                                                                flex: 1,
                                                                child: SizedBox(
                                                                  width: 300,
                                                                  height: 60,
                                                                  child: buildTextField(
                                                                      "Rp. " +
                                                                          numberFormat
                                                                              .format(int.parse(arr[0].harganwanitadewasa)),
                                                                      false,
                                                                      false,
                                                                      aktifwanitadewasa,
                                                                      myHargawanitadewasa),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                child: Text(
                                                                  "Anak Perempuan : ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      letterSpacing:
                                                                          1.2,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                              Flexible(
                                                                flex: 1,
                                                                child: SizedBox(
                                                                  width: 300,
                                                                  height: 60,
                                                                  child: buildTextField(
                                                                      "Rp. " +
                                                                          numberFormat
                                                                              .format(int.parse(arr[0].hargawanitaanak)),
                                                                      false,
                                                                      false,
                                                                      aktifwanitaanak,
                                                                      myHargawanitaanak),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                child: Text(
                                                                  "Anak Laki-Laki     : ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      letterSpacing:
                                                                          1.2,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                              Flexible(
                                                                flex: 1,
                                                                child: SizedBox(
                                                                  width: 300,
                                                                  height: 60,
                                                                  child: buildTextField(
                                                                      "Rp. " +
                                                                          numberFormat
                                                                              .format(int.parse(arr[0].hargapriaanak)),
                                                                      false,
                                                                      false,
                                                                      aktifpriaanak,
                                                                      myHargapriaanak),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ////ini else if 6 untuk semua tapi anak-anak
                                                  : arr[0].peruntukan ==
                                                              "semua" &&
                                                          arr[0].jenjangusia ==
                                                              "anak-anak"
                                                      ? Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 0,
                                                                  right: 0,
                                                                  top: 5),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    child: Text(
                                                                      "Pria Dewasa        : ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          letterSpacing:
                                                                              1.2,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                  Flexible(
                                                                    flex: 1,
                                                                    child:
                                                                        SizedBox(
                                                                      width:
                                                                          300,
                                                                      height:
                                                                          60,
                                                                      child: buildTextField(
                                                                          "Rp. " +
                                                                              numberFormat.format(int.parse(arr[0].hargapriadewasa)),
                                                                          false,
                                                                          false,
                                                                          aktifpriadewasa,
                                                                          myHargapriadewasa),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    child: Text(
                                                                      "Wanita Dewasa    : ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          letterSpacing:
                                                                              1.2,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                  Flexible(
                                                                    flex: 1,
                                                                    child:
                                                                        SizedBox(
                                                                      width:
                                                                          300,
                                                                      height:
                                                                          60,
                                                                      child: buildTextField(
                                                                          "Rp. " +
                                                                              numberFormat.format(int.parse(arr[0].harganwanitadewasa)),
                                                                          false,
                                                                          false,
                                                                          aktifwanitadewasa,
                                                                          myHargawanitadewasa),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    child: Text(
                                                                      "Anak Perempuan : ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          letterSpacing:
                                                                              1.2,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                  Flexible(
                                                                    flex: 1,
                                                                    child:
                                                                        SizedBox(
                                                                      width:
                                                                          300,
                                                                      height:
                                                                          60,
                                                                      child: buildTextField(
                                                                          "Rp. " +
                                                                              numberFormat.format(int.parse(arr[0].hargawanitaanak)),
                                                                          false,
                                                                          false,
                                                                          aktifwanitaanak,
                                                                          myHargawanitaanak),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    child: Text(
                                                                      "Anak Laki-Laki     : ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          letterSpacing:
                                                                              1.2,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                  Flexible(
                                                                    flex: 1,
                                                                    child:
                                                                        SizedBox(
                                                                      width:
                                                                          300,
                                                                      height:
                                                                          60,
                                                                      child: buildTextField(
                                                                          "Rp. " +
                                                                              numberFormat.format(int.parse(arr[0].hargapriaanak)),
                                                                          false,
                                                                          false,
                                                                          aktifpriaanak,
                                                                          myHargapriaanak),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ////ini else if 5 untuk semua tapi pria
                                                      : arr[0].peruntukan ==
                                                                  "pria" &&
                                                              arr[0].jenjangusia ==
                                                                  "semua"
                                                          ? Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 0,
                                                                      right: 0,
                                                                      top: 5),
                                                              child: Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          "Pria Dewasa        : ",
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.bold,
                                                                              letterSpacing: 1.2,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Flexible(
                                                                        flex: 1,
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              300,
                                                                          height:
                                                                              60,
                                                                          child: buildTextField(
                                                                              "Rp. " + numberFormat.format(int.parse(arr[0].hargapriadewasa)),
                                                                              false,
                                                                              false,
                                                                              aktifpriadewasa,
                                                                              myHargawanitadewasa),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          "Wanita Dewasa    : ",
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.bold,
                                                                              letterSpacing: 1.2,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Flexible(
                                                                        flex: 1,
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              300,
                                                                          height:
                                                                              60,
                                                                          child: buildTextField(
                                                                              "Rp. " + numberFormat.format(int.parse(arr[0].harganwanitadewasa)),
                                                                              false,
                                                                              false,
                                                                              aktifwanitadewasa,
                                                                              myHargawanitadewasa),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          "Anak Perempuan : ",
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.bold,
                                                                              letterSpacing: 1.2,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Flexible(
                                                                        flex: 1,
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              300,
                                                                          height:
                                                                              60,
                                                                          child: buildTextField(
                                                                              "Rp. " + numberFormat.format(int.parse(arr[0].hargawanitaanak)),
                                                                              false,
                                                                              false,
                                                                              aktifwanitaanak,
                                                                              myHargawanitadewasa),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        child:
                                                                            Text(
                                                                          "Anak Laki-Laki     : ",
                                                                          style: TextStyle(
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.bold,
                                                                              letterSpacing: 1.2,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      Flexible(
                                                                        flex: 1,
                                                                        child:
                                                                            SizedBox(
                                                                          width:
                                                                              300,
                                                                          height:
                                                                              60,
                                                                          child: buildTextField(
                                                                              "Rp. " + numberFormat.format(int.parse(arr[0].hargapriaanak)),
                                                                              false,
                                                                              false,
                                                                              aktifpriaanak,
                                                                              myHargawanitadewasa),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          //ini else untuk cetak semua semua
                                                          : Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 0,
                                                                      right: 0,
                                                                      top: 5),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                            child:
                                                                                Text(
                                                                              "Pria Dewasa        : ",
                                                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                          Flexible(
                                                                            flex:
                                                                                1,
                                                                            child:
                                                                                SizedBox(
                                                                              width: 300,
                                                                              height: 60,
                                                                              child: buildTextField("Rp. " + numberFormat.format(int.parse(arr[0].hargapriadewasa)), false, false, aktifpriadewasa, myHargawanitadewasa),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                            child:
                                                                                Text(
                                                                              "Wanita Dewasa    : ",
                                                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                          Flexible(
                                                                            flex:
                                                                                1,
                                                                            child:
                                                                                SizedBox(
                                                                              width: 300,
                                                                              height: 60,
                                                                              child: buildTextField("Rp. " + numberFormat.format(int.parse(arr[0].harganwanitadewasa)), false, false, aktifwanitadewasa, myHargawanitadewasa),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                            child:
                                                                                Text(
                                                                              "Anak Perempuan : ",
                                                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                          Flexible(
                                                                            flex:
                                                                                1,
                                                                            child:
                                                                                SizedBox(
                                                                              width: 300,
                                                                              height: 60,
                                                                              child: buildTextField("Rp. " + numberFormat.format(int.parse(arr[0].hargawanitaanak)), false, false, aktifwanitaanak, myHargawanitadewasa),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                            child:
                                                                                Text(
                                                                              "Anak Laki-Laki     : ",
                                                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                          Flexible(
                                                                            flex:
                                                                                1,
                                                                            child:
                                                                                SizedBox(
                                                                              width: 300,
                                                                              height: 60,
                                                                              child: buildTextField("Rp. " + numberFormat.format(int.parse(arr[0].hargapriaanak)), false, false, aktifpriaanak, myHargawanitadewasa),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Row(
                        children: [
                          RaisedButton(
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             DetailServiceSalon_salon(
                              //                 namaservicekirim:
                              //                     arr[index].namalayanan,
                              //                 idservice: arr[index].id,
                              //                 kodelayanan:
                              //                     arr[index].kategori)));
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
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
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: 150.0, minHeight: 45.0),
                                alignment: Alignment.center,
                                child: Text(
                                  "Update Service Salon",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          RaisedButton(
                            onPressed: () {
                              showDialogFunc();
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
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
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: 150.0, minHeight: 45.0),
                                alignment: Alignment.center,
                                child: Text(
                                  "Hapus Service Salon",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    letterSpacing: 1.0,
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
              //panah balik
              Positioned(
                left: 30,
                top: height * 0.05,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String hintText, bool isPassword, bool isEmail,
      bool enable, TextEditingController myControll) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        obscureText: isPassword,
        controller: myControll,
        enabled: enable,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Warnalayer.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Warnalayer.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          contentPadding: EdgeInsets.all(10),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget buildTextField1(String hintText, bool isPassword, bool isEmail,
      bool enable, TextEditingController myControll) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.left,
        obscureText: isPassword,
        controller: myControll,
        enabled: enable,
        maxLines: 8,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Warnalayer.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Warnalayer.textColor1),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          contentPadding: EdgeInsets.all(10),
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
