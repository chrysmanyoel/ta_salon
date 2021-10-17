import 'package:ta_salon/ClassAbsensiPegawai.dart';
import 'package:ta_salon/ClassPegawai.dart';
import 'package:ta_salon/ClassSalon.dart';
import 'package:ta_salon/ClassAbsensiPegawai.dart';
import 'package:ta_salon/ClassDetailPegawai.dart';
import 'package:flutter/material.dart';
import 'package:ta_salon/LoginRegis.dart';
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

class ForgotPassword extends StatefulWidget {
  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController myEmail = new TextEditingController();
  TextEditingController myPassword = new TextEditingController();
  TextEditingController myOTP = new TextEditingController();
  TextEditingController myCpassword = new TextEditingController();

  bool forgot = false;

  void initState() {
    super.initState();
  }

  Future<String> cek_email() async {
    Map paramData = {
      'email': myEmail.text,
    };
    var parameter = json.encode(paramData);
    http
        .post(main_variable.ipnumber + "/cek_email",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];

      if (data == "sukses") {
        Fluttertoast.showToast(
            msg: "Berhasil Submit",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.blue[300],
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          forgot = true;
        });
        kirim_OTP();
      } else {
        Fluttertoast.showToast(
            msg: "Gagal Submit, Email Salah!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red[300],
            textColor: Colors.white,
            fontSize: 16.0);
      }

      return data;
    }).catchError((err) {
      print(err);
    });
  }

  Future<String> updatenewpass() async {
    Map paramData = {
      'kode': myOTP.text,
      'email': myEmail.text,
      'password': myPassword.text,
    };
    var parameter = json.encode(paramData);
    http
        .post(main_variable.ipnumber + "/updatenewpass",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];

      if (data == "sukses") {
        Fluttertoast.showToast(
            msg: "Berhasil Mengganti Password",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.blue[300],
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginRegis(),
            ));
      } else if (data == 'gagal') {
        Fluttertoast.showToast(
            msg: "Gagal OTP salah",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.blue[300],
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        print('gagal1');
      }

      return data;
    }).catchError((err) {
      print(err);
    });
  }

  Future<String> kirim_OTP() async {
    Map paramData = {
      'email': myEmail.text,
    };
    var parameter = json.encode(paramData);
    http
        .post(main_variable.ipnumber + "/kirim_OTP",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];

      return data;
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
      body: Stack(
        children: [
          //ini tampilan waktu email
          forgot == false
              ? Scaffold(
                  backgroundColor: Warnalayer.backgroundColor,
                  body: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        right: 0,
                        left: 0,
                        child: Container(
                          height: 300,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("images/background.png"),
                                  fit: BoxFit.fill)),
                          child: Container(
                            padding: EdgeInsets.only(top: 90, left: 20),
                            color: Color(0xFF3b5999).withOpacity(.85),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: "Forgot Password Page",
                                    style: TextStyle(
                                      fontSize: 25,
                                      letterSpacing: 2,
                                      color: Colors.yellow[700],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Klik Submit untuk melanjutkan",
                                  style: TextStyle(
                                    letterSpacing: 1,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      //Main Contianer for Login and Signup
                      Container(
                        margin: EdgeInsets.only(top: 200),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 700),
                          curve: Curves.easeInBack,

                          //ini atur besar container signup dan signin
                          height: 270,
                          padding: EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width - 40,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 15,
                                    spreadRadius: 5),
                              ]),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Column(
                                        children: [
                                          Text(
                                            "Forgot Password",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Warnalayer.activeColor),
                                          ),
                                          if (!forgot)
                                            Container(
                                              margin: EdgeInsets.only(top: 5),
                                              height: 2,
                                              width: 120,
                                              color: Colors.orange,
                                            )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(10, 20, 0, 0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Email User",
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
                                  margin: EdgeInsets.only(top: 10),
                                  child: Column(
                                    children: [
                                      buildTextField(
                                          MaterialCommunityIcons.email,
                                          "Email",
                                          false,
                                          false,
                                          myEmail),
                                      //ini button login
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 20, 20, 0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 60,
                                          child: RaisedButton(
                                            onPressed: () {
                                              print("aple" + myEmail.text);
                                              cek_email();
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
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0)),
                                              child: Container(
                                                constraints: BoxConstraints(
                                                    maxWidth: 300.0,
                                                    minHeight: 50.0),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Submit",
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
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
                )
              //ini tampilan ketika input kode otp
              : Scaffold(
                  backgroundColor: Warnalayer.backgroundColor,
                  body: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        right: 0,
                        left: 0,
                        child: Container(
                          height: 400,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("images/background.png"),
                                  fit: BoxFit.fill)),
                          child: Container(
                            padding: EdgeInsets.only(top: 90, left: 20),
                            color: Color(0xFF3b5999).withOpacity(.85),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: "Forgot Password Page",
                                    style: TextStyle(
                                      fontSize: 25,
                                      letterSpacing: 2,
                                      color: Colors.yellow[700],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Klik Submit untuk melanjutkan",
                                  style: TextStyle(
                                    letterSpacing: 1,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      //Main Contianer for Login and Signup
                      Container(
                        margin: EdgeInsets.only(top: 200),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 700),
                          curve: Curves.easeInBack,

                          //ini atur besar container signup dan signin
                          height: 440,
                          padding: EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width - 40,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 15,
                                    spreadRadius: 5),
                              ]),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "Forgot Password",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Warnalayer.activeColor),
                                    ),
                                    if (!forgot)
                                      Container(
                                        margin: EdgeInsets.only(top: 5),
                                        height: 2,
                                        width: 120,
                                        color: Colors.orange,
                                      )
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Column(
                                    children: [
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 20, 0, 10),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Kode OTP",
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
                                      buildTextField(
                                          MaterialCommunityIcons.email,
                                          "Kode OTP",
                                          false,
                                          false,
                                          myOTP),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 10, 0, 10),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Password",
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
                                      buildTextField(
                                          MaterialCommunityIcons.email,
                                          "Password Baru",
                                          false,
                                          false,
                                          myPassword),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(10, 10, 0, 10),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              "Konfirmasi Password",
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
                                      buildTextField(
                                          MaterialCommunityIcons.email,
                                          "Konfirmasi Password",
                                          false,
                                          false,
                                          myCpassword),
                                      //ini button login
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 20, 20, 0),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 60,
                                          child: RaisedButton(
                                            onPressed: () {
                                              print("aple1");
                                              if (myPassword.text ==
                                                  myCpassword.text) {
                                                updatenewpass();
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Gagal Submit, Password Tidak Sama Dengan Konfirmasi Password!",
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                    backgroundColor:
                                                        Colors.red[300],
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              }
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
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0)),
                                              child: Container(
                                                constraints: BoxConstraints(
                                                    maxWidth: 300.0,
                                                    minHeight: 50.0),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  "Submit",
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
    );
  }

  Widget buildTextField(IconData icon, String hintText, bool isPassword,
      bool isEmail, TextEditingController myControll) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        obscureText: isPassword,
        controller: myControll,
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
