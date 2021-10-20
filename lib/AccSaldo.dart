import 'package:flutter/material.dart';
import 'package:ta_salon/HomeSalon.dart';
import 'package:ta_salon/ServiceSalon.dart';
import 'ClassSalon.dart';
import 'main_variable.dart' as main_variable;
import 'dart:async';
import 'package:ta_salon/ClassUser.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:ta_salon/warnalayer.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class AccSaldo extends StatefulWidget {
  @override
  AccSaldoState createState() => AccSaldoState();
}

class AccSaldoState extends State<AccSaldo> {
  NumberFormat numberFormat = NumberFormat(',000');

  TextEditingController myFoto = new TextEditingController();

  List<ClassSalon> arrsalon1 = new List();
  List<ClassUser> arr = new List();

  String namasalonkirim, kotakrim;
  String foto = main_variable.ipnumber + "/gambar/default.png";

  File _image;

  void initState() {
    super.initState();
    print("ini usr salon dari main_var : " + main_variable.userlogin);
    setState(() {
      arrsalon1.add(new ClassSalon("id", "username", "namasalon", "alamat",
          "kota", "telp", "0", "0", "keterangan", "status"));
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
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });

    String namaFile = image.path;
    String basenamegallery = basename(namaFile);
  }

  Future<ClassSalon> getidsalon() async {
    List<ClassSalon> arrtemp = new List();
    Map paramData = {
      'username': main_variable.usernamesalon,
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

  Future<String> upadatesalon() async {
    String base64Image = base64Encode(_image.readAsBytesSync()); //mimage
    String fileName = _image.path.split("/").last; //mfile

    Map paramData = {
      'foto': myFoto.text,
      'mfile': fileName,
      'mimage': base64Image,
    };
    var parameter = json.encode(paramData);
    http
        .post(main_variable.ipnumber + "/upadatesalon",
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
                  color: Warnalayer.backgroundColor,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: arr.length == 0 ? 1 : arr.length,
                      itemBuilder: (BuildContext context, int index) => arr
                                  .length ==
                              0
                          ? Card(
                              child: Text("ITEM KOSONG"),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  print("ini jum arrboking.length " +
                                      arr[index].alamat.toString());
                                },
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          10.0, 5.0, 10.0, 0.0),
                                      width: 400,
                                      height: 140,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.all(10),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(13.0),
                                              child: Image.network(
                                                main_variable.ipnumber +
                                                    "/gambar/" +
                                                    arr[index].foto,
                                                width: 120.0,
                                                height: 120,
                                                fit: BoxFit.cover,
                                              ),
                                              // child: Image(
                                              //   width:
                                              //       120.0,
                                              //   height: 120,
                                              //   image: AssetImage(
                                              //       "images/background.png"),
                                              //   fit: BoxFit
                                              //       .cover,
                                              // ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 0, 0, 0),
                                            child: Column(
                                              children: [
                                                Container(
                                                  child: Text(
                                                    arr[index].alamat,
                                                    style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 10, 0, 0),
                                                  child: Text(
                                                    'Layanan        : ' +
                                                        arr[index].email,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 0, 50, 0),
                                                  child: Text(
                                                    'Pembayaran : ' +
                                                        arr[index].jeniskelamin,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 0, 50, 0),
                                                  child: Text(
                                                    'Total : Rp. ' +
                                                        numberFormat.format(
                                                            int.parse(arr[index]
                                                                .saldo)),
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      EdgeInsets.only(top: 10),
                                                ),
                                                Row(
                                                  children: [
                                                    TextButton(
                                                      onPressed: () {
                                                        print("button1");
                                                      },
                                                      style: TextButton.styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          primary: Colors.white,
                                                          backgroundColor:
                                                              Color(
                                                                  0xff374ABE)),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "Beri penilaian",
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 0, 10, 0),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        print("button 2");
                                                      },
                                                      style: TextButton.styleFrom(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5)),
                                                          primary: Colors.white,
                                                          backgroundColor:
                                                              Colors.red[600]),
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            "Pesan Lagi",
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
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
                            )),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
