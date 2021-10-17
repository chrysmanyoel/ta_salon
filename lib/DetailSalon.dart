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
import 'dart:convert';
import 'ClassFavoritJoinSalonJoinUser.dart';
import 'ClassGetJadwalSalon.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DetailSalon extends StatefulWidget {
  final String kotakrim;
  final String namasalonkirim;

  DetailSalon({Key key, @required this.namasalonkirim, @required this.kotakrim})
      : super(key: key);

  @override
  DetailSalonState createState() =>
      DetailSalonState(this.namasalonkirim, this.kotakrim);
}

class DetailSalonState extends State<DetailSalon> {
  bool _like = null;
  String idfavorit = "";

  TextEditingController myFoto = new TextEditingController();
  TextEditingController myTimeSeninbuka = new TextEditingController();
  TextEditingController myTimeSenintutup = new TextEditingController();
  TextEditingController myTimeSelasabuka = new TextEditingController();
  TextEditingController myTimeSelasatutup = new TextEditingController();
  TextEditingController myTimeRabubuka = new TextEditingController();
  TextEditingController myTimeRabututup = new TextEditingController();
  TextEditingController myTimeKamisbuka = new TextEditingController();
  TextEditingController myTimeKamistutup = new TextEditingController();
  TextEditingController myTimeJumatbuka = new TextEditingController();
  TextEditingController myTimeJumattutup = new TextEditingController();
  TextEditingController myTimeSabtubuka = new TextEditingController();
  TextEditingController myTimeSabtututup = new TextEditingController();
  TextEditingController myTimeMinggubuka = new TextEditingController();
  TextEditingController myTimeMinggututup = new TextEditingController();

  List<ClassSalon> arrsalon1 = new List();
  List<ClassGetJadwalSalon> arrhari = new List();
  List<ClassFavoritJoinSalonJoinUser> arrfav = new List();

  String namasalonkirim, kotakrim;

  DetailSalonState(this.namasalonkirim, this.kotakrim);

  String foto = main_variable.ipnumber + "/gambar/default.png";
  File _image;

  List<ClassUser> arr = new List();

  void initState() {
    super.initState();
    print("ini usr salon dari main_var : " + main_variable.usernamesalon);
    getidsalon();
    getFavorit();
    getjadwalsalon();
    //getuser();
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });

    String namaFile = image.path;
    String basenamegallery = basename(namaFile);
  }

  Future<ClassFavoritJoinSalonJoinUser> getFavorit() async {
    arrfav.clear();
    Map paramData = {
      'username': main_variable.userlogin,
    };
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/getallfavoritjoinuser",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];
      print(res.body);
      print(data.length);

      for (int i = 0; i < data.length; i++) {
        ClassFavoritJoinSalonJoinUser databaru =
            new ClassFavoritJoinSalonJoinUser(
          data[i]['idfavorit'].toString(),
          data[i]['isalon'].toString(),
          data[i]['username'].toString(),
          data[i]['namasalon'].toString(),
          data[i]['kota'].toString(),
          data[i]['alamat'].toString(),
          data[i]['usernamesalon'].toString(),
          data[i]['foto'].toString(),
        );

        setState(() {
          this.arrfav.add(databaru);
        });
      }
      int ctr = -1;
      for (int j = 0; j < arrfav.length; j++) {
        if (arrfav[j].usernamesalon == main_variable.usernamesalon) {
          ctr = j;
          idfavorit = arrfav[j].idfavorit;

          print("idfav : " + ctr.toString());
        } else {
          print("object" + ctr.toString());
        }
      }
      if (ctr > -1) {
        _like = true;
        print("object1" + ctr.toString());
      } else {
        print("object2" + ctr.toString());
        _like = false;
      }

      return arrfav;
    }).catchError((err) {
      print(err);
    });
  }

  Future<ClassGetJadwalSalon> getjadwalsalon() async {
    List<ClassGetJadwalSalon> arrtemp = new List();
    Map paramData = {
      'idsalon': main_variable.idsalonlogin,
    };
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/getjadwalsalon",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];

      for (int i = 0; i < data.length; i++) {
        ClassGetJadwalSalon databaru = new ClassGetJadwalSalon(
            data[i]['id'].toString(),
            data[i]['idsalon'].toString(),
            data[i]['hari'].toString(),
            data[i]['jambuka'].toString(),
            data[i]['jamtutup'].toString());
        arrtemp.add(databaru);
      }
      setState(() => this.arrhari = arrtemp);

      return arrtemp;
    }).catchError((err) {
      print(err);
    });
  }

  Future<ClassFavoritJoinSalonJoinUser> insertfav() async {
    Map paramData = {
      'idsalon': arrsalon1[0].id,
      'username': main_variable.userlogin,
    };
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/insertfav",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];

      print(res.body);
      print(data.length);

      return data;
    }).catchError((err) {
      print(err);
    });
  }

  Future<String> getidsalon() async {
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
        this.arrsalon1.add(databaru);
      }
      setState(() => this.arrsalon1 = arrsalon1);
      setState(() => main_variable.idsalonlogin = arrsalon1[0].id.toString());

      return arr;
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

  Future<ClassFavoritJoinSalonJoinUser> deletefav() async {
    Map paramData = {'idfavorit': idfavorit};
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/deletefav",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];
      print(res.body);
      print(data.length);

      return arrfav;
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
                  height: height * 0.3,
                  width: width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("images/background.png"),
                          fit: BoxFit.cover)),
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Colors.black.withOpacity(0.0),
                      Colors.black.withOpacity(0.0),
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(1.0),
                    ], begin: Alignment.topRight, end: Alignment.bottomLeft)),
                  ),
                ),
                Positioned(
                  bottom: 90,
                  left: 20,
                  child: RichText(
                    text: TextSpan(
                        text: "Wellcome To, ",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                            fontSize: 17),
                        children: [
                          TextSpan(
                              text: namasalonkirim.toString() +
                                  "\nHave A Nice Day",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 24))
                        ]),
                  ),
                ),
                Positioned(
                  bottom: 50,
                  left: 20,
                  child: RichText(
                    text: TextSpan(
                        text: "Jam Operasional : " +
                            arrhari[0].jambuka.substring(0, 5) +
                            " - " +
                            arrhari[0].jamtutup.substring(0, 5),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                        children: []),
                  ),
                ),
                Positioned(
                  right: 35,
                  top: 30,
                  child: GestureDetector(
                    onTap: () {
                      print("ini fav");
                      if (_like == false) {
                        //ini kalo masukan fav
                        insertfav();
                        Fluttertoast.showToast(
                            msg: "Berhasil Menambak Ke Favorit",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.blue[300],
                            textColor: Colors.white,
                            fontSize: 16.0);
                        setState(() {
                          _like = true;
                          print("nangka");
                          getFavorit();
                        });
                      } else {
                        //ini kalo hapus dari fav
                        deletefav();
                        Fluttertoast.showToast(
                            msg: "Berhasil Menghapus Dari Favorit",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.red[500],
                            textColor: Colors.white,
                            fontSize: 16.0);
                        setState(() {
                          _like = false;
                          print("aple");
                          getFavorit();
                        });
                      }
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(35),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 5,
                                spreadRadius: 1)
                          ]),
                      child: Icon(
                        Icons.favorite,
                        size: 25,
                        color: _like == true ? Colors.red : Colors.grey[600],
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
                    length: 3,
                    child: Column(
                      children: <Widget>[
                        TabBar(
                          labelColor: Colors.black,
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                          unselectedLabelColor: Colors.grey[400],
                          unselectedLabelStyle: TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 17),
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: Colors.transparent,
                          tabs: <Widget>[
                            Tab(
                              child: Text("Services"),
                            ),
                            Tab(
                              child: Text("Promo"),
                            ),
                            Tab(
                              child: Text("More Info"),
                              //ini nanti di isi lokasi dari google map
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 0,
                        ),
                        Container(
                          height: height * 0.7,
                          child: TabBarView(
                            children: <Widget>[
                              ServiceSalon(),
                              ServiceSalon(),
                              Homesalon(),
                            ],
                          ),
                        )
                      ],
                    )),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
