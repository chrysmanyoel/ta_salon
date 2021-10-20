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
import 'package:flutter_svg/flutter_svg.dart';
import 'profile_menu.dart';
import 'dart:io';
import 'ClassGetJadwalSalon.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class JamKerjaSalon extends StatefulWidget {
  @override
  JamKerjaSalonState createState() => JamKerjaSalonState();
}

ClassUser datalama =
    new ClassUser("", "", "", "", "", "", "", "", "", "", "", "", "");

class JamKerjaSalonState extends State<JamKerjaSalon> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = new TimeOfDay.now();
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
  bool isMale = true;
  bool isFemale = false;
  bool isAktif = true;
  bool isNonAktif = false;
  bool suksesupdate = false;
  bool _like = false;
  String jeniskelamin, status;
  String foto = main_variable.ipnumber + "/gambar/default.png";
  File _image;
  List<ClassGetJadwalSalon> arr = new List();

  void initState() {
    super.initState();
    setState(() {
      arr.add(new ClassGetJadwalSalon("id", "idsalon", "hari", "0", "0"));
    });
    getjadwalsalon();
    print("ini id salon yg login : " + main_variable.idsalonlogin);
  }

  Future<ClassGetJadwalSalon> getjadwalsalon() async {
    List<ClassGetJadwalSalon> arrtemp = new List();
    Map paramData = {
      'idsalon': main_variable.idsalonlogin,
    };
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/getjadwalsalon_set",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];
      print(res.body);
      print(data.length);

      for (int i = 0; i < data.length; i++) {
        ClassGetJadwalSalon databaru = new ClassGetJadwalSalon(
            data[i]['id'].toString(),
            data[i]['idsalon'].toString(),
            data[i]['hari'].toString(),
            data[i]['jambuka'].toString(),
            data[i]['jamtutup'].toString());
        arrtemp.add(databaru);

        //senin
        if (arrtemp[i].hari == "senin" && arrtemp[i].jambuka != null) {
          myTimeSeninbuka.text = arrtemp[i].jambuka.toString();
        }
        if (arrtemp[i].hari == "senin" && arrtemp[i].jamtutup != null) {
          myTimeSenintutup.text = arrtemp[i].jamtutup.toString();
        }
        //selasa
        if (arrtemp[i].hari == "selasa" && arrtemp[i].jambuka != null) {
          myTimeSelasabuka.text = arrtemp[i].jambuka.toString();
        }
        if (arrtemp[i].hari == "selasa" && arrtemp[i].jamtutup != null) {
          myTimeSelasatutup.text = arrtemp[i].jamtutup.toString();
        }
        //rabu
        if (arrtemp[i].hari == "rabu" && arrtemp[i].jambuka != null) {
          myTimeRabubuka.text = arrtemp[i].jambuka.toString();
        }
        if (arrtemp[i].hari == "rabu" && arrtemp[i].jamtutup != null) {
          myTimeRabututup.text = arrtemp[i].jamtutup.toString();
        }
        //kamis
        if (arrtemp[i].hari == "kamis" && arrtemp[i].jambuka != null) {
          myTimeKamisbuka.text = arrtemp[i].jambuka.toString();
        }
        if (arrtemp[i].hari == "kamis" && arrtemp[i].jamtutup != null) {
          myTimeKamistutup.text = arrtemp[i].jamtutup.toString();
        }
        //jumat
        if (arrtemp[i].hari == "jumat" && arrtemp[i].jambuka != null) {
          myTimeJumatbuka.text = arrtemp[i].jambuka.toString();
        }
        if (arrtemp[i].hari == "jumat" && arrtemp[i].jamtutup != null) {
          myTimeJumattutup.text = arrtemp[i].jamtutup.toString();
        }
        //sabtu
        if (arrtemp[i].hari == "sabtu" && arrtemp[i].jambuka != null) {
          myTimeSabtubuka.text = arrtemp[i].jambuka.toString();
        }
        if (arrtemp[i].hari == "sabtu" && arrtemp[i].jamtutup != null) {
          myTimeSabtututup.text = arrtemp[i].jamtutup.toString();
        }
        //minggu
        if (arrtemp[i].hari == "minggu" && arrtemp[i].jambuka != null) {
          myTimeMinggubuka.text = arrtemp[i].jambuka.toString();
        }
        if (arrtemp[i].hari == "minggu" && arrtemp[i].jamtutup != null) {
          myTimeMinggututup.text = arrtemp[i].jamtutup.toString();
        }
      }
      setState(() => this.arr = arrtemp);

      return arrtemp;
    }).catchError((err) {
      print(err);
    });
  }

  Future<String> updatejadwalsalonsenin() async {
    Map paramData = {
      'idsalon': main_variable.idsalonlogin,
      'hari': "senin",
      'jambuka': myTimeSeninbuka.text,
      'jamtutup': myTimeSenintutup.text,
    };
    var parameter = json.encode(paramData);
    http
        .post(main_variable.ipnumber + "/updatejadwalsalon",
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

  Future<String> updatejadwalsalonselasa() async {
    Map paramData = {
      'idsalon': main_variable.idsalonlogin,
      'hari': "selasa",
      'jambuka': myTimeSelasabuka.text,
      'jamtutup': myTimeSelasatutup.text,
    };
    var parameter = json.encode(paramData);
    http
        .post(main_variable.ipnumber + "/updatejadwalsalon",
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

  Future<String> updatejadwalsalonrabu() async {
    Map paramData = {
      'idsalon': main_variable.idsalonlogin,
      'hari': "rabu",
      'jambuka': myTimeRabubuka.text,
      'jamtutup': myTimeRabututup.text,
    };
    var parameter = json.encode(paramData);
    http
        .post(main_variable.ipnumber + "/updatejadwalsalon",
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

  Future<String> updatejadwalsalonkamis() async {
    Map paramData = {
      'idsalon': main_variable.idsalonlogin,
      'hari': "kamis",
      'jambuka': myTimeKamisbuka.text,
      'jamtutup': myTimeKamistutup.text,
    };
    var parameter = json.encode(paramData);
    http
        .post(main_variable.ipnumber + "/updatejadwalsalon",
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

  Future<String> updatejadwalsalonjumat() async {
    Map paramData = {
      'idsalon': main_variable.idsalonlogin,
      'hari': "jumat",
      'jambuka': myTimeJumatbuka.text,
      'jamtutup': myTimeJumattutup.text,
    };
    var parameter = json.encode(paramData);
    http
        .post(main_variable.ipnumber + "/updatejadwalsalon",
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

  Future<String> updatejadwalsalonsabtu() async {
    Map paramData = {
      'idsalon': main_variable.idsalonlogin,
      'hari': "sabtu",
      'jambuka': myTimeSabtubuka.text,
      'jamtutup': myTimeSabtututup.text,
    };
    var parameter = json.encode(paramData);
    http
        .post(main_variable.ipnumber + "/updatejadwalsalon",
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

  Future<String> updatejadwalsalonminggu() async {
    Map paramData = {
      'idsalon': main_variable.idsalonlogin,
      'hari': "minggu",
      'jambuka': myTimeMinggubuka.text,
      'jamtutup': myTimeMinggututup.text,
    };
    var parameter = json.encode(paramData);
    http
        .post(main_variable.ipnumber + "/updatejadwalsalon",
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

//////////////////////////////////////////////////////////////////////

  Future<void> _selectTimeseninbuka(BuildContext context) async {
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
        myTimeSeninbuka.text = selectedTime.hour.toString().padLeft(2, "0") +
            ":" +
            selectedTime.minute.toString().padLeft(2, "0");
      });
  }

  Future<void> _selectTimesenintutup(BuildContext context) async {
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
        myTimeSenintutup.text = selectedTime.hour.toString().padLeft(2, "0") +
            ":" +
            selectedTime.minute.toString().padLeft(2, "0");
      });
  }

  Future<void> _selectTimeselasabuka(BuildContext context) async {
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
        myTimeSelasabuka.text = selectedTime.hour.toString().padLeft(2, "0") +
            ":" +
            selectedTime.minute.toString().padLeft(2, "0");
      });
  }

  Future<void> _selectTimeselasatutup(BuildContext context) async {
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
        myTimeSelasatutup.text = selectedTime.hour.toString().padLeft(2, "0") +
            ":" +
            selectedTime.minute.toString().padLeft(2, "0");
      });
  }

  Future<void> _selectTimerabubuka(BuildContext context) async {
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
        myTimeRabubuka.text = selectedTime.hour.toString().padLeft(2, "0") +
            ":" +
            selectedTime.minute.toString().padLeft(2, "0");
      });
  }

  Future<void> _selectTimerabututup(BuildContext context) async {
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
        myTimeRabututup.text = selectedTime.hour.toString().padLeft(2, "0") +
            ":" +
            selectedTime.minute.toString().padLeft(2, "0");
      });
  }

  Future<void> _selectTimekamisbuka(BuildContext context) async {
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
        myTimeKamisbuka.text = selectedTime.hour.toString().padLeft(2, "0") +
            ":" +
            selectedTime.minute.toString().padLeft(2, "0");
      });
  }

  Future<void> _selectTimekamistutup(BuildContext context) async {
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
        myTimeKamistutup.text = selectedTime.hour.toString().padLeft(2, "0") +
            ":" +
            selectedTime.minute.toString().padLeft(2, "0");
      });
  }

  Future<void> _selectTimejumatbuka(BuildContext context) async {
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
        myTimeJumatbuka.text = selectedTime.hour.toString().padLeft(2, "0") +
            ":" +
            selectedTime.minute.toString().padLeft(2, "0");
      });
  }

  Future<void> _selectTimejumattutup(BuildContext context) async {
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
        myTimeJumattutup.text = selectedTime.hour.toString().padLeft(2, "0") +
            ":" +
            selectedTime.minute.toString().padLeft(2, "0");
      });
  }

  Future<void> _selectTimesabtubuka(BuildContext context) async {
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
        myTimeSabtubuka.text = selectedTime.hour.toString().padLeft(2, "0") +
            ":" +
            selectedTime.minute.toString().padLeft(2, "0");
      });
  }

  Future<void> _selectTimesabtututup(BuildContext context) async {
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
        myTimeSabtututup.text = selectedTime.hour.toString().padLeft(2, "0") +
            ":" +
            selectedTime.minute.toString().padLeft(2, "0");
      });
  }

  Future<void> _selectTimeminggubuka(BuildContext context) async {
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
        myTimeMinggubuka.text = selectedTime.hour.toString().padLeft(2, "0") +
            ":" +
            selectedTime.minute.toString().padLeft(2, "0");
      });
  }

  Future<void> _selectTimeminggututup(BuildContext context) async {
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
        myTimeMinggututup.text = selectedTime.hour.toString().padLeft(2, "0") +
            ":" +
            selectedTime.minute.toString().padLeft(2, "0");
      });
  }

/////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warnalayer.backgroundColor,
      body: Center(
        child: ListView(
          children: <Widget>[
            Column(
              children: [
                Stack(
                  children: <Widget>[
                    Container(
                      height: 160,
                      width: 400,
                      decoration: BoxDecoration(
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
                      top: 90,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            //widget.destination.city,
                            "Have a Nice Day",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                MaterialCommunityIcons.directions,
                                size: 15.0,
                                color: Colors.white70,
                              ),
                              SizedBox(width: 5.0),
                              Text(
                                //"Bandung",
                                main_variable.kotauser,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                  fontSize: 18.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.fromLTRB(50, 10, 0, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        '--- Edit Jadwal Jam Kerja Salon ---',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                          //fontWeight: FontWeight.bold,
                          foreground: Paint()
                            ..color = Colors.black
                            ..strokeWidth = 2.0
                            ..style = PaintingStyle.stroke,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                //senin
                Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                      height: 130.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Senin",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Text(
                                            "Jam Buka : ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                letterSpacing: 1.2,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: buildTextField(
                                                MaterialCommunityIcons
                                                    .timelapse,
                                                "Jam Buka",
                                                false,
                                                false,
                                                false,
                                                myTimeSeninbuka),
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  _selectTimeseninbuka(context);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0.0, 10.0, 5.0, .0),
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black
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
                                    margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Text(
                                            "Jam Tutup : ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                letterSpacing: 1.2,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: buildTextField(
                                                MaterialCommunityIcons
                                                    .timelapse,
                                                "Jam Tutup",
                                                false,
                                                false,
                                                false,
                                                myTimeSenintutup),
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  _selectTimesenintutup(
                                                      context);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0.0, 10.0, 5.0, .0),
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                //selasa
                Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                      height: 130.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Selasa",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Text(
                                            "Jam Buka : ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                letterSpacing: 1.2,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: buildTextField(
                                                MaterialCommunityIcons
                                                    .timelapse,
                                                "Jam Buka",
                                                false,
                                                false,
                                                false,
                                                myTimeSelasabuka),
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  _selectTimeselasabuka(
                                                      context);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0.0, 10.0, 5.0, .0),
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black
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
                                    margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Text(
                                            "Jam Tutup : ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                letterSpacing: 1.2,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: buildTextField(
                                                MaterialCommunityIcons
                                                    .timelapse,
                                                "Jam Tutup",
                                                false,
                                                false,
                                                false,
                                                myTimeSelasatutup),
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  _selectTimeselasatutup(
                                                      context);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0.0, 10.0, 5.0, .0),
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                //rabu
                Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                      height: 130.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Rabu",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Text(
                                            "Jam Buka : ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                letterSpacing: 1.2,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: buildTextField(
                                                MaterialCommunityIcons
                                                    .timelapse,
                                                "Jam Buka",
                                                false,
                                                false,
                                                false,
                                                myTimeRabubuka),
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  _selectTimerabubuka(context);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0.0, 10.0, 5.0, .0),
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black
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
                                    margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Text(
                                            "Jam Tutup : ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                letterSpacing: 1.2,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: buildTextField(
                                                MaterialCommunityIcons
                                                    .timelapse,
                                                "Jam Tutup",
                                                false,
                                                false,
                                                false,
                                                myTimeRabututup),
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  _selectTimerabututup(context);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0.0, 10.0, 5.0, .0),
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                //Kamis
                Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                      height: 130.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Kamis",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Text(
                                            "Jam Buka : ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                letterSpacing: 1.2,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: buildTextField(
                                                MaterialCommunityIcons
                                                    .timelapse,
                                                "Jam Buka",
                                                false,
                                                false,
                                                false,
                                                myTimeKamisbuka),
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  _selectTimekamisbuka(context);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0.0, 10.0, 5.0, .0),
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black
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
                                    margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Text(
                                            "Jam Tutup : ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                letterSpacing: 1.2,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: buildTextField(
                                                MaterialCommunityIcons
                                                    .timelapse,
                                                "Jam Tutup",
                                                false,
                                                false,
                                                false,
                                                myTimeKamistutup),
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  _selectTimekamistutup(
                                                      context);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0.0, 10.0, 5.0, .0),
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                //Jumat
                Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                      height: 130.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Jumat",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Text(
                                            "Jam Buka : ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                letterSpacing: 1.2,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: buildTextField(
                                                MaterialCommunityIcons
                                                    .timelapse,
                                                "Jam Buka",
                                                false,
                                                false,
                                                false,
                                                myTimeJumatbuka),
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  _selectTimejumatbuka(context);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0.0, 10.0, 5.0, .0),
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black
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
                                    margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Text(
                                            "Jam Tutup : ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                letterSpacing: 1.2,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: buildTextField(
                                                MaterialCommunityIcons
                                                    .timelapse,
                                                "Jam Tutup",
                                                false,
                                                false,
                                                false,
                                                myTimeJumattutup),
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  _selectTimejumattutup(
                                                      context);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0.0, 10.0, 5.0, .0),
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                //Sabtu
                Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                      height: 130.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Sabtu",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Text(
                                            "Jam Buka : ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                letterSpacing: 1.2,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: buildTextField(
                                                MaterialCommunityIcons
                                                    .timelapse,
                                                "Jam Buka",
                                                false,
                                                false,
                                                false,
                                                myTimeSabtubuka),
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  _selectTimesabtubuka(context);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0.0, 10.0, 5.0, .0),
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black
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
                                    margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Text(
                                            "Jam Tutup : ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                letterSpacing: 1.2,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: buildTextField(
                                                MaterialCommunityIcons
                                                    .timelapse,
                                                "Jam Tutup",
                                                false,
                                                false,
                                                false,
                                                myTimeSabtututup),
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  _selectTimesabtututup(
                                                      context);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0.0, 10.0, 5.0, .0),
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                //Minggu
                Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                      height: 130.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Minggu",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Text(
                                            "Jam Buka : ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                letterSpacing: 1.2,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: buildTextField(
                                                MaterialCommunityIcons
                                                    .timelapse,
                                                "Jam Buka",
                                                false,
                                                false,
                                                false,
                                                myTimeMinggubuka),
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  _selectTimeminggubuka(
                                                      context);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0.0, 10.0, 5.0, .0),
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black
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
                                    margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: Text(
                                            "Jam Tutup : ",
                                            style: TextStyle(
                                                fontSize: 16,
                                                letterSpacing: 1.2,
                                                color: Colors.black),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 50,
                                            child: buildTextField(
                                                MaterialCommunityIcons
                                                    .timelapse,
                                                "Jam Tutup",
                                                false,
                                                false,
                                                false,
                                                myTimeMinggututup),
                                          ),
                                        ),
                                        SizedBox(width: 10.0),
                                        Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: Center(
                                              child: GestureDetector(
                                                onTap: () {
                                                  _selectTimeminggututup(
                                                      context);
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0.0, 10.0, 5.0, .0),
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(35, 20, 20, 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 320,
                        height: 50,
                        child: RaisedButton(
                          onPressed: () {
                            print("ini my senintutup : " +
                                myTimeSenintutup.toString());
                            updatejadwalsalonsenin();
                            updatejadwalsalonselasa();
                            updatejadwalsalonrabu();
                            updatejadwalsalonkamis();
                            updatejadwalsalonjumat();
                            updatejadwalsalonsabtu();
                            updatejadwalsalonminggu();
                            Fluttertoast.showToast(
                                msg: "Berhasil Upload Jadwal Salon",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.blue,
                                textColor: Colors.white,
                                fontSize: 16.0);
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
                                "Upload Jadwal Salon",
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
