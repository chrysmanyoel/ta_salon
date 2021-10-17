import 'package:flutter/material.dart';
import 'package:ta_salon/ClassKategori.dart';
import 'package:ta_salon/HomeSalon.dart';
import 'package:ta_salon/ServiceSalon.dart';
import 'ClassSalon.dart';
import 'main_variable.dart' as main_variable;
import 'dart:async';
import 'package:ta_salon/warnalayer.dart';
import 'package:ta_salon/ClassUser.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'ClassIklan.dart';
import 'package:path/path.dart';
import 'dart:convert';

class InsertKategori extends StatefulWidget {
  @override
  InsertKategoriState createState() => InsertKategoriState();
}

class InsertKategoriState extends State<InsertKategori> {
  TextEditingController myUsername = new TextEditingController();

  List<String> _menuList = ['HAIR', 'NAIL', 'FACE', 'BODY CARE'];
  GlobalKey _key = LabeledGlobalKey("button_icon");
  OverlayEntry _overlayEntry;
  Offset _buttonPosition;
  bool _isMenuOpen = false;

  List<ClassIklan> arriklan = new List();
  List<ClassKategori> arrkategori = new List();
  List<ClassKategori> arrkategori_temp = new List();
  List<ClassIklan> arriklanacc = new List();
  String idiklan = '0', status = "", menukat = "HAIR";

  void _findButton() {
    RenderBox renderBox = _key.currentContext.findRenderObject();
    _buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  void _openMenu() {
    _findButton();
    _overlayEntry = _overlayEntryBuilder();
    Overlay.of(this.context).insert(_overlayEntry);
    _isMenuOpen = !_isMenuOpen;
  }

  void _closeMenu() {
    _overlayEntry.remove();
    _isMenuOpen = !_isMenuOpen;
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: _buttonPosition.dy + 50,
          left: _buttonPosition.dx + 20,
          width: 300,
          child: _popMenu(),
        );
      },
    );
  }

  void initState() {
    super.initState();
    //arrkategori[0]['idkategori'] = "default";
    //getiklan_admin();
    //getiklan_admin_acc();
    getkategori();
  }

  Future<ClassIklan> insertkategori() async {
    Map paramData = {
      'idkategori': menukat,
      'namakategori': myUsername.text,
    };
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/insertkategori",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];
      print(data.toString());

      if (data == "sukses") {
        Fluttertoast.showToast(
            msg: "Berhasil Insert",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.blue[300],
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(msg: "Gagal Insert, Kategori Sudah Ada");
      }
      print("ini statuts : " + data);

      return data;
    }).catchError((err) {
      print(err);
    });
  }

  Future<String> getkategori() async {
    Map paramData = {};
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/getkategori",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];

      for (int i = 0; i < data.length; i++) {
        ClassKategori databaru = new ClassKategori(
          data[i]['id'].toString(),
          data[i]['idkategori'].toString(),
          data[i]['namakategori'].toString(),
        );

        setState(() {
          this.arrkategori.add(databaru);
        });
      }

      return arrkategori;
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
          "Halaman Master Kategori",
          textAlign: TextAlign.center,
        ),
      ),
      body: ListView(
        children: [
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  //shadowColor: Colors.black,
                  color: Colors.white,
                  child: SizedBox(
                    width: 340,
                    height: 300,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(100, 10, 0, 5),
                            child: Text(
                              'Hapus Kategori',
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
                            margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Kategori",
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
                          // Container(
                          //   key: _key,
                          //   width: 300,
                          //   height: 40,
                          //   margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          //   decoration: BoxDecoration(
                          //     color: Colors.grey[200],
                          //     borderRadius: BorderRadius.circular(25),
                          //   ),
                          //   child: Row(
                          //     children: [
                          //       Expanded(
                          //         child: Center(child: Text(menukat)),
                          //       ),
                          //       IconButton(
                          //         icon: Icon(Icons.arrow_downward),
                          //         iconSize: 18,
                          //         color: Colors.black,
                          //         onPressed: () {
                          //           _isMenuOpen ? _closeMenu() : _openMenu();
                          //         },
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Container(
                            margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Nama Kategori ",
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
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: buildTextField(
                                  MaterialCommunityIcons.identifier,
                                  "Nama Kategori",
                                  false,
                                  false,
                                  true,
                                  myUsername),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(40, 10, 50, 10),
                            child: TextButton(
                              onPressed: () {
                                print("masuk terima");
                                insertkategori();
                              },
                              style: TextButton.styleFrom(
                                  side:
                                      BorderSide(width: 1, color: Colors.grey),
                                  minimumSize: Size(40, 35),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  primary: Colors.white,
                                  backgroundColor: Color(0xff374ABE)),
                              child: Center(
                                child: Text(
                                  "Insert Kategori",
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
                  ),
                ),
              ),
              //hapus kategori
              Container(
                margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  //shadowColor: Colors.black,
                  color: Colors.white,
                  child: SizedBox(
                    width: 340,
                    height: 300,
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(100, 10, 0, 5),
                            child: Text(
                              'Insert Kategori',
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
                            margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Kategori",
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
                            key: _key,
                            width: 300,
                            height: 40,
                            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Center(child: Text(menukat)),
                                ),
                                IconButton(
                                  icon: Icon(Icons.arrow_downward),
                                  iconSize: 18,
                                  color: Colors.black,
                                  onPressed: () {
                                    _isMenuOpen ? _closeMenu() : _openMenu();
                                  },
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Nama Kategori ",
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
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: buildTextField(
                                  MaterialCommunityIcons.identifier,
                                  "Nama Kategori",
                                  false,
                                  false,
                                  true,
                                  myUsername),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(40, 10, 50, 10),
                            child: TextButton(
                              onPressed: () {
                                print("menukat : " +
                                    menukat +
                                    " - " +
                                    myUsername.text);
                                insertkategori();
                                myUsername.text = "";
                              },
                              style: TextButton.styleFrom(
                                  side:
                                      BorderSide(width: 1, color: Colors.grey),
                                  minimumSize: Size(40, 35),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  primary: Colors.white,
                                  backgroundColor: Color(0xff374ABE)),
                              child: Center(
                                child: Text(
                                  "Insert Kategori",
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
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  shadowColor: Colors.black,
                  color: Colors.white,
                  child: SizedBox(
                    width: 350,
                    height: 300,
                    child: ListView(
                      children: [
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(10, 10, 0, 5),
                              child: Text(
                                'List Kategori',
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
                            SizedBox(
                              width: 330,
                              height: 250,
                              child: ListView(
                                children: <Widget>[
                                  Column(
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: arrkategori.length,
                                        itemBuilder:
                                            (BuildContext context, int index) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    20, 10, 0, 5),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      '• ',
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        foreground: Paint()
                                                          ..color = Colors.black
                                                          ..strokeWidth = 2.0,
                                                        letterSpacing: 1.5,
                                                      ),
                                                    ),
                                                    Text(
                                                      arrkategori[index]
                                                              .idkategori +
                                                          " - ",
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        foreground: Paint()
                                                          ..color = Colors.black
                                                          ..strokeWidth = 2.0,
                                                        letterSpacing: 1.5,
                                                      ),
                                                    ),
                                                    Text(
                                                      arrkategori[index]
                                                          .namakategori,
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
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
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
              ),
            ],
          ),
        ],
      ),
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

  Widget _popMenu() {
    return Material(
      child: Container(
        width: 330,
        height: 230,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(4),
        ),
        child: ListView(
          children: [
            Column(
              children: List.generate(
                _menuList.length,
                (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        menukat = _menuList[index];
                      });
                      _closeMenu();
                    },
                    child: Column(
                      children: [
                        Divider(
                          color: Colors.black,
                        ),
                        Text(
                          _menuList[index],
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 1.2,
                              color: Colors.black),
                        ),
                        Divider(
                          color: Colors.black,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
