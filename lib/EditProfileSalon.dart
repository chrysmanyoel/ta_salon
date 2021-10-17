import 'dart:developer';
import 'package:ta_salon/ClassGetUserWithSalon_usr.dart';
import 'package:ta_salon/ClassUser.dart';
import 'package:flutter/material.dart';
import 'package:ta_salon/DashboardSalon.dart';
import 'main_variable.dart' as main_variable;
import 'dart:async';
import 'package:ta_salon/ClassSalon.dart';
import 'package:ta_salon/warnalayer.dart';
import 'Classupdatesalon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'profile_menu.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class EditprofileSalon extends StatefulWidget {
  @override
  EditprofileSalonState createState() => EditprofileSalonState();
}

ClassUser datalama =
    new ClassUser("", "", "", "", "", "", "", "", "", "", "", "", "");

class EditprofileSalonState extends State<EditprofileSalon> {
  TextEditingController myEmail = new TextEditingController();
  TextEditingController myUsername = new TextEditingController();
  TextEditingController myPassword = new TextEditingController();
  TextEditingController myNama = new TextEditingController();
  TextEditingController myAlamat = new TextEditingController();
  TextEditingController myKota = new TextEditingController();
  TextEditingController myTelp = new TextEditingController();
  TextEditingController myFoto = new TextEditingController();
  TextEditingController mySaldo = new TextEditingController();
  TextEditingController myTanggal = new TextEditingController();
  TextEditingController myJK = new TextEditingController();
  TextEditingController myKeterangan = new TextEditingController();
  TextEditingController myDiskon = new TextEditingController();
  TextEditingController myLatitude = new TextEditingController();
  TextEditingController myLongitude = new TextEditingController();
  TextEditingController myStatus = new TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool isMale = true;
  bool isFemale = false;
  bool isAktif = true;
  bool isNonAktif = false;
  bool suksesupdate = false;
  bool issaldopayment = false, iscashpayment = false;
  String jeniskelamin, status, payment;
  String foto = main_variable.ipnumber + "/gambar/default.png";
  File _image;
  List<String> arrpayment = new List();
  List<ClassGetUserWithSalon_usr> arr = new List();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1960, 1),
        lastDate: DateTime(2022));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        myTanggal.text = selectedDate.toString().substring(0, 10);
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

  void initState() {
    super.initState();
    getuserswithsalondgnusername();
    print("ini yang salon" + main_variable.userlogin);
  }

  Future<String> getuserswithsalondgnusername() async {
    Map paramData = {
      'username': main_variable.userlogin,
    };
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/getuserswithsalondgnusername",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];
      print(res.body);
      print(data.length);

      for (int i = 0; i < data.length; i++) {
        ClassGetUserWithSalon_usr databaru = new ClassGetUserWithSalon_usr(
            data[i]['email'].toString(),
            data[i]['username'].toString(),
            data[i]['password'].toString(),
            data[i]['nama'].toString(),
            data[i]['alamat'].toString(),
            data[i]['kota'].toString(),
            data[i]['telp'].toString(),
            data[i]['pembayaran'].toString(),
            data[i]['diskon'].toString(),
            data[i]['foto'].toString(),
            data[i]['saldo'].toString(),
            data[i]['tgllahir'].toString(),
            data[i]['jeniskelamin'].toString(),
            data[i]['latitude'].toString(),
            data[i]['longitude'].toString(),
            data[i]['keterangan'].toString(),
            data[i]['role'].toString(),
            data[i]['status'].toString());
        this.arr.add(databaru);
        foto = main_variable.ipnumber + "/gambar/" + arr[i].foto;
        myEmail.text = arr[i].email.toString();
        myUsername.text = arr[i].username.toString();
        myPassword.text = arr[i].password.toString();
        myNama.text = arr[i].nama.toString();
        myAlamat.text = arr[i].alamat.toString();
        myKota.text = arr[i].kota.toString();
        String temp;
        temp = arr[i].pembayaran.toString();
        if (temp == "cash") {
          iscashpayment = true;
          issaldopayment = false;
        } else if (temp == "saldo") {
          iscashpayment = false;
          issaldopayment = true;
        } else if (temp == "cash,saldo" || temp == "saldo,cash") {
          iscashpayment = true;
          issaldopayment = true;
        }
        myDiskon.text = arr[i].diskon.toString();
        myFoto.text = arr[i].foto.toString();
        myTelp.text = arr[i].telp.toString();
        myLatitude.text = arr[i].latitude.toString();
        myLongitude.text = arr[i].longitude.toString();
        myKeterangan.text = arr[i].keterangan.toString();
        myTanggal.text = arr[i].tgllahir.toString();
        myJK.text = arr[i].jeniskelamin.toString();
        myStatus.text = arr[i].status.toString();
        if (myJK.text == "pria") {
          isMale = true;
          isFemale = false;
        } else {
          isMale = false;
          isFemale = true;
        }
        if (myStatus.text == "aktif") {
          isAktif = true;
          isNonAktif = false;
        } else {
          isAktif = false;
          isNonAktif = true;
        }
      }
      setState(() => this.arr = arr);

      return arr;
    }).catchError((err) {
      print(err);
    });
  }

  Future<String> updatesalon() async {
    Map paramData = {
      'username': main_variable.userlogin,
      'namasalon': myNama.text,
      'alamat': myAlamat.text,
      'kota': myKota.text,
      'telp': myTelp.text,
      'pembayaran': payment,
      'diskon': myDiskon.text,
      'telp': myTelp.text,
      'longitude': myLongitude.text,
      'latitude': myLatitude.text,
      'keterangan': myKeterangan.text,
      'status': status,
    };
    var parameter = json.encode(paramData);
    http
        .post(main_variable.ipnumber + "/updatesalon",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body);
      if (res.body.contains("sukses")) {
        print("Berhasil Update Profile");
      } else {
        print("Update gagal");
      }
    }).catchError((err) {
      print(err);
    });
    return "";
  }

  Future<String> upadateuser() async {
    String base64Image = "";
    String fileName = "";

    if (_image != null) {
      base64Image = base64Encode(_image.readAsBytesSync()); //mimage
      fileName = _image.path.split("/").last; //mfile
      print("not null");
    } else {
      print("image is null");
    }

    Map paramData = {
      'username': main_variable.userlogin,
      'password': myPassword.text,
      'nama': myNama.text,
      'alamat': myAlamat.text,
      'kota': myKota.text,
      'telp': myTelp.text,
      'foto': myFoto.text,
      'tgllahir': myTanggal.text,
      'jeniskelamin': jeniskelamin,
      'mfile': fileName,
      'mimage': base64Image,
    };
    var parameter = json.encode(paramData);
    http
        .post(main_variable.ipnumber + "/updateuser",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body);
      if (res.body.contains("sukses")) {
        print("Berhasil Update Profile");
        setState(() => this.suksesupdate = true);
      } else {
        print("Update gagal");
      }
    }).catchError((err) {
      print(err);
    });
    return "";
  }

  void _oncashpayment(bool newValue) => setState(() {
        iscashpayment = newValue;

        if (iscashpayment) {
          payment = "cash";
          if (arrpayment.length == 0) {
            arrpayment.add(payment);
          } else {
            arrpayment.add(payment);
          }
          print("ini arridkat : " + arrpayment.toString());
          // TODO: Here goes your functionality that remembers the user.
        } else {
          payment = "";
          arrpayment.removeLast();
          print("ini payment : " + arrpayment.toString());
          // TODO: Forget the user
        }
      });

  void _onsaldopayment(bool newValue) => setState(() {
        issaldopayment = newValue;

        if (issaldopayment) {
          payment = "saldo";
          if (arrpayment.length == 0) {
            arrpayment.add(payment);
          } else {
            arrpayment.add(payment);
          }
          print("ini payment : " + arrpayment.toString());
          // TODO: Here goes your functionality that remembers the user.
        } else {
          payment = "";
          arrpayment.removeLast();
          print("ini payment : " + arrpayment.toString());
          // TODO: Forget the user
        }
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warnalayer.backgroundColor,
      body: Center(
        child: ListView(
          children: <Widget>[
            Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(40.0, 15.0, 20.0, 5.0),
                ),
                fotoprofile1(this.context),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 10, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Email ",
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
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: buildTextField(MaterialCommunityIcons.email, "Email",
                        false, false, false, myEmail),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Username ",
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
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: buildTextField(MaterialCommunityIcons.identifier,
                        "User Name", false, false, false, myUsername),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Password ",
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
                    height: 60,
                    child: buildTextField(
                        MaterialCommunityIcons.textbox_password,
                        "Password",
                        false,
                        false,
                        true,
                        myPassword),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Nama ",
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
                    height: 60,
                    child: buildTextField(
                        MaterialCommunityIcons.account_outline,
                        "Name",
                        false,
                        false,
                        true,
                        myNama),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Established Since",
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
                  padding: EdgeInsets.fromLTRB(30, 0, 0, 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Center(
                          child: TextFormField(
                            controller: myTanggal,
                            decoration:
                                InputDecoration(labelText: 'Birthday Day'),
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
                                margin: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, .0),
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(0),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          blurRadius: 5,
                                          spreadRadius: 1)
                                    ]),
                                child: Icon(
                                  Icons.date_range,
                                  size: 28,
                                  color:
                                      (false) ? Colors.red : Colors.grey[600],
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
                  margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Jenis Kelamin ",
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
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isMale = true;
                            isFemale = false;
                            jeniskelamin = "pria";
                            print("ini jk pria: " + jeniskelamin);
                          });
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              margin: EdgeInsets.fromLTRB(20, 5, 8, 10),
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              decoration: BoxDecoration(
                                  color: isMale
                                      ? Warnalayer.textColor2
                                      : Colors.transparent,
                                  border: Border.all(
                                      width: 1,
                                      color: isMale
                                          ? Colors.transparent
                                          : Warnalayer.textColor1),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Icon(
                                MaterialCommunityIcons.account_outline,
                                color: isMale
                                    ? Colors.white
                                    : Warnalayer.iconColor,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 17, 0),
                                child: Text('Male',
                                    style: TextStyle(
                                        color: Warnalayer.textColor1))),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isMale = false;
                            isFemale = true;
                            jeniskelamin = "wanita";
                            print("ini jk wanita: " + jeniskelamin);
                          });
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                  color: isMale
                                      ? Colors.transparent
                                      : Warnalayer.textColor2,
                                  border: Border.all(
                                      width: 1,
                                      color: isMale
                                          ? Warnalayer.textColor1
                                          : Colors.transparent),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Icon(
                                MaterialCommunityIcons.account_outline,
                                color: isMale
                                    ? Warnalayer.iconColor
                                    : Colors.white,
                              ),
                            ),
                            Text(
                              "Female",
                              style: TextStyle(color: Warnalayer.textColor1),
                            )
                          ],
                        ),
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
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: buildTextField(MaterialCommunityIcons.routes,
                        "Address", false, false, true, myAlamat),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Kota ",
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
                    height: 60,
                    child: buildTextField(MaterialCommunityIcons.city, "City",
                        false, false, true, myKota),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Pembayaran yang digunakan ",
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 10),
                          ),
                          Expanded(
                            child: new CheckboxListTile(
                                value: iscashpayment,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                activeColor: Colors.blue[600],
                                title: Text(
                                  'Cash Payment',
                                  style: TextStyle(fontSize: 16),
                                ),
                                onChanged: _oncashpayment),
                          ),
                          Expanded(
                            child: new CheckboxListTile(
                                value: issaldopayment,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                activeColor: Colors.blue[600],
                                title: Text(
                                  'MidTrans Payment',
                                  style: TextStyle(fontSize: 16),
                                ),
                                onChanged: _onsaldopayment),
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 10, 0, 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Diskon ",
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
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: buildTextField(MaterialCommunityIcons.percent,
                        "Diskon", false, false, true, myDiskon),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 10, 0, 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Latitude ",
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
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: buildTextField(MaterialCommunityIcons.routes,
                        "Latitude", false, false, true, myLatitude),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Longitude ",
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
                    height: 60,
                    child: buildTextField(MaterialCommunityIcons.routes,
                        "Longitude", false, false, true, myLongitude),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Keterangan Salon",
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
                    height: 60,
                    child: buildTextField(
                        MaterialCommunityIcons.chat,
                        "C/ Salon dgn Style jejepangan",
                        false,
                        false,
                        true,
                        myKeterangan),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Telepon ",
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
                    height: 60,
                    child: buildTextField(MaterialCommunityIcons.phone,
                        "Telpon Number", false, false, true, myTelp),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Status Salon",
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
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isAktif = true;
                            isNonAktif = false;
                            status = "aktif";
                            print("ini status akt: " + status);
                          });
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              margin: EdgeInsets.fromLTRB(20, 5, 8, 10),
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              decoration: BoxDecoration(
                                  color: isAktif
                                      ? Warnalayer.textColor2
                                      : Colors.transparent,
                                  border: Border.all(
                                      width: 1,
                                      color: isAktif
                                          ? Colors.transparent
                                          : Warnalayer.textColor1),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Icon(
                                MaterialCommunityIcons.account_outline,
                                color: isAktif
                                    ? Colors.white
                                    : Warnalayer.iconColor,
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 17, 0),
                                child: Text('Aktif',
                                    style: TextStyle(
                                        color: Warnalayer.textColor1))),
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
                            print("ini status nonak: " + status);
                          });
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              margin: EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                  color: isAktif
                                      ? Colors.transparent
                                      : Warnalayer.textColor2,
                                  border: Border.all(
                                      width: 1,
                                      color: isAktif
                                          ? Warnalayer.textColor1
                                          : Colors.transparent),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Icon(
                                MaterialCommunityIcons.account_outline,
                                color: isAktif
                                    ? Warnalayer.iconColor
                                    : Colors.white,
                              ),
                            ),
                            Text(
                              "Non-Aktif / Tutup",
                              style: TextStyle(color: Warnalayer.textColor1),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(35, 10, 20, 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 320,
                        height: 50,
                        child: RaisedButton(
                          onPressed: () {
                            if (arrpayment.isEmpty == true) {
                              Fluttertoast.showToast(
                                  msg: "Pembayanran Salon Tidak Boleh KOSONG!",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red[300],
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              payment = arrpayment.toString();
                              payment =
                                  payment.substring(1, payment.length - 1);
                              //print("ini baru " + payment);
                              updatesalon();
                              upadateuser();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Dashboardsalon(),
                                  ));
                              Fluttertoast.showToast(
                                  msg: "Berhasil Update",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.blue[300],
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
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
                                borderRadius: BorderRadius.circular(30.0)),
                            child: Container(
                              constraints: BoxConstraints(
                                  maxWidth: 320.0, minHeight: 50.0),
                              alignment: Alignment.center,
                              child: Text(
                                "Update Profile",
                                textAlign: TextAlign.center,
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
          ],
        ),
      ),
    );
  }

  Widget fotoprofile1(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          SizedBox(height: 50),
          ClipRRect(
            borderRadius: BorderRadius.circular(60.0),
            child: _image == null
                ? Image.network(
                    this.foto,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  )
                : Image.file(_image),
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(color: Colors.white),
                ),
                color: Color(0xFFF5F6F9),
                onPressed: () {
                  getImageFromGallery();
                },
                child: SvgPicture.asset("assets/icons/Camera Icon.svg"),
              ),
            ),
          )
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
}
