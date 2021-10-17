import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:ta_salon/DashboardSalon.dart';
import 'main_variable.dart' as main_variable;
import 'dart:async';
import 'package:ta_salon/ClassUser.dart';
import 'package:ta_salon/ClassSalon.dart';
import 'package:ta_salon/ClassLayanansalon.dart';
import 'ClassLayanansalon.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'ClassKategori.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'package:flutter/src/material/dropdown.dart';
//import 'package:getflutter/components/rating/gf_rating.dart';

class TambahLayananSalon extends StatefulWidget {
  @override
  TambahLayananSalonState createState() => TambahLayananSalonState();
}

class TambahLayananSalonState extends State<TambahLayananSalon> {
  ClassKategori selectedKategori;
  TextEditingController myUsername = new TextEditingController();
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
  double _rating = 1;
  int _radioValue = 0;
  int _radioValue1 = 0;
  int _radioValue2 = 0;
  String peruntukan = "";
  String jenjang = "";
  String status = "";
  String kategori;
  bool aktifpriadewasa = true;
  bool aktifwanitadewasa = true;
  bool aktifpriaanak = true;
  bool aktifwanitaanak = true;
  String foto = main_variable.ipnumber + "/gambar/default.png";
  List<ClassKategori> arrkategori = new List();

  void initState() {
    super.initState();
    getallkategori();
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      if (_radioValue1 == 0 && _radioValue == 0) {
        jenjang = "dewasa";
        peruntukan = "pria";
        myHargawanitadewasa.text = "0";
        myHargawanitaanak.text = "0";
        myHargapriaanak.text = "0";
        myHargapriadewasa.text = "";

        aktifpriadewasa = true;
        aktifpriaanak = false;
        aktifwanitaanak = false;
        aktifwanitadewasa = false;
      } else if (_radioValue1 == 1 && _radioValue == 0) {
        jenjang = "anak-anak";
        peruntukan = "pria";
        myHargawanitadewasa.text = "0";
        myHargawanitaanak.text = "0";
        myHargapriaanak.text = "";
        myHargapriadewasa.text = "0";

        aktifpriadewasa = false;
        aktifpriaanak = true;
        aktifwanitaanak = false;
        aktifwanitadewasa = false;
      } else if (_radioValue1 == 2 && _radioValue == 0) {
        jenjang = "semua";
        peruntukan = "pria";
        myHargawanitadewasa.text = "0";
        myHargawanitaanak.text = "0";
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
        myHargawanitaanak.text = "0";
        myHargapriaanak.text = "0";
        myHargapriadewasa.text = "0";

        aktifpriadewasa = false;
        aktifpriaanak = false;
        aktifwanitaanak = false;
        aktifwanitadewasa = true;
      } else if (_radioValue1 == 1 && _radioValue == 1) {
        jenjang = "anak-anak";
        peruntukan = "wanita";
        myHargawanitadewasa.text = "0";
        myHargawanitaanak.text = "";
        myHargapriaanak.text = "0";
        myHargapriadewasa.text = "0";

        aktifpriadewasa = false;
        aktifpriaanak = false;
        aktifwanitaanak = true;
        aktifwanitadewasa = false;
      } else if (_radioValue1 == 2 && _radioValue == 1) {
        jenjang = "semua";
        peruntukan = "wanita";
        myHargawanitadewasa.text = "";
        myHargawanitaanak.text = "";
        myHargapriaanak.text = "0";
        myHargapriadewasa.text = "0";

        aktifpriadewasa = false;
        aktifpriaanak = false;
        aktifwanitaanak = true;
        aktifwanitadewasa = true;
      } else if (_radioValue1 == 0 && _radioValue == 2) {
        jenjang = "dewasa";
        peruntukan = "semua";
        myHargawanitadewasa.text = "";
        myHargawanitaanak.text = "0";
        myHargapriaanak.text = "0";
        myHargapriadewasa.text = "";

        aktifpriadewasa = true;
        aktifpriaanak = false;
        aktifwanitaanak = false;
        aktifwanitadewasa = true;
      } else if (_radioValue1 == 1 && _radioValue == 2) {
        jenjang = "anak-anak";
        peruntukan = "semua";
        myHargawanitadewasa.text = "0";
        myHargawanitaanak.text = "";
        myHargapriaanak.text = "";
        myHargapriadewasa.text = "0";

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
        myHargawanitadewasa.text = "0";
        myHargawanitaanak.text = "0";
        myHargapriaanak.text = "0";
        myHargapriadewasa.text = "";

        aktifpriadewasa = true;
        aktifpriaanak = false;
        aktifwanitaanak = false;
        aktifwanitadewasa = false;
      } else if (_radioValue1 == 1 && _radioValue == 0) {
        jenjang = "anak-anak";
        peruntukan = "pria";
        myHargawanitadewasa.text = "0";
        myHargawanitaanak.text = "0";
        myHargapriaanak.text = "";
        myHargapriadewasa.text = "0";

        aktifpriadewasa = false;
        aktifpriaanak = true;
        aktifwanitaanak = false;
        aktifwanitadewasa = false;
      } else if (_radioValue1 == 2 && _radioValue == 0) {
        jenjang = "semua";
        peruntukan = "pria";
        myHargawanitadewasa.text = "0";
        myHargawanitaanak.text = "0";
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
        myHargawanitaanak.text = "0";
        myHargapriaanak.text = "0";
        myHargapriadewasa.text = "0";

        aktifpriadewasa = false;
        aktifpriaanak = false;
        aktifwanitaanak = false;
        aktifwanitadewasa = true;
      } else if (_radioValue1 == 1 && _radioValue == 1) {
        jenjang = "anak-anak";
        peruntukan = "wanita";
        myHargawanitadewasa.text = "0";
        myHargawanitaanak.text = "";
        myHargapriaanak.text = "0";
        myHargapriadewasa.text = "0";

        aktifpriadewasa = false;
        aktifpriaanak = false;
        aktifwanitaanak = true;
        aktifwanitadewasa = false;
      } else if (_radioValue1 == 2 && _radioValue == 1) {
        jenjang = "semua";
        peruntukan = "wanita";
        myHargawanitadewasa.text = "";
        myHargawanitaanak.text = "";
        myHargapriaanak.text = "0";
        myHargapriadewasa.text = "0";

        aktifpriadewasa = false;
        aktifpriaanak = false;
        aktifwanitaanak = true;
        aktifwanitadewasa = true;
      } else if (_radioValue1 == 0 && _radioValue == 2) {
        jenjang = "dewasa";
        peruntukan = "semua";
        myHargawanitadewasa.text = "";
        myHargawanitaanak.text = "0";
        myHargapriaanak.text = "0";
        myHargapriadewasa.text = "";

        aktifpriadewasa = true;
        aktifpriaanak = false;
        aktifwanitaanak = false;
        aktifwanitadewasa = true;
      } else if (_radioValue1 == 1 && _radioValue == 2) {
        jenjang = "anak-anak";
        peruntukan = "semua";
        myHargawanitadewasa.text = "0";
        myHargawanitaanak.text = "";
        myHargapriaanak.text = "";
        myHargapriadewasa.text = "0";

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

  void _handleRadioValueChange2(int value) {
    setState(() {
      _radioValue2 = value;

      if (_radioValue2 == 0) {
        status = "aktif";
        print("aktif");
      } else if (_radioValue2 == 1) {
        status = "non-aktif";
        print("nonaktif");
      }
    });
  }

  Future<String> getallkategori() async {
    Map paramData = {};
    var parameter = json.encode(paramData);

    ClassKategori databaru = new ClassKategori(
      "id",
      "idkategori",
      "namakategori",
    );

    http
        .post(main_variable.ipnumber + "/getallkategori",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];
      print(res.body);
      print(data.length);

      for (int i = 0; i < data.length; i++) {
        databaru = ClassKategori(
            data[i]['id'].toString(),
            data[i]['idkategori'].toString(),
            data[i]['namakategori'].toString());
        this.arrkategori.add(databaru);
      }
      setState(() => this.arrkategori = arrkategori);

      return databaru;
    }).catchError((err) {
      print(err);
    });
  }

  Future<String> insertlayanansalon() async {
    Map paramData = {
      'username': main_variable.userlogin,
      'namalayanan': myNamalayanan.text,
      'kategori': selectedKategori.idkategori,
      'jenjangusia': jenjang,
      'peruntukan': peruntukan,
      'hargapriadewasa': myHargapriadewasa.text,
      'hargawanitadewasa': myHargawanitadewasa.text,
      'hargawanitaanak': myHargawanitaanak.text,
      'hargapriaanak': myHargapriaanak.text,
      'durasi': myDurasi.text,
      'deskripsi': myDeskripsi.text,
      'status': status.toString(),
    };
    var parameter = json.encode(paramData);

    ClassLayanansalon databaru = new ClassLayanansalon(
        "id",
        "username",
        "namalayanan",
        "kategori",
        "jenjangusia",
        "peruntukan",
        "hargapriadewasa",
        "hargawanitadewasa",
        "hargawanitaanak",
        "hargapriaanak",
        "durasi",
        "deskripsi",
        "status");

    http
        .post(main_variable.ipnumber + "/insertlayanansalon",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body.substring(200));
      var data = json.decode(res.body);
      data = data[0]['status'];
      return databaru;
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEED7E7),
      appBar: AppBar(
        title: Text("Home Salon"),
      ),
      body: Center(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Center(
                child: TextFormField(
                  controller: myNamalayanan,
                  keyboardType: TextInputType.text,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Nama Layanan",
                      labelStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  validator: (value) => value.isEmpty ? "-" : null,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              width: double.infinity,
              child: DropdownButton<ClassKategori>(
                hint: Text("Select item"),
                value: selectedKategori,
                onChanged: (ClassKategori Value) {
                  setState(() {
                    selectedKategori = Value;
                  });
                },
                items: arrkategori.map((ClassKategori arrkategori) {
                  return DropdownMenuItem<ClassKategori>(
                    value: arrkategori,
                    child: Row(
                      children: <Widget>[
                        Text(
                          arrkategori.idkategori,
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          " - " + arrkategori.namakategori,
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Peruntukan',
                          hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      new Radio(
                        value: 0,
                        groupValue: _radioValue,
                        onChanged: _handleRadioValueChange,
                      ),
                      new Text(
                        'PRIA',
                        style: new TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      new Radio(
                        value: 1,
                        groupValue: _radioValue,
                        onChanged: _handleRadioValueChange,
                      ),
                      new Text(
                        'WANITA',
                        style: new TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      new Radio(
                        value: 2,
                        groupValue: _radioValue,
                        onChanged: _handleRadioValueChange,
                      ),
                      new Text(
                        'SEMUA',
                        style: new TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Jenjang Usia',
                          hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      new Radio(
                        value: 0,
                        groupValue: _radioValue1,
                        onChanged: _handleRadioValueChange1,
                      ),
                      new Text(
                        'DEWASA',
                        style: new TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      new Radio(
                        value: 1,
                        groupValue: _radioValue1,
                        onChanged: _handleRadioValueChange1,
                      ),
                      new Text(
                        'ANAK-ANAK',
                        style: new TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      new Radio(
                        value: 2,
                        groupValue: _radioValue1,
                        onChanged: _handleRadioValueChange1,
                      ),
                      new Text(
                        'SEMUA',
                        style: new TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: TextFormField(
                        controller: myHargapriadewasa,
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        enabled: aktifpriadewasa,
                        decoration: InputDecoration(
                            labelText: "Harga Pria Dewasa",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        validator: (value) => value.isEmpty ? "-" : null,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: TextFormField(
                        controller: myHargapriaanak,
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        enabled: aktifpriaanak,
                        decoration: InputDecoration(
                            labelText: "Harga Anak Laki-Laki",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        validator: (value) => value.isEmpty ? "-" : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: TextFormField(
                        controller: myHargawanitadewasa,
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        enabled: aktifwanitadewasa,
                        decoration: InputDecoration(
                            labelText: "Harga Wanita Dewasa",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        validator: (value) => value.isEmpty ? "-" : null,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: TextFormField(
                        controller: myHargawanitaanak,
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        enabled: aktifwanitaanak,
                        decoration: InputDecoration(
                            labelText: "Harga Anak Wanita",
                            labelStyle: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        validator: (value) => value.isEmpty ? "-" : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Center(
                child: TextFormField(
                  controller: myDurasi,
                  keyboardType: TextInputType.text,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Durasi",
                      labelStyle:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  validator: (value) => value.isEmpty ? "-" : null,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Center(
                child: TextFormField(
                  controller: myDeskripsi,
                  keyboardType: TextInputType.text,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: "Deskripsi",
                      labelStyle:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  validator: (value) => value.isEmpty ? "-" : null,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Status Layanan',
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      new Radio(
                        value: 0,
                        groupValue: _radioValue2,
                        onChanged: _handleRadioValueChange2,
                      ),
                      new Text(
                        'AKTIF',
                        style: new TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      new Radio(
                        value: 1,
                        groupValue: _radioValue2,
                        onChanged: _handleRadioValueChange2,
                      ),
                      new Text(
                        'NON-AKTIF',
                        style: new TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                  onPressed: () {
                    insertlayanansalon();
                    //Fluttertoast.showToast(msg: "Berhasil Input");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Dashboardsalon(),
                        ));
                  },
                  color: Colors.lightBlueAccent,
                  child: Text(
                    'Input Layanan',
                    style: TextStyle(color: Colors.white),
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
