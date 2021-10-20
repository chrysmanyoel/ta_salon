import 'package:flutter/material.dart';
import 'package:ta_salon/DashboardSalon.dart';
import 'package:ta_salon/HomeSalon.dart';
import 'package:ta_salon/ServiceSalon.dart';
import 'ClassSalon.dart';
import 'main_variable.dart' as main_variable;
import 'dart:async';
import 'package:ta_salon/ClassUser.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'ClassIklan.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart';
import 'package:ta_salon/warnalayer.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class IklanSalon extends StatefulWidget {
  @override
  IklanSalonState createState() => IklanSalonState();
}

class IklanSalonState extends State<IklanSalon> {
  NumberFormat numberFormat = NumberFormat(',000');

  TextEditingController myTanggal = new TextEditingController();
  TextEditingController JumlahHari = new TextEditingController();
  TextEditingController myFoto = new TextEditingController();

  int hargaiklan = 30000;

  File _image;

  DateTime selectedDate = DateTime.now();
  DateTime selectedDateAkhir = DateTime.now();

  List<ClassUser> arr = new List();
  List<ClassIklan> arriklan = new List();
  List<ClassIklan> arriklanacc = new List();
  List<ClassSalon> arrsalon1 = new List();

  String namasalonkirim, kotakrim;
  String foto = main_variable.ipnumber + "/gambar/default.png";

  bool ada = null;

  void initState() {
    super.initState();
    print("ini usr salon dari main_var : " + main_variable.userlogin);
    setState(() {
      arrsalon1.add(new ClassSalon("id", "username", "namasalon", "alamat",
          "kota", "telp", "0", "0", "keterangan", "status"));
      arriklanacc.add(new ClassIklan("idiklan", "tanggal", "username", "0",
          "tanggal_awal", "tanggal_akhir", "default.pgn", "status"));
      arriklan.add(new ClassIklan("idiklan", "tanggal", "username", "0",
          "tanggal_awal", "tanggal_akhir", "default", "status"));
      arr.add(new ClassUser(
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
    getidsalon();
    getiklan();
    getiklan_admin_acc();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2022));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        myTanggal.text = selectedDate.toString().substring(0, 10);
      });
  }

  Future<Null> _selectDateAkhir(BuildContext context) async {
    var date = new DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDateAkhir,
        firstDate: new DateTime.now(),
        lastDate: DateTime(2022));
    if (picked != null && picked != selectedDateAkhir)
      setState(() {
        selectedDateAkhir = picked;
        JumlahHari.text = selectedDateAkhir.toString().substring(0, 10);
      });
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });

    String namaFile = image.path;
    String basenamegallery = basename(namaFile);
  }

  Future<ClassIklan> getiklan_admin_acc() async {
    List<ClassIklan> arrtemp = new List();
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
        arrtemp.add(databaru);

        if (data[i]['username'].toString() ==
            main_variable.userlogin.toString()) {
          ada = true;
        } else {
          ada = false;
        }
        // print("data i : " + data[i]['username'].toString());
        // print("data mainvar : " + main_variable.userlogin.toString());
      }
      setState(() {
        this.arriklanacc = arrtemp;
      });

      return arrtemp;
    }).catchError((err) {
      print(err);
    });
  }

  Future<ClassIklan> getiklan() async {
    List<ClassIklan> arrtemp = new List();
    Map paramData = {
      'username': main_variable.userlogin,
    };
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/getiklan",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];
      print(res.body);
      print(data.length);

      if (data.length > 0) {
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
          arrtemp.add(databaru);
        }
      } else {
        ClassIklan databaru = new ClassIklan('-', '-', '-', '-',
            'Tidak Mempunyai Iklan', 'Tidak Mempunyai Iklan', '-', '-');
        setState(() {
          arrtemp.add(databaru);
        });
      }
      setState(() {
        this.arriklan = arrtemp;
      });

      return arrtemp;
    }).catchError((err) {
      print(err);
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
      print(res.body);
      print(data.length);

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
      setState(() => this.arrsalon1 = arrtemp);
      setState(() => main_variable.idsalonlogin = arrtemp[0].id.toString());

      return arrtemp;
    }).catchError((err) {
      print(err);
    });
  }

  Future<String> daftariklan() async {
    String base64Image = base64Encode(_image.readAsBytesSync()); //mimage
    String fileName = _image.path.split("/").last + ".png"; //mfile

    Map paramData = {
      'foto': myFoto.text,
      'mfile': fileName,
      'mimage': base64Image,
      'username': main_variable.userlogin,
      'hargaiklan': hargaiklan,
      'tanggal_awal': myTanggal.text,
      'tanggal_akhir': JumlahHari.text,
    };
    var parameter = json.encode(paramData);
    http
        .post(main_variable.ipnumber + "/daftariklan",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body);
      if (res.body.contains("sukses")) {
        print("Berhasil Daftar Iklan");
      } else {
        print("Update gagal");
      }
    }).catchError((err) {
      print(err);
    });
    return "";
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

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
                      height: 130,
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
                      left: 30,
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
                      top: 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            //widget.destination.city,
                            "Iklankan Salon Anda \n     Dapatkan Untung Yang Lebih",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                          // Row(
                          //   children: <Widget>[
                          //     Icon(
                          //       MaterialCommunityIcons.directions,
                          //       size: 15.0,
                          //       color: Colors.white70,
                          //     ),
                          //     SizedBox(width: 5.0),
                          //     Text(
                          //       //"Bandung",
                          //       main_variable.kotauser,
                          //       style: TextStyle(
                          //         fontWeight: FontWeight.bold,
                          //         color: Colors.white70,
                          //         fontSize: 18.0,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 150, 0, 20),
                      height: 460,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            elevation: 10,
                            shadowColor: Colors.black,
                            //warna luar gojek
                            color: Colors.white,
                            child: SizedBox(
                              //ini ukuran biru muda
                              width: 350,
                              height: 440,
                              child: Container(
                                margin: EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(30, 0, 0, 15),
                                      child: Text(
                                        'Pendaftaran Iklan Salon',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Stok Iklan Yang Tersisa: ",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                            ),
                                          ),
                                          Text(
                                            arriklanacc.length.toString(),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 17,
                                            ),
                                          ),
                                          Text(
                                            "/10",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(5),
                                    ),
                                    Text(
                                      "Harga @ Hari",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(5),
                                    ),
                                    Text(
                                      "             Rp. 30,000",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(5),
                                    ),
                                    Text(
                                      "Tanggal Awal",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 0, 10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Center(
                                              child: TextFormField(
                                                controller: myTanggal,
                                                decoration: InputDecoration(
                                                    labelText:
                                                        'Tanggal Awal Pengiklanan'),
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
                                                    margin: EdgeInsets.fromLTRB(
                                                        0.0, 20.0, 0.0, .0),
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
                                                      color: (false)
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
                                      padding: EdgeInsets.all(5),
                                    ),
                                    Text(
                                      "Tanggal Akhir",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(10, 0, 0, 10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Center(
                                              child: TextFormField(
                                                controller: JumlahHari,
                                                decoration: InputDecoration(
                                                    labelText:
                                                        'Tanggal Akhir Pengiklanan'),
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
                                                    _selectDateAkhir(context);
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        0.0, 20.0, 0.0, .0),
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
                                                      color: (false)
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
                                      padding: EdgeInsets.all(5),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              "Foto Promo Salon",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: SizedBox(
                                              height: 46,
                                              width: 46,
                                              child: FlatButton(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  side: BorderSide(
                                                      color: Colors.white),
                                                ),
                                                color: Color(0xFFF5F6F9),
                                                onPressed: () {
                                                  getImageFromGallery();
                                                },
                                                child: SvgPicture.asset(
                                                    "assets/icons/Camera Icon.svg"),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ada == true
                                        ? Container(
                                            padding: EdgeInsets.fromLTRB(
                                                55, 5, 15, 0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 180,
                                                  height: 40,
                                                  child: RaisedButton(
                                                    onPressed: () {
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Salon Anda Sedang Dalam Masa Pengiklanan",
                                                          toastLength:
                                                              Toast.LENGTH_LONG,
                                                          gravity: ToastGravity
                                                              .CENTER,
                                                          backgroundColor:
                                                              Colors.red[500],
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0);
                                                      myTanggal.text = "";
                                                      JumlahHari.text = "";
                                                    },
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        80.0)),
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    child: Ink(
                                                      decoration: BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
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
                                                              BorderRadius
                                                                  .circular(
                                                                      30.0)),
                                                      child: Container(
                                                        constraints:
                                                            BoxConstraints(
                                                                maxWidth: 320.0,
                                                                minHeight:
                                                                    50.0),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          "Daftar Iklan",
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
                                          )
                                        //ini kalo ngga ada
                                        : Container(
                                            padding: EdgeInsets.fromLTRB(
                                                55, 5, 15, 0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 180,
                                                  height: 40,
                                                  child: RaisedButton(
                                                    onPressed: () {
                                                      daftariklan();
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Berhasil Mendaftarkan Iklan",
                                                          toastLength:
                                                              Toast.LENGTH_LONG,
                                                          gravity: ToastGravity
                                                              .CENTER,
                                                          backgroundColor:
                                                              Colors.blue[300],
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0);
                                                      myTanggal.text = "";
                                                      JumlahHari.text = "";
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                Dashboardsalon(),
                                                          ));
                                                    },
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        80.0)),
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    child: Ink(
                                                      decoration: BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
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
                                                              BorderRadius
                                                                  .circular(
                                                                      30.0)),
                                                      child: Container(
                                                        constraints:
                                                            BoxConstraints(
                                                                maxWidth: 320.0,
                                                                minHeight:
                                                                    50.0),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          "Daftar Iklan",
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
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 620, 0, 0),
                      height: 180,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            elevation: 10,
                            shadowColor: Colors.black,
                            //warna luar gojek
                            color: Colors.white,
                            child: SizedBox(
                              //ini ukuran biru muda
                              width: 350,
                              height: 160,
                              child: Container(
                                margin: EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(50, 0, 0, 15),
                                      child: Text(
                                        'Progres Iklan Anda',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.5,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Text(
                                            "Tanggal Mulai : ",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            " " + arriklan[0].tanggal_awal,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(5),
                                    ),
                                    Container(
                                      child: Row(
                                        children: [
                                          Text(
                                            "Tanggal Akhir  : ",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            " " + arriklan[0].tanggal_akhir,
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 18,
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
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
