import 'package:flutter/material.dart';
import 'package:focused_menu/modals.dart';
import 'package:ta_salon/ClassLayananWithUsers.dart';
import 'package:ta_salon/ClassListBookingWithLayanan.dart';
import 'package:ta_salon/HomeSalon.dart';
import 'package:ta_salon/ServiceSalon.dart';
import 'main_variable.dart' as main_variable;
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ta_salon/warnalayer.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:ta_salon/ClassUser.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'ClassBookingService.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart';
import 'constants.dart';
import 'dart:convert';

class ListBookingSalon extends StatefulWidget {
  @override
  ListBookingSalonState createState() => ListBookingSalonState();
}

class ListBookingSalonState extends State<ListBookingSalon> {
  TextEditingController myFoto = new TextEditingController();
  TextEditingController myStatus = new TextEditingController();
  TextEditingController myTgl_temp = new TextEditingController();
  TextEditingController myTgl = new TextEditingController();
  TextEditingController myTime = new TextEditingController();
  TextEditingController myTime_temp = new TextEditingController();
  NumberFormat numberFormat = NumberFormat(',000');

  String myidupdate, idservice = "", mystatus = "", statusreschedule = "";
  String foto = main_variable.ipnumber + "/gambar/default.png";
  String hari = "default", usernamecancel = "";

  List<ClassListBookingWithLayanan> arr = new List();
  List<ClassListBookingWithLayanan> arrsemua = new List();
  List<ClassBookingService> arrcount = new List();
  List<String> hri1 = new List();
  List<String> hri2 = new List();

  File _image;

  int _radioValue = 0;

  var hri;
  DateTime dateTime = DateTime.now();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = new TimeOfDay.now();

  bool iscreambath;
  bool tampilsemua = false;
  bool buttonberubah = false;
  bool _like = false;

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

  void initState() {
    super.initState();
    setState(() {
      arr.add(new ClassListBookingWithLayanan(
          '1',
          'tanggal',
          'username',
          'namauser',
          'usernamesalon',
          'idservice',
          'tanggalbooking',
          'jambooking',
          'requestpegawai',
          'total',
          'namalayanan',
          'status',
          'pembayaran',
          "default.png",
          'jambookingselesai',
          "0",
          "",
          "jamres",
          "tglres",
          "statusreschedule",
          "jamresselesai"));
      arrsemua.add(new ClassListBookingWithLayanan(
          'id',
          'tanggal',
          'username',
          'namauser',
          'usernamesalon',
          'idservice',
          'tanggalbooking',
          'jambooking',
          'requestpegawai',
          'total',
          'namalayanan',
          'status',
          'pembayaran',
          "default.png",
          'jambookingselesai',
          "0",
          "",
          "jamres",
          "tglres",
          "statusreschedule",
          "jamresselesai"));
      arrcount.add(new ClassBookingService(
          "id",
          "tanggal",
          "username",
          "namauser",
          "usernamesalon",
          "0",
          "tanggalbooking",
          "jambooking",
          "jambookingselesai",
          "requestpegawai",
          "0",
          "usernamecancel",
          "status",
          "pembayaran",
          "jamres"));
    });
    print(arr.length.toString() + "aple");
    print(arrsemua.length.toString() + "nanas");
    getlistbookingsalon();
    getlistbookingsalonsemua();
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });

    String namaFile = image.path;
    String basenamegallery = basename(namaFile);
  }

  Future<String> update_status_reschedule() async {
    Map paramData = {
      'id': myidupdate,
      'status': mystatus,
      'statusreschedule': statusreschedule,
    };
    var parameter = json.encode(paramData);
    http
        .post(main_variable.ipnumber + "/updatestatusreschedule",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print("object" + res.body);
      var data = json.decode(res.body);
      var data1 = data[0]['bookinguser'];

      getlistbookingsalon();
      getlistbookingsalonsemua();

      return "";
    }).catchError((err) {
      print(err);
    });
  }

  Future<String> updatereschedule_salon() async {
    Map paramData = {
      'id': myidupdate,
      'status': myStatus.text,
      'usernamecancel': usernamecancel,
      'idservice': idservice,
      'tglres': myTgl.text,
      'jamres': myTime.text,
    };
    var parameter = json.encode(paramData);
    http
        .post(main_variable.ipnumber + "/updatereschedule_customer",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print("object" + res.body);
      var data = json.decode(res.body);
      var data1 = data[0]['bookinguser'];

      getlistbookingsalon();
      getlistbookingsalonsemua();

      return "";
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

  Future<ClassListBookingWithLayanan> getlistbookingsalon() async {
    List<ClassListBookingWithLayanan> arrtemp = new List();
    Map paramData = {
      'usernamesalon': main_variable.userlogin,
    };
    var parameter = json.encode(paramData);
    http
        .post(main_variable.ipnumber + "/getlistbookingwithlayanan",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      var data1 = data[0]['jumlah'];
      data = data[0]['status'];

      for (int i = 0; i < data.length; i++) {
        ClassListBookingWithLayanan databaru = new ClassListBookingWithLayanan(
            data[i]['id'].toString(),
            data[i]['tanggal'].toString(),
            data[i]['username'].toString(),
            data[i]['namauser'].toString(),
            data[i]['usenamesalon'].toString(),
            data[i]['idservice'].toString(),
            data[i]['tanggalbooking'].toString(),
            data[i]['jambooking'].toString(),
            data[i]['requestpegawai'].toString(),
            data[i]['total'].toString(),
            data[i]['namalayanan'].toString(),
            data[i]['status'].toString(),
            data[i]['pembayaran'].toString(),
            data[i]['foto'].toString(),
            data[i]['jambookingselesai'].toString(),
            data1[i].toString(),
            data[i]['kota'].toString(),
            data[i]['jamres'].toString(),
            data[i]['tglres'].toString(),
            data[i]['statusreschedule'].toString(),
            data[i]['jamresselesai'].toString());
        arrtemp.add(databaru);

        dateTime = DateTime.parse(arrtemp[i].tanggalbooking);
        hri = DateFormat('EEEE').format(dateTime);

        if (hri.toString() == "Monday") {
          hari = 'Senin, ';
          hri1.add(hari);
        } else if (hri.toString() == 'Tuesday') {
          hari = "Selasa, ";
          hri1.add(hari);
        } else if (hri.toString() == 'Wednesday') {
          hari = "Rabu, ";
          hri1.add(hari);
        } else if (hri.toString() == 'Thursday') {
          hari = "Kamis, ";
          hri1.add(hari);
        } else if (hri.toString() == 'Friday') {
          hari = "Jumat, ";
          hri1.add(hari);
        } else if (hri.toString() == 'Saturday') {
          hari = "Sabtu, ";
          hri1.add(hari);
        } else if (hri.toString() == 'Sunday') {
          hari = "Minggu, ";
          hri1.add(hari);
        }
      }
      setState(() => this.arr = arrtemp);
      //print("ini panjang arr" + this.arr.length.toString());
      print("panjang5" + arr.length.toString());
      print("panjang6" + arrsemua.length.toString());

      return arrtemp;
    }).catchError((err) {
      print(err);
    });
  }

  Future<String> getlistbookingsalonsemua() async {
    List<ClassListBookingWithLayanan> arrtemp1 = new List();
    Map paramData = {
      'usernamesalon': main_variable.userlogin,
    };
    var parameter = json.encode(paramData);
    http
        .post(main_variable.ipnumber + "/getlistbookingwithlayanansemua",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      //print(res.body.substring(100));
      print("ini jumlah : " + res.body.toString());
      var data = json.decode(res.body);
      var data1 = data[0]['jumlah'];
      data = data[0]['status'];

      for (int i = 0; i < data.length; i++) {
        ClassListBookingWithLayanan databaru = new ClassListBookingWithLayanan(
            data[i]['id'].toString(),
            data[i]['tanggal'].toString(),
            data[i]['username'].toString(),
            data[i]['namauser'].toString(),
            data[i]['usenamesalon'].toString(),
            data[i]['idservice'].toString(),
            data[i]['tanggalbooking'].toString(),
            data[i]['jambooking'].toString(),
            data[i]['requestpegawai'].toString(),
            data[i]['total'].toString(),
            data[i]['namalayanan'].toString(),
            data[i]['status'].toString(),
            data[i]['pembayaran'].toString(),
            data[i]['foto'].toString(),
            data[i]['jambookingselesai'].toString(),
            data1[i].toString(),
            data[i]['kota'].toString(),
            data[i]['jamres'].toString(),
            data[i]['tglres'].toString(),
            data[i]['statusreschedule'].toString(),
            data[i]['jamresselesai'].toString());
        arrtemp1.add(databaru);
        // myNamauser.text = arrsemua[i].namauser;
        dateTime = DateTime.parse(arrtemp1[i].tanggalbooking);
        print("ini jumlah " +
            i.toString() +
            ": " +
            arrtemp1[i].total_cancel.toString());

        hri = DateFormat('EEEE').format(dateTime);
        //print("hari : " + i.toString() + "-" + hri.toString());

        if (hri.toString() == "Monday") {
          hari = 'Senin, ';
          hri2.add(hari);
        } else if (hri.toString() == 'Tuesday') {
          hari = "Selasa, ";
          hri2.add(hari);
        } else if (hri.toString() == 'Wednesday') {
          hari = "Rabu, ";
          hri2.add(hari);
        } else if (hri.toString() == 'Thursday') {
          hari = "Kamis, ";
          hri2.add(hari);
        } else if (hri.toString() == 'Friday') {
          hari = "Jumat, ";
          hri2.add(hari);
        } else if (hri.toString() == 'Saturday') {
          hari = "Sabtu, ";
          hri2.add(hari);
        } else if (hri.toString() == 'Sunday') {
          hari = "Minggu, ";
          hri2.add(hari);
        }
      }
      setState(() => this.arrsemua = arrtemp1);
      print("panjang3" + arr.length.toString());
      print("panjang4" + arrsemua.length.toString());

      return arrtemp1;
    }).catchError((err) {
      print(err);
    });
  }

  Future<String> updatestatusbooking() async {
    List<ClassListBookingWithLayanan> temp1 = new List();
    List<ClassListBookingWithLayanan> temp2 = new List();
    Map paramData = {
      'id': myidupdate,
      'status': myStatus.text,
      'usernamecancel': usernamecancel,
      'usernamesalon': main_variable.userlogin,
    };
    var parameter = json.encode(paramData);
    //print(usernamecancel + "aaa");
    http
        .post(main_variable.ipnumber + "/updatestatusbooking",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print("object" + res.body);
      var data = json.decode(res.body);
      var data1 = data[0]['bookingharini'];
      data = data[0]['bookingsemua'];
      print("panjang1" + arr.length.toString());
      print("panjang2" + arrsemua.length.toString());

      getlistbookingsalon();
      getlistbookingsalonsemua();

      return "";
    }).catchError((err) {
      print(err);
    });
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      if (_radioValue == 0) {
        tampilsemua = false;
        print("tampilsemua : " + tampilsemua.toString());
        getlistbookingsalon();
      } else {
        tampilsemua = true;
        getlistbookingsalonsemua();
        print("tampilsemua : " + tampilsemua.toString());
      }
    });
  }

  tampilan_lihat_reschedule(context) {
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
              height: 320,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: Text(
                      'Reschedule Booking',
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
                    child: Text(
                      "*Request Reschedule sedang menunggu konfirmasi",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Tanggal Booking ",
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
                    padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: buildTextField(MaterialCommunityIcons.calendar,
                          "Tanggal", false, false, false, myTgl_temp),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Jam Booking  ",
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
                    padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: buildTextField(MaterialCommunityIcons.timer, "Jam",
                          false, false, false, myTime_temp),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(55, 20, 10, 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 140,
                          height: 35,
                          child: RaisedButton(
                            onPressed: () {
                              print("cancel");
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
                                  borderRadius: BorderRadius.circular(30.0)),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: 320.0, minHeight: 50.0),
                                alignment: Alignment.center,
                                child: Text(
                                  "Kembali",
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

  acc_lihat_reschedule(context) {
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
              height: 320,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: Text(
                      'Reschedule Booking',
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
                    margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Tanggal Booking ",
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
                    padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: buildTextField(MaterialCommunityIcons.calendar,
                          "Tanggal", false, false, false, myTgl_temp),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Jam Booking  ",
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
                    padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: buildTextField(MaterialCommunityIcons.timer, "Jam",
                          false, false, false, myTime_temp),
                    ),
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
                                  print("submit");
                                  mystatus = "terima";
                                  statusreschedule = "terima";
                                  update_status_reschedule();
                                  myTgl.text = "";
                                  myTime.text = "";
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
                                      "Terima",
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
                                  print("cancel");
                                  mystatus = "terima";
                                  statusreschedule = "tolak";
                                  update_status_reschedule();
                                  myTgl.text = "";
                                  myTime.text = "";
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
                                        maxWidth: 320.0, minHeight: 50.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Tolak",
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

  reschedule_popup(context) {
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
              height: 260,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: Text(
                      'Reschedule Booking',
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
                  Padding(
                    padding: EdgeInsets.only(left: 0, right: 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: Center(
                            child: TextFormField(
                              controller: myTgl,
                              decoration:
                                  InputDecoration(labelText: 'Tanggal Booking'),
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
                                      EdgeInsets.fromLTRB(0.0, 20.0, 0.0, .0),
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(0),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            blurRadius: 5,
                                            spreadRadius: 1)
                                      ]),
                                  child: Icon(
                                    Icons.date_range,
                                    size: 28,
                                    color:
                                        (_like) ? Colors.red : Colors.grey[600],
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
                    padding: EdgeInsets.only(left: 0, right: 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: Center(
                            child: TextFormField(
                              controller: myTime,
                              decoration:
                                  InputDecoration(labelText: 'Jam Booking'),
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
                                      EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(0),
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.5),
                                            blurRadius: 5,
                                            spreadRadius: 1)
                                      ]),
                                  child: Icon(
                                    Icons.timer,
                                    size: 28,
                                    color:
                                        (_like) ? Colors.red : Colors.grey[600],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                                  print("submit");
                                  //manggil future untuk reschedule
                                  updatereschedule_salon();
                                  print("status : " + myStatus.text);
                                  print("service : " + idservice);
                                  print("usernamecancel : " + usernamecancel);
                                  print("jamres : " + myTgl.text);
                                  print("tglres : " + myTime.text);
                                  print("id : " + myidupdate);
                                  myTgl.text = "";
                                  myTime.text = "";
                                  //Navigator.pop(this.context);
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
                                      "Submit",
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
                                  print("cancel");
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
                                        maxWidth: 320.0, minHeight: 50.0),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Cancel",
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
    double width = MediaQuery.of(context).size.width * 0.6;

    return Scaffold(
      appBar: AppBar(
        // App Bar
        centerTitle: true,
        title: Text(
          "List Booking",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          new Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              new Radio(
                value: 0,
                groupValue: _radioValue,
                onChanged: _handleRadioValueChange,
              ),
              new Text(
                'Tampilkan Hari ini',
                style:
                    new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              new Radio(
                value: 1,
                groupValue: _radioValue,
                onChanged: _handleRadioValueChange,
              ),
              new Text(
                'Tampilkan Semua List',
                style:
                    new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Text(
              "*Untuk mengkonfirmasi pesanan tekanlah data sedikit lama",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          //jika tampilsemua == false maka tampilkan yang hari ini saja
          tampilsemua == false
              ? SizedBox(
                  height: 645,
                  child: ListView.builder(
                      itemCount: arr.length == 0 ? 1 : arr.length,
                      itemBuilder: (BuildContext context, int index) => arr
                                  .length ==
                              0
                          ? Container(
                              child: Card(
                                elevation: 10,
                                shadowColor: Colors.black,
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 100),
                                      height: 350,
                                      width: 450,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "images/kosong.jpg"),
                                              fit: BoxFit.cover)),
                                      child: Container(),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(0, 10, 0, 200),
                                      child: Text(
                                          "Tidak ada jadwal booking hari ini",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          :
                          //ini kalau else item ada isinya maka simple if lagi untuk mengecek status aktif
                          arr[index].status == "pending" &&
                                  arr[index].statusreschedule ==
                                      "null" //|| arr[index].status == "pending" && arr[index].statusreschedule == "tolak"
                              ? Column(
                                  children: <Widget>[
                                    FocusedMenuHolder(
                                      blurSize: 4,
                                      blurBackgroundColor: Colors.black,
                                      menuBoxDecoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black,
                                                blurRadius: 1,
                                                spreadRadius: 1)
                                          ]),
                                      menuWidth:
                                          MediaQuery.of(context).size.width *
                                              0.6,
                                      duration: Duration(microseconds: 500),
                                      onPressed: () {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Tekan lebih lama untuk mengkonfirmasi pesanan",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.CENTER,
                                            backgroundColor: Colors.grey,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      },
                                      menuItems: <FocusedMenuItem>[
                                        FocusedMenuItem(
                                            title: Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: Text("Terima Booking",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17,
                                                    letterSpacing: 1,
                                                  )),
                                            ),
                                            onPressed: () {
                                              print("terima");
                                              myidupdate = arr[index].id;
                                              usernamecancel = "-";
                                              myStatus.text = "terima";
                                              updatestatusbooking();
                                              Fluttertoast.showToast(
                                                  msg: "Booking Telah Diterima",
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                  gravity: ToastGravity.CENTER,
                                                  backgroundColor:
                                                      Colors.blue[300],
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            },
                                            trailingIcon: Icon(
                                              Icons.follow_the_signs_sharp,
                                              color: Colors.white,
                                            ),
                                            backgroundColor: Colors.green),
                                        FocusedMenuItem(
                                            title: Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: Text("Tolak Booking",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17,
                                                    letterSpacing: 1,
                                                  )),
                                            ),
                                            onPressed: () {
                                              print("tolak");
                                              myidupdate = arr[index].id;
                                              usernamecancel = "-";
                                              myStatus.text = "tolak";
                                              updatestatusbooking();
                                              Fluttertoast.showToast(
                                                  msg: "Booking Telah Ditolak",
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                  gravity: ToastGravity.CENTER,
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            },
                                            trailingIcon: Icon(
                                              Icons.follow_the_signs_sharp,
                                              color: Colors.white,
                                            ),
                                            backgroundColor: Colors.redAccent),
                                      ],
                                      child: Card(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 6,
                                              //color: Colors.red,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        10, 0, 0, 0),
                                                    child: RichText(
                                                      maxLines: 1,
                                                      text: TextSpan(
                                                        text: arr[index]
                                                            .namauser
                                                            .capitalizeFirstofEach1,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 0, 0, 0),
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                          text: "Pegawai : ",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      RichText(
                                                        maxLines: 1,
                                                        text: TextSpan(
                                                          text: arr[index]
                                                              .requestpegawai
                                                              .capitalizeFirstofEach1,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        10, 10, 0, 0),
                                                    child: RichText(
                                                      maxLines: 1,
                                                      text: TextSpan(
                                                        text: arr[index]
                                                            .namalayanan
                                                            .capitalizeFirstofEach1,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            letterSpacing: 1.5,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 3, 0, 0),
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                          text: "Rp. " +
                                                              numberFormat.format(
                                                                  int.parse(arr[
                                                                          index]
                                                                      .total)),
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      RichText(
                                                        maxLines: 1,
                                                        text: TextSpan(
                                                          text: ",-   (" +
                                                              arr[index]
                                                                  .pembayaran
                                                                  .capitalizeFirstofEach1 +
                                                              ")",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 3, 0, 0),
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                          text: "Status : ",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      RichText(
                                                        maxLines: 1,
                                                        text: TextSpan(
                                                          text: arr[index]
                                                              .status
                                                              .capitalizeFirstofEach1,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            //ini garis tengah
                                            Container(
                                                //color: Colors.yellow,
                                                height: 120,
                                                child: VerticalDivider(
                                                    color: Colors.black)),
                                            Expanded(
                                              flex: 5,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        10, 0, 0, 0),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 10, 0, 0),
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                          text:
                                                              "Count Batal Hadir : ",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      RichText(
                                                        maxLines: 1,
                                                        text: TextSpan(
                                                          text: arr[index]
                                                              .total_cancel,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        10, 0, 0, 0),
                                                    child: RichText(
                                                      maxLines: 1,
                                                      text: TextSpan(
                                                        text: "Hari Booking",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        10, 0, 0, 10),
                                                    child: RichText(
                                                      maxLines: 1,
                                                      text: TextSpan(
                                                        text: hri1[index]
                                                                .toString() +
                                                            arr[index]
                                                                .tanggalbooking,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        10, 0, 0, 5),
                                                    child: RichText(
                                                      maxLines: 1,
                                                      text: TextSpan(
                                                        text: "Jam Booking",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 10, 0, 0),
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                          text: arr[index]
                                                                  .jambooking +
                                                              "  -  ",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      RichText(
                                                        maxLines: 1,
                                                        text: TextSpan(
                                                          text: arr[index]
                                                              .jambookingselesai,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              //INI TAMPILAN HARI INI YANG STATUS NYA TERIMA/RESCHEDULE BY SALON DAN STATUS RESCHEDULE NYA ADALAH PENDING
                              //tampilan ini ditujukan salon untuk req reschedule ke user (CUMA REQ)
                              : arr[index].status == 'terima' &&
                                          arr[index].statusreschedule ==
                                              "null" ||
                                      arr[index].status == "terima" &&
                                          arr[index].statusreschedule == "tolak"
                                  ?

                                  //ini untuk status terima
                                  Column(
                                      children: <Widget>[
                                        FocusedMenuHolder(
                                          blurSize: 4,
                                          blurBackgroundColor: Colors.black,
                                          menuBoxDecoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black,
                                                    blurRadius: 1,
                                                    spreadRadius: 1)
                                              ]),
                                          menuWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          duration: Duration(microseconds: 500),
                                          onPressed: () {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Tekan lebih lama untuk mengkonfirmasi pesanan",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.CENTER,
                                                backgroundColor: Colors.grey,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          },
                                          menuItems: <FocusedMenuItem>[
                                            FocusedMenuItem(
                                                title: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 10),
                                                  child: Text("Customer Datang",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 17,
                                                        letterSpacing: 1,
                                                      )),
                                                ),
                                                onPressed: () {
                                                  print("terima");
                                                  myidupdate = arr[index].id;
                                                  usernamecancel = "-";
                                                  myStatus.text = "terima";
                                                  updatestatusbooking();
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Booking Telah Diterima",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                      backgroundColor:
                                                          Colors.blue[300],
                                                      textColor: Colors.black,
                                                      fontSize: 16.0);
                                                },
                                                trailingIcon: Icon(
                                                  Icons.follow_the_signs_sharp,
                                                  color: Colors.white,
                                                ),
                                                backgroundColor:
                                                    Colors.blueAccent),
                                            FocusedMenuItem(
                                                title: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 10),
                                                  child:
                                                      Text("Reschedule Booking",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 17,
                                                            letterSpacing: 1,
                                                          )),
                                                ),
                                                onPressed: () {
                                                  print("reschedule");
                                                  myStatus.text =
                                                      "reschedulesalon";
                                                  myidupdate = arr[index].id;
                                                  usernamecancel = "-";
                                                  idservice =
                                                      arr[index].idservice;
                                                  reschedule_popup(
                                                      this.context);
                                                },
                                                trailingIcon: Icon(
                                                  Icons.follow_the_signs_sharp,
                                                  color: Colors.white,
                                                ),
                                                backgroundColor:
                                                    Colors.orangeAccent),
                                            FocusedMenuItem(
                                                title: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 10),
                                                  child: Text(
                                                      "Customer Tidak Datang",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 17,
                                                        letterSpacing: 1,
                                                      )),
                                                ),
                                                onPressed: () {
                                                  print("tidak datang");
                                                  myidupdate = arr[index].id;
                                                  myStatus.text =
                                                      "tidak datang";
                                                  usernamecancel =
                                                      arr[index].username;
                                                  updatestatusbooking();
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Booking Telah Dihapus, Customer Tidak Datang",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                },
                                                trailingIcon: Icon(
                                                  Icons.follow_the_signs_sharp,
                                                  color: Colors.white,
                                                ),
                                                backgroundColor:
                                                    Colors.redAccent),
                                            FocusedMenuItem(
                                                title: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 10),
                                                  child: Text("Chat Customer",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 17,
                                                        letterSpacing: 1,
                                                      )),
                                                ),
                                                onPressed: () {
                                                  print("chat customer");

                                                  Fluttertoast.showToast(
                                                      msg: "Ini Chat Customer",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                },
                                                trailingIcon: Icon(
                                                  Icons.follow_the_signs_sharp,
                                                  color: Colors.white,
                                                ),
                                                backgroundColor:
                                                    Colors.grey[600]),
                                            FocusedMenuItem(
                                                title: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 10),
                                                  child: Text("Cancel Booking",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 17,
                                                        letterSpacing: 1,
                                                      )),
                                                ),
                                                onPressed: () {
                                                  print("cancel booking");
                                                  myidupdate = arr[index].id;
                                                  myStatus.text = "cancel";
                                                  usernamecancel =
                                                      arr[index].requestpegawai;
                                                  updatestatusbooking();
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Booking Telah Di Cancel",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                },
                                                trailingIcon: Icon(
                                                  Icons.follow_the_signs_sharp,
                                                  color: Colors.white,
                                                ),
                                                backgroundColor:
                                                    Colors.redAccent),
                                          ],
                                          child: Card(
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 6,
                                                  //color: Colors.red,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 10, 0, 0),
                                                        child: RichText(
                                                          maxLines: 1,
                                                          text: TextSpan(
                                                            text: arr[index]
                                                                .namauser
                                                                .capitalizeFirstofEach1,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(10, 0,
                                                                    0, 0),
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              text:
                                                                  "Pegawai : ",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          RichText(
                                                            maxLines: 1,
                                                            text: TextSpan(
                                                              text: arr[index]
                                                                  .requestpegawai
                                                                  .capitalizeFirstofEach1,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 10, 0, 0),
                                                        child: RichText(
                                                          maxLines: 1,
                                                          text: TextSpan(
                                                            text: arr[index]
                                                                .namalayanan
                                                                .capitalizeFirstofEach1,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                letterSpacing:
                                                                    1.5,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(10, 3,
                                                                    0, 0),
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              text: "Rp. " +
                                                                  numberFormat.format(
                                                                      int.parse(
                                                                          arr[index]
                                                                              .total)),
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          RichText(
                                                            maxLines: 1,
                                                            text: TextSpan(
                                                              text: ",-   (" +
                                                                  arr[index]
                                                                      .pembayaran
                                                                      .capitalizeFirstofEach1 +
                                                                  ")",
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(10, 3,
                                                                    0, 0),
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              text: "Status : ",
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          RichText(
                                                            maxLines: 1,
                                                            text: TextSpan(
                                                              text: arr[index]
                                                                  .status
                                                                  .capitalizeFirstofEach1,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                          .green[
                                                                      800]),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                //ini garis tengah
                                                Container(
                                                    //color: Colors.yellow,
                                                    height: 130,
                                                    child: VerticalDivider(
                                                        color: Colors.black)),
                                                Expanded(
                                                  flex: 5,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 0, 0, 10),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(10, 0,
                                                                    0, 0),
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              text:
                                                                  "Count Batal Hadir : ",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          RichText(
                                                            maxLines: 1,
                                                            text: TextSpan(
                                                              text: arr[index]
                                                                  .total_cancel,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 0, 0, 0),
                                                        child: RichText(
                                                          maxLines: 1,
                                                          text: TextSpan(
                                                            text:
                                                                "Hari Booking",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 0, 0, 10),
                                                        child: RichText(
                                                          maxLines: 1,
                                                          text: TextSpan(
                                                            text: hri1[index]
                                                                    .toString() +
                                                                arr[index]
                                                                    .tanggalbooking,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 0, 0, 5),
                                                        child: RichText(
                                                          maxLines: 1,
                                                          text: TextSpan(
                                                            text: "Jam Booking",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(10,
                                                                    10, 0, 0),
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              text: arr[index]
                                                                      .jambooking +
                                                                  "  -  ",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          RichText(
                                                            maxLines: 1,
                                                            text: TextSpan(
                                                              text: arr[index]
                                                                  .jambookingselesai,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black),
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
                                        ),
                                      ],
                                    )
                                  //INI TAMPILAN HARI INI YANG STATUSNYA RESCHEDULE BY USER DAN STATUS RESCHEDULE NYA PENDING MAKA ACC
                                  : arr[index].status == "rescheduleuser" &&
                                          arr[index].statusreschedule ==
                                              "pending"
                                      ? Column(
                                          children: <Widget>[
                                            FocusedMenuHolder(
                                              blurSize: 4,
                                              blurBackgroundColor: Colors.black,
                                              menuBoxDecoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black,
                                                        blurRadius: 1,
                                                        spreadRadius: 1)
                                                  ]),
                                              menuWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              duration:
                                                  Duration(microseconds: 500),
                                              onPressed: () {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Tekan lebih lama untuk mengkonfirmasi pesanan",
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                    backgroundColor:
                                                        Colors.grey,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              },
                                              menuItems: <FocusedMenuItem>[
                                                FocusedMenuItem(
                                                    title: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10),
                                                      child: Text(
                                                          "Lihat Reschedule",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 17,
                                                            letterSpacing: 1,
                                                          )),
                                                    ),
                                                    onPressed: () {
                                                      print("acc reschedule");
                                                      myTgl_temp.text =
                                                          arr[index].jamres;
                                                      myTime_temp.text =
                                                          arr[index].tglres;
                                                      myidupdate =
                                                          arr[index].id;
                                                      print(arr[index].jamres);
                                                      print(arr[index].tglres);
                                                      acc_lihat_reschedule(
                                                          context);
                                                    },
                                                    trailingIcon: Icon(
                                                      Icons
                                                          .follow_the_signs_sharp,
                                                      color: Colors.white,
                                                    ),
                                                    backgroundColor:
                                                        Colors.blueAccent),
                                                FocusedMenuItem(
                                                    title: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10),
                                                      child: Text(
                                                          "Cancel Booking",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 17,
                                                            letterSpacing: 1,
                                                          )),
                                                    ),
                                                    onPressed: () {
                                                      print("cancel booking");
                                                      myidupdate =
                                                          arr[index].id;
                                                      myStatus.text = "cancel";
                                                      usernamecancel =
                                                          arr[index]
                                                              .requestpegawai;
                                                      updatestatusbooking();
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Booking Telah Cancel",
                                                          toastLength:
                                                              Toast.LENGTH_LONG,
                                                          gravity: ToastGravity
                                                              .CENTER,
                                                          backgroundColor:
                                                              Colors.redAccent,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0);
                                                    },
                                                    trailingIcon: Icon(
                                                      Icons
                                                          .follow_the_signs_sharp,
                                                      color: Colors.white,
                                                    ),
                                                    backgroundColor:
                                                        Colors.redAccent),
                                              ],
                                              child: Card(
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 6,
                                                      //color: Colors.red,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(10,
                                                                    10, 0, 0),
                                                            child: RichText(
                                                              maxLines: 1,
                                                              text: TextSpan(
                                                                text: arr[index]
                                                                    .namauser
                                                                    .capitalizeFirstofEach1,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        10,
                                                                        0,
                                                                        0,
                                                                        0),
                                                              ),
                                                              RichText(
                                                                text: TextSpan(
                                                                  text:
                                                                      "Pegawai : ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                              RichText(
                                                                maxLines: 1,
                                                                text: TextSpan(
                                                                  text: arr[
                                                                          index]
                                                                      .requestpegawai
                                                                      .capitalizeFirstofEach1,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(10,
                                                                    10, 0, 0),
                                                            child: RichText(
                                                              maxLines: 1,
                                                              text: TextSpan(
                                                                text: arr[index]
                                                                    .namalayanan
                                                                    .capitalizeFirstofEach1,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    letterSpacing:
                                                                        1.5,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        10,
                                                                        3,
                                                                        0,
                                                                        0),
                                                              ),
                                                              RichText(
                                                                text: TextSpan(
                                                                  text: "Rp. " +
                                                                      numberFormat
                                                                          .format(
                                                                              int.parse(arr[index].total)),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                              RichText(
                                                                maxLines: 1,
                                                                text: TextSpan(
                                                                  text: ",-   (" +
                                                                      arr[index]
                                                                          .pembayaran
                                                                          .capitalizeFirstofEach1 +
                                                                      ")",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        10,
                                                                        3,
                                                                        0,
                                                                        0),
                                                              ),
                                                              RichText(
                                                                text: TextSpan(
                                                                  text:
                                                                      "Status : ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                              RichText(
                                                                maxLines: 1,
                                                                text: TextSpan(
                                                                  text: arr[index]
                                                                              .status ==
                                                                          "rescheduleuser"
                                                                      ? "Reschedule (Pending)"
                                                                      : "",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                              .green[
                                                                          800]),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    //ini garis tengah
                                                    Container(
                                                        //color: Colors.yellow,
                                                        height: 130,
                                                        child: VerticalDivider(
                                                            color:
                                                                Colors.black)),
                                                    Expanded(
                                                      flex: 5,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(10, 0,
                                                                    0, 10),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        10,
                                                                        0,
                                                                        0,
                                                                        0),
                                                              ),
                                                              RichText(
                                                                text: TextSpan(
                                                                  text:
                                                                      "Count Batal Hadir : ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                              RichText(
                                                                maxLines: 1,
                                                                text: TextSpan(
                                                                  text: arr[
                                                                          index]
                                                                      .total_cancel,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(10, 0,
                                                                    0, 0),
                                                            child: RichText(
                                                              maxLines: 1,
                                                              text: TextSpan(
                                                                text:
                                                                    "Hari Booking",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(10, 0,
                                                                    0, 10),
                                                            child: RichText(
                                                              maxLines: 1,
                                                              text: TextSpan(
                                                                text: hri1[index]
                                                                        .toString() +
                                                                    arr[index]
                                                                        .tanggalbooking,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(10, 0,
                                                                    0, 5),
                                                            child: RichText(
                                                              maxLines: 1,
                                                              text: TextSpan(
                                                                text:
                                                                    "Jam Booking",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        10,
                                                                        10,
                                                                        0,
                                                                        0),
                                                              ),
                                                              RichText(
                                                                text: TextSpan(
                                                                  text: arr[index]
                                                                          .jambooking +
                                                                      "  -  ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                              RichText(
                                                                maxLines: 1,
                                                                text: TextSpan(
                                                                  text: arr[
                                                                          index]
                                                                      .jambookingselesai,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .black),
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
                                            ),
                                          ],
                                        )
                                      //INI TAMPILAN HARI INI YANG STATUSNYA RESCHEDULE BY SALON DAN STATUS RESCHEDULE NYA PENDING MAKA LIHAT RESCH TUNGGU ACC DARI CUSTOMER
                                      : arr[index].status ==
                                                  "reschedulesalon" &&
                                              arr[index].statusreschedule ==
                                                  "pending"
                                          ? Column(
                                              children: <Widget>[
                                                FocusedMenuHolder(
                                                  blurSize: 4,
                                                  blurBackgroundColor:
                                                      Colors.black,
                                                  menuBoxDecoration:
                                                      BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black,
                                                            blurRadius: 1,
                                                            spreadRadius: 1)
                                                      ]),
                                                  menuWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.7,
                                                  duration: Duration(
                                                      microseconds: 500),
                                                  onPressed: () {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Tekan lebih lama untuk mengkonfirmasi pesanan",
                                                        toastLength:
                                                            Toast.LENGTH_LONG,
                                                        gravity:
                                                            ToastGravity.CENTER,
                                                        backgroundColor:
                                                            Colors.grey,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                  },
                                                  menuItems: <FocusedMenuItem>[
                                                    FocusedMenuItem(
                                                        title: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: Text(
                                                              "Lihat Reschedule",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 17,
                                                                letterSpacing:
                                                                    1,
                                                              )),
                                                        ),
                                                        onPressed: () {
                                                          print(
                                                              "lihat res reschedule");
                                                          myTime_temp.text =
                                                              arr[index].jamres;
                                                          myTgl_temp.text =
                                                              arr[index].tglres;
                                                          print(arr[index]
                                                              .jamres);
                                                          print(arr[index]
                                                              .tglres);
                                                          tampilan_lihat_reschedule(
                                                              context);
                                                        },
                                                        trailingIcon: Icon(
                                                          Icons
                                                              .follow_the_signs_sharp,
                                                          color: Colors.white,
                                                        ),
                                                        backgroundColor:
                                                            Colors.blueAccent),
                                                    FocusedMenuItem(
                                                        title: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: Text(
                                                              "Cancel Booking",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 17,
                                                                letterSpacing:
                                                                    1,
                                                              )),
                                                        ),
                                                        onPressed: () {
                                                          print(
                                                              "cancel booking");
                                                          myidupdate =
                                                              arr[index].id;
                                                          myStatus.text =
                                                              "cancel";
                                                          usernamecancel = arr[
                                                                  index]
                                                              .requestpegawai;
                                                          updatestatusbooking();
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Booking Telah Cancel",
                                                              toastLength: Toast
                                                                  .LENGTH_LONG,
                                                              gravity:
                                                                  ToastGravity
                                                                      .CENTER,
                                                              backgroundColor:
                                                                  Colors
                                                                      .redAccent,
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 16.0);
                                                        },
                                                        trailingIcon: Icon(
                                                          Icons
                                                              .follow_the_signs_sharp,
                                                          color: Colors.white,
                                                        ),
                                                        backgroundColor:
                                                            Colors.redAccent),
                                                  ],
                                                  child: Card(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          flex: 6,
                                                          //color: Colors.red,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        10,
                                                                        10,
                                                                        0,
                                                                        0),
                                                                child: RichText(
                                                                  maxLines: 1,
                                                                  text:
                                                                      TextSpan(
                                                                    text: arr[
                                                                            index]
                                                                        .namauser
                                                                        .capitalizeFirstofEach1,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                  ),
                                                                  RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      text:
                                                                          "Pegawai : ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                  RichText(
                                                                    maxLines: 1,
                                                                    text:
                                                                        TextSpan(
                                                                      text: arr[
                                                                              index]
                                                                          .requestpegawai
                                                                          .capitalizeFirstofEach1,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        10,
                                                                        10,
                                                                        0,
                                                                        0),
                                                                child: RichText(
                                                                  maxLines: 1,
                                                                  text:
                                                                      TextSpan(
                                                                    text: arr[
                                                                            index]
                                                                        .namalayanan
                                                                        .capitalizeFirstofEach1,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        letterSpacing:
                                                                            1.5,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            3,
                                                                            0,
                                                                            0),
                                                                  ),
                                                                  RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      text: "Rp. " +
                                                                          numberFormat
                                                                              .format(int.parse(arr[index].total)),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                  RichText(
                                                                    maxLines: 1,
                                                                    text:
                                                                        TextSpan(
                                                                      text: ",-   (" +
                                                                          arr[index]
                                                                              .pembayaran
                                                                              .capitalizeFirstofEach1 +
                                                                          ")",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            3,
                                                                            0,
                                                                            0),
                                                                  ),
                                                                  RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      text:
                                                                          "Status : ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                  RichText(
                                                                    maxLines: 1,
                                                                    text:
                                                                        TextSpan(
                                                                      text: arr[index].status ==
                                                                              "reschedulesalon"
                                                                          ? "Reschedule (Pending)"
                                                                          : "",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.green[800]),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        //ini garis tengah
                                                        Container(
                                                            //color: Colors.yellow,
                                                            height: 130,
                                                            child:
                                                                VerticalDivider(
                                                                    color: Colors
                                                                        .black)),
                                                        Expanded(
                                                          flex: 5,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        10,
                                                                        0,
                                                                        0,
                                                                        10),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                  ),
                                                                  RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      text:
                                                                          "Count Batal Hadir : ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                  RichText(
                                                                    maxLines: 1,
                                                                    text:
                                                                        TextSpan(
                                                                      text: arr[
                                                                              index]
                                                                          .total_cancel,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        10,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                child: RichText(
                                                                  maxLines: 1,
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        "Hari Booking",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        10,
                                                                        0,
                                                                        0,
                                                                        10),
                                                                child: RichText(
                                                                  maxLines: 1,
                                                                  text:
                                                                      TextSpan(
                                                                    text: hri1[index]
                                                                            .toString() +
                                                                        arr[index]
                                                                            .tanggalbooking,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        10,
                                                                        0,
                                                                        0,
                                                                        5),
                                                                child: RichText(
                                                                  maxLines: 1,
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        "Jam Booking",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            10,
                                                                            0,
                                                                            0),
                                                                  ),
                                                                  RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      text: arr[index]
                                                                              .jambooking +
                                                                          "  -  ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                  RichText(
                                                                    maxLines: 1,
                                                                    text:
                                                                        TextSpan(
                                                                      text: arr[
                                                                              index]
                                                                          .jambookingselesai,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color:
                                                                              Colors.black),
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
                                                ),
                                              ],
                                            )
                                          //INI TAMPILAN HARI INI YANG STATUSNYA RESCHEDULE BY USER(SUDAH KETERIMA MAKA STATUS NYA TERIMA) DAN STATUS RESCHEDULE TERIMA
                                          : arr[index].status == "terima" &&
                                                  arr[index].statusreschedule ==
                                                      "terima"
                                              ? Column(
                                                  children: <Widget>[
                                                    FocusedMenuHolder(
                                                      blurSize: 4,
                                                      blurBackgroundColor:
                                                          Colors.black,
                                                      menuBoxDecoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .black,
                                                                blurRadius: 1,
                                                                spreadRadius: 1)
                                                          ]),
                                                      menuWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                      duration: Duration(
                                                          microseconds: 500),
                                                      onPressed: () {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Tekan lebih lama untuk mengkonfirmasi pesanan",
                                                            toastLength: Toast
                                                                .LENGTH_LONG,
                                                            gravity:
                                                                ToastGravity
                                                                    .CENTER,
                                                            backgroundColor:
                                                                Colors.grey,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 16.0);
                                                      },
                                                      menuItems: <
                                                          FocusedMenuItem>[
                                                        FocusedMenuItem(
                                                            title: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 10),
                                                              child: Text(
                                                                  "Reschedule Booking",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        17,
                                                                    letterSpacing:
                                                                        1,
                                                                  )),
                                                            ),
                                                            onPressed: () {
                                                              print(
                                                                  "reschedule booking");
                                                              idservice = arr[
                                                                      index]
                                                                  .idservice;
                                                              myidupdate =
                                                                  arr[index].id;
                                                              usernamecancel =
                                                                  "-";
                                                              //updatestatusbooking();
                                                              print(idservice +
                                                                  "  bbbbb");
                                                              reschedule_popup(
                                                                  context);
                                                            },
                                                            trailingIcon: Icon(
                                                              Icons
                                                                  .follow_the_signs_sharp,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            backgroundColor:
                                                                Colors
                                                                    .blueAccent),
                                                        FocusedMenuItem(
                                                            title: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 10),
                                                              child: Text(
                                                                  "Cancel Booking",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        17,
                                                                    letterSpacing:
                                                                        1,
                                                                  )),
                                                            ),
                                                            onPressed: () {
                                                              print(
                                                                  "cancel booking");
                                                              myidupdate =
                                                                  arr[index].id;
                                                              myStatus.text =
                                                                  "cancel";
                                                              usernamecancel = arr[
                                                                      index]
                                                                  .requestpegawai;
                                                              updatestatusbooking();
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Booking Telah Di Cancel",
                                                                  toastLength: Toast
                                                                      .LENGTH_LONG,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .CENTER,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .redAccent,
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  fontSize:
                                                                      16.0);
                                                            },
                                                            trailingIcon: Icon(
                                                              Icons
                                                                  .follow_the_signs_sharp,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            backgroundColor:
                                                                Colors
                                                                    .redAccent),
                                                      ],
                                                      child: Card(
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              flex: 6,
                                                              //color: Colors.red,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            10,
                                                                            0,
                                                                            0),
                                                                    child:
                                                                        RichText(
                                                                      maxLines:
                                                                          1,
                                                                      text:
                                                                          TextSpan(
                                                                        text: arr[index]
                                                                            .namauser
                                                                            .capitalizeFirstofEach1,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                      ),
                                                                      RichText(
                                                                        text:
                                                                            TextSpan(
                                                                          text:
                                                                              "Pegawai : ",
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      RichText(
                                                                        maxLines:
                                                                            1,
                                                                        text:
                                                                            TextSpan(
                                                                          text: arr[index]
                                                                              .requestpegawai
                                                                              .capitalizeFirstofEach1,
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            10,
                                                                            0,
                                                                            0),
                                                                    child:
                                                                        RichText(
                                                                      maxLines:
                                                                          1,
                                                                      text:
                                                                          TextSpan(
                                                                        text: arr[index]
                                                                            .namalayanan
                                                                            .capitalizeFirstofEach1,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            letterSpacing:
                                                                                1.5,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            10,
                                                                            3,
                                                                            0,
                                                                            0),
                                                                      ),
                                                                      RichText(
                                                                        text:
                                                                            TextSpan(
                                                                          text: "Rp. " +
                                                                              numberFormat.format(int.parse(arr[index].total)),
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      RichText(
                                                                        maxLines:
                                                                            1,
                                                                        text:
                                                                            TextSpan(
                                                                          text: ",-   (" +
                                                                              arr[index].pembayaran.capitalizeFirstofEach1 +
                                                                              ")",
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            10,
                                                                            3,
                                                                            0,
                                                                            0),
                                                                      ),
                                                                      RichText(
                                                                        text:
                                                                            TextSpan(
                                                                          text:
                                                                              "Status : ",
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      RichText(
                                                                        maxLines:
                                                                            1,
                                                                        text:
                                                                            TextSpan(
                                                                          text: arr[index].status == "terima"
                                                                              ? "Terima"
                                                                              : "",
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.green[800]),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            //ini garis tengah
                                                            Container(
                                                                //color: Colors.yellow,
                                                                height: 130,
                                                                child: VerticalDivider(
                                                                    color: Colors
                                                                        .black)),
                                                            Expanded(
                                                              flex: 5,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            10),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                      ),
                                                                      RichText(
                                                                        text:
                                                                            TextSpan(
                                                                          text:
                                                                              "Count Batal Hadir : ",
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      RichText(
                                                                        maxLines:
                                                                            1,
                                                                        text:
                                                                            TextSpan(
                                                                          text:
                                                                              arr[index].total_cancel,
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: Colors.red),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                    child:
                                                                        RichText(
                                                                      maxLines:
                                                                          1,
                                                                      text:
                                                                          TextSpan(
                                                                        text:
                                                                            "Hari Booking",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            10),
                                                                    child:
                                                                        RichText(
                                                                      maxLines:
                                                                          1,
                                                                      text:
                                                                          TextSpan(
                                                                        text: hri1[index].toString() +
                                                                            arr[index].tglres,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            5),
                                                                    child:
                                                                        RichText(
                                                                      maxLines:
                                                                          1,
                                                                      text:
                                                                          TextSpan(
                                                                        text:
                                                                            "Jam Booking",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            10,
                                                                            10,
                                                                            0,
                                                                            0),
                                                                      ),
                                                                      RichText(
                                                                        text:
                                                                            TextSpan(
                                                                          text: arr[index].jamres +
                                                                              "  -  ",
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      RichText(
                                                                        maxLines:
                                                                            1,
                                                                        text:
                                                                            TextSpan(
                                                                          text:
                                                                              arr[index].jamresselesai,
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: Colors.black),
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
                                                    ),
                                                  ],
                                                )
                                              //INI BUAT STATUS TOLAK SUPAYA TIDAK DITAMPILKAN
                                              : arr[index].status == 'datang'
                                                  ? Column(
                                                      children: <Widget>[
                                                        FocusedMenuHolder(
                                                          blurSize: 4,
                                                          blurBackgroundColor:
                                                              Colors.black,
                                                          menuBoxDecoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(10)),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .black,
                                                                    blurRadius:
                                                                        1,
                                                                    spreadRadius:
                                                                        1)
                                                              ]),
                                                          menuWidth:
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.7,
                                                          duration: Duration(
                                                              microseconds:
                                                                  500),
                                                          onPressed: () {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Tekan lebih lama untuk mengkonfirmasi pesanan",
                                                                toastLength: Toast
                                                                    .LENGTH_LONG,
                                                                gravity:
                                                                    ToastGravity
                                                                        .CENTER,
                                                                backgroundColor:
                                                                    Colors.grey,
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 16.0);
                                                          },
                                                          menuItems: <
                                                              FocusedMenuItem>[
                                                            FocusedMenuItem(
                                                                title:
                                                                    Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10),
                                                                  child: Text(
                                                                      "Layanan Selesai",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            17,
                                                                        letterSpacing:
                                                                            1,
                                                                      )),
                                                                ),
                                                                onPressed: () {
                                                                  print(
                                                                      "ini ini selesai");
                                                                  myidupdate =
                                                                      arr[index]
                                                                          .id;
                                                                  myStatus.text =
                                                                      "selesai";
                                                                  usernamecancel =
                                                                      "-";
                                                                  updatestatusbooking();
                                                                  Fluttertoast.showToast(
                                                                      msg:
                                                                          "1 Booking Layanan Telah Selesai",
                                                                      toastLength:
                                                                          Toast
                                                                              .LENGTH_LONG,
                                                                      gravity:
                                                                          ToastGravity
                                                                              .CENTER,
                                                                      backgroundColor:
                                                                          Colors.blue[
                                                                              300],
                                                                      textColor:
                                                                          Colors
                                                                              .black,
                                                                      fontSize:
                                                                          16.0);
                                                                },
                                                                trailingIcon:
                                                                    Icon(
                                                                  Icons
                                                                      .follow_the_signs_sharp,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                backgroundColor:
                                                                    Colors
                                                                        .blueAccent),
                                                          ],
                                                          child: Card(
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Expanded(
                                                                  flex: 6,
                                                                  //color: Colors.red,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            10,
                                                                            10,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            RichText(
                                                                          maxLines:
                                                                              1,
                                                                          text:
                                                                              TextSpan(
                                                                            text:
                                                                                arr[index].namauser.capitalizeFirstofEach1,
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
                                                                                10,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                          ),
                                                                          RichText(
                                                                            text:
                                                                                TextSpan(
                                                                              text: "Pegawai : ",
                                                                              style: TextStyle(fontSize: 14, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                          RichText(
                                                                            maxLines:
                                                                                1,
                                                                            text:
                                                                                TextSpan(
                                                                              text: arr[index].requestpegawai.capitalizeFirstofEach1,
                                                                              style: TextStyle(fontSize: 15, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Container(
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            10,
                                                                            10,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            RichText(
                                                                          maxLines:
                                                                              1,
                                                                          text:
                                                                              TextSpan(
                                                                            text:
                                                                                arr[index].namalayanan.capitalizeFirstofEach1,
                                                                            style: TextStyle(
                                                                                fontSize: 15,
                                                                                letterSpacing: 1.5,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                            margin: EdgeInsets.fromLTRB(
                                                                                10,
                                                                                3,
                                                                                0,
                                                                                0),
                                                                          ),
                                                                          RichText(
                                                                            text:
                                                                                TextSpan(
                                                                              text: "Rp. " + numberFormat.format(int.parse(arr[index].total)),
                                                                              style: TextStyle(fontSize: 15, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                          RichText(
                                                                            maxLines:
                                                                                1,
                                                                            text:
                                                                                TextSpan(
                                                                              text: ",-   (" + arr[index].pembayaran.capitalizeFirstofEach1 + ")",
                                                                              style: TextStyle(fontSize: 15, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                            margin: EdgeInsets.fromLTRB(
                                                                                10,
                                                                                3,
                                                                                0,
                                                                                0),
                                                                          ),
                                                                          RichText(
                                                                            text:
                                                                                TextSpan(
                                                                              text: "Status : ",
                                                                              style: TextStyle(fontSize: 15, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                          RichText(
                                                                            maxLines:
                                                                                1,
                                                                            text:
                                                                                TextSpan(
                                                                              text: arr[index].status.capitalizeFirstofEach1,
                                                                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                                //ini garis tengah
                                                                Container(
                                                                    //color: Colors.yellow,
                                                                    height: 130,
                                                                    child: VerticalDivider(
                                                                        color: Colors
                                                                            .black)),
                                                                Expanded(
                                                                  flex: 5,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                            margin: EdgeInsets.fromLTRB(
                                                                                10,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                          ),
                                                                          RichText(
                                                                            text:
                                                                                TextSpan(
                                                                              text: "Count Batal Hadir : ",
                                                                              style: TextStyle(fontSize: 14, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                          RichText(
                                                                            maxLines:
                                                                                1,
                                                                            text:
                                                                                TextSpan(
                                                                              text: arr[index].total_cancel,
                                                                              style: TextStyle(fontSize: 15, color: Colors.red),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Container(
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            RichText(
                                                                          maxLines:
                                                                              1,
                                                                          text:
                                                                              TextSpan(
                                                                            text:
                                                                                "Hari Booking",
                                                                            style: TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            10),
                                                                        child:
                                                                            RichText(
                                                                          maxLines:
                                                                              1,
                                                                          text:
                                                                              TextSpan(
                                                                            text:
                                                                                hri1[index].toString() + arr[index].tanggalbooking,
                                                                            style:
                                                                                TextStyle(fontSize: 15, color: Colors.black),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            5),
                                                                        child:
                                                                            RichText(
                                                                          maxLines:
                                                                              1,
                                                                          text:
                                                                              TextSpan(
                                                                            text:
                                                                                "Jam Booking",
                                                                            style: TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                            margin: EdgeInsets.fromLTRB(
                                                                                10,
                                                                                10,
                                                                                0,
                                                                                0),
                                                                          ),
                                                                          RichText(
                                                                            text:
                                                                                TextSpan(
                                                                              text: arr[index].jambooking + "  -  ",
                                                                              style: TextStyle(fontSize: 14, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                          RichText(
                                                                            maxLines:
                                                                                1,
                                                                            text:
                                                                                TextSpan(
                                                                              text: arr[index].jambookingselesai,
                                                                              style: TextStyle(fontSize: 15, color: Colors.black),
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
                                                        ),
                                                      ],
                                                    )
                                                  : SizedBox()),
                )
              //jika tampilsemua == true maka tampilkan semua
              //jika tampilsemua == true maka tampilkan semua
              //jika tampilsemua == true maka tampilkan semua
              //jika tampilsemua == true maka tampilkan semua
              //jika tampilsemua == true maka tampilkan semua
              //jika tampilsemua == true maka tampilkan semua
              //jika tampilsemua == true maka tampilkan semua
              //jika tampilsemua == true maka tampilkan semua
              //jika tampilsemua == true maka tampilkan semua
              //jika tampilsemua == true maka tampilkan semua
              //jika tampilsemua == true maka tampilkan semua
              : SizedBox(
                  height: 645,
                  child: ListView.builder(
                      itemCount: arrsemua.length == 0 ? 1 : arrsemua.length,
                      itemBuilder: (BuildContext context, int index) => arrsemua
                                  .length ==
                              0
                          ? Container(
                              child: Card(
                                elevation: 10,
                                shadowColor: Colors.black,
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 100),
                                      height: 350,
                                      width: 450,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "images/kosong.jpg"),
                                              fit: BoxFit.cover)),
                                      child: Container(),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.fromLTRB(0, 10, 0, 200),
                                      child: Text(
                                          "Tidak ada jadwal booking hari ini",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 20,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          :
                          //ini kalau else item ada isinya maka simple if lagi untuk mengecek status aktif
                          arrsemua[index].status == "pending" &&
                                  arrsemua[index].statusreschedule == "null"
                              ? Column(
                                  children: <Widget>[
                                    FocusedMenuHolder(
                                      blurSize: 4,
                                      blurBackgroundColor: Colors.black,
                                      menuBoxDecoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black,
                                                blurRadius: 1,
                                                spreadRadius: 1)
                                          ]),
                                      menuWidth:
                                          MediaQuery.of(context).size.width *
                                              0.7,
                                      duration: Duration(microseconds: 500),
                                      onPressed: () {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Tekan lebih lama untuk mengkonfirmasi pesanan",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.CENTER,
                                            backgroundColor: Colors.grey,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      },
                                      menuItems: <FocusedMenuItem>[
                                        FocusedMenuItem(
                                            title: Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: Text("Terima Booking",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17,
                                                    letterSpacing: 1,
                                                  )),
                                            ),
                                            onPressed: () {
                                              print("terima");
                                              myidupdate = arrsemua[index].id;
                                              usernamecancel = "-";
                                              myStatus.text = "terima";
                                              updatestatusbooking();
                                              Fluttertoast.showToast(
                                                  msg: "Booking Telah Diterima",
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                  gravity: ToastGravity.CENTER,
                                                  backgroundColor:
                                                      Colors.blue[300],
                                                  textColor: Colors.black,
                                                  fontSize: 16.0);
                                            },
                                            trailingIcon: Icon(
                                              Icons.follow_the_signs_sharp,
                                              color: Colors.white,
                                            ),
                                            backgroundColor: Colors.blueAccent),
                                        FocusedMenuItem(
                                            title: Container(
                                              margin: EdgeInsets.only(left: 10),
                                              child: Text("Tolak Booking",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17,
                                                    letterSpacing: 1,
                                                  )),
                                            ),
                                            onPressed: () {
                                              print("tolak");
                                              myidupdate = arrsemua[index].id;
                                              myStatus.text = "tolak";
                                              usernamecancel = "-";
                                              updatestatusbooking();
                                            },
                                            trailingIcon: Icon(
                                              Icons.follow_the_signs_sharp,
                                              color: Colors.white,
                                            ),
                                            backgroundColor:
                                                Colors.orangeAccent),
                                      ],
                                      child: Card(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 6,
                                              //color: Colors.red,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        10, 10, 0, 0),
                                                    child: RichText(
                                                      maxLines: 1,
                                                      text: TextSpan(
                                                        text: arrsemua[index]
                                                            .namauser
                                                            .capitalizeFirstofEach1,
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 0, 0, 0),
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                          text: "Pegawai : ",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      RichText(
                                                        maxLines: 1,
                                                        text: TextSpan(
                                                          text: arrsemua[index]
                                                              .requestpegawai
                                                              .capitalizeFirstofEach1,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        10, 10, 0, 0),
                                                    child: RichText(
                                                      maxLines: 1,
                                                      text: TextSpan(
                                                        text: arrsemua[index]
                                                            .namalayanan
                                                            .capitalizeFirstofEach1,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            letterSpacing: 1.5,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 3, 0, 0),
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                          text: "Rp. " +
                                                              numberFormat.format(
                                                                  int.parse(arrsemua[
                                                                          index]
                                                                      .total)),
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      RichText(
                                                        maxLines: 1,
                                                        text: TextSpan(
                                                          text: ",-   (" +
                                                              arrsemua[index]
                                                                  .pembayaran
                                                                  .capitalizeFirstofEach1 +
                                                              ")",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 3, 0, 0),
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                          text: "Status : ",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      RichText(
                                                        maxLines: 1,
                                                        text: TextSpan(
                                                          text: arrsemua[index]
                                                              .status
                                                              .capitalizeFirstofEach1,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Colors
                                                                  .redAccent),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  )
                                                ],
                                              ),
                                            ),
                                            //ini garis tengah
                                            Container(
                                                //color: Colors.yellow,
                                                height: 130,
                                                child: VerticalDivider(
                                                    color: Colors.black)),
                                            Expanded(
                                              flex: 5,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 10, 0, 0),
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                          text:
                                                              "Count Batal Hadir : ",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      RichText(
                                                        maxLines: 1,
                                                        text: TextSpan(
                                                          text: arrsemua[index]
                                                              .total_cancel
                                                              .toString(),
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        10, 0, 0, 0),
                                                    child: RichText(
                                                      maxLines: 1,
                                                      text: TextSpan(
                                                        text: "Hari Booking",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        10, 0, 0, 10),
                                                    child: RichText(
                                                      maxLines: 1,
                                                      text: TextSpan(
                                                        text: hri2[index]
                                                                .toString() +
                                                            arrsemua[index]
                                                                .tanggalbooking,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        10, 0, 0, 5),
                                                    child: RichText(
                                                      maxLines: 1,
                                                      text: TextSpan(
                                                        text: "Jam Booking",
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 10, 0, 0),
                                                      ),
                                                      RichText(
                                                        text: TextSpan(
                                                          text: arrsemua[index]
                                                                  .jambooking +
                                                              "  -  ",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                      RichText(
                                                        maxLines: 1,
                                                        text: TextSpan(
                                                          text: arrsemua[index]
                                                              .jambookingselesai,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black),
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
                                    ),
                                  ],
                                )
                              //INI TAMPILAN HARI INI YANG STATUS NYA TERIMA/RESCHEDULE BY SALON DAN STATUS RESCHEDULE NYA ADALAH PENDING
                              //tampilan ini ditujukan salon untuk req reschedule ke user (CUMA REQ)
                              : arrsemua[index].status == 'terima' &&
                                          arrsemua[index].statusreschedule ==
                                              "null" ||
                                      arrsemua[index].status == "terima" &&
                                          arrsemua[index].statusreschedule ==
                                              "tolak"
                                  ?
                                  //ini untuk status terima
                                  Column(
                                      children: <Widget>[
                                        FocusedMenuHolder(
                                          blurSize: 4,
                                          blurBackgroundColor: Colors.black,
                                          menuBoxDecoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.black,
                                                    blurRadius: 1,
                                                    spreadRadius: 1)
                                              ]),
                                          menuWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          duration: Duration(microseconds: 500),
                                          onPressed: () {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Tekan lebih lama untuk mengkonfirmasi pesanan",
                                                toastLength: Toast.LENGTH_LONG,
                                                gravity: ToastGravity.CENTER,
                                                backgroundColor: Colors.grey,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          },
                                          menuItems: <FocusedMenuItem>[
                                            FocusedMenuItem(
                                                title: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 10),
                                                  child: Text("Customer Datang",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 17,
                                                        letterSpacing: 1,
                                                      )),
                                                ),
                                                onPressed: () {
                                                  print("Datang");
                                                  myidupdate =
                                                      arrsemua[index].id;
                                                  usernamecancel = "-";
                                                  myStatus.text = "datang";
                                                  updatestatusbooking();
                                                  //Masukan kode
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Booking Telah Diterima",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                      backgroundColor:
                                                          Colors.blue[300],
                                                      textColor: Colors.black,
                                                      fontSize: 16.0);
                                                },
                                                trailingIcon: Icon(
                                                  Icons.follow_the_signs_sharp,
                                                  color: Colors.white,
                                                ),
                                                backgroundColor:
                                                    Colors.blueAccent),
                                            FocusedMenuItem(
                                                title: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 10),
                                                  child:
                                                      Text("Reschedule Booking",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 17,
                                                            letterSpacing: 1,
                                                          )),
                                                ),
                                                onPressed: () {
                                                  print("reschedule");
                                                  myidupdate =
                                                      arrsemua[index].id;
                                                  usernamecancel = "-";
                                                  idservice =
                                                      arrsemua[index].idservice;
                                                  myStatus.text =
                                                      "reschedulesalon";
                                                  reschedule_popup(
                                                      this.context);
                                                },
                                                trailingIcon: Icon(
                                                  Icons.follow_the_signs_sharp,
                                                  color: Colors.white,
                                                ),
                                                backgroundColor:
                                                    Colors.orangeAccent),
                                            FocusedMenuItem(
                                                title: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 10),
                                                  child: Text(
                                                      "Customer Tidak Datang",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 17,
                                                        letterSpacing: 1,
                                                      )),
                                                ),
                                                onPressed: () {
                                                  print("tidak datang");
                                                  myidupdate =
                                                      arrsemua[index].id;
                                                  myStatus.text =
                                                      "tidak datang";
                                                  usernamecancel =
                                                      arrsemua[index].username;
                                                  updatestatusbooking();
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Booking Telah Ditolak",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                },
                                                trailingIcon: Icon(
                                                  Icons.follow_the_signs_sharp,
                                                  color: Colors.white,
                                                ),
                                                backgroundColor:
                                                    Colors.redAccent),
                                            FocusedMenuItem(
                                                title: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 10),
                                                  child: Text("Chat Customer",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 17,
                                                        letterSpacing: 1,
                                                      )),
                                                ),
                                                onPressed: () {
                                                  print("tolak");
                                                  myidupdate =
                                                      arrsemua[index].id;
                                                  usernamecancel = "-";
                                                  myStatus.text = "tolak";
                                                  updatestatusbooking();
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Booking Telah Ditolak",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                },
                                                trailingIcon: Icon(
                                                  Icons.follow_the_signs_sharp,
                                                  color: Colors.white,
                                                ),
                                                backgroundColor:
                                                    Colors.grey[600]),
                                            FocusedMenuItem(
                                                title: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 10),
                                                  child: Text("Cancel Booking",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 17,
                                                        letterSpacing: 1,
                                                      )),
                                                ),
                                                onPressed: () {
                                                  print("cancel booking");
                                                  myidupdate =
                                                      arrsemua[index].id;
                                                  myStatus.text = "cancel";
                                                  usernamecancel =
                                                      arrsemua[index]
                                                          .requestpegawai;
                                                  updatestatusbooking();
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Booking Telah Ditolak",
                                                      toastLength:
                                                          Toast.LENGTH_LONG,
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                      backgroundColor:
                                                          Colors.redAccent,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                },
                                                trailingIcon: Icon(
                                                  Icons.follow_the_signs_sharp,
                                                  color: Colors.white,
                                                ),
                                                backgroundColor:
                                                    Colors.redAccent),
                                          ],
                                          child: Card(
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  flex: 6,
                                                  //color: Colors.red,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 0, 0, 0),
                                                        child: RichText(
                                                          maxLines: 1,
                                                          text: TextSpan(
                                                            text: arrsemua[
                                                                    index]
                                                                .namauser
                                                                .capitalizeFirstofEach1,
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(10, 0,
                                                                    0, 0),
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              text:
                                                                  "Pegawai : ",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          RichText(
                                                            maxLines: 1,
                                                            text: TextSpan(
                                                              text: arrsemua[
                                                                      index]
                                                                  .requestpegawai
                                                                  .capitalizeFirstofEach1,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 10, 0, 0),
                                                        child: RichText(
                                                          maxLines: 1,
                                                          text: TextSpan(
                                                            text: arrsemua[
                                                                    index]
                                                                .namalayanan
                                                                .capitalizeFirstofEach1,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                letterSpacing:
                                                                    1.5,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(10, 3,
                                                                    0, 0),
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              text: "Rp. " +
                                                                  numberFormat.format(
                                                                      int.parse(
                                                                          arrsemua[index]
                                                                              .total)),
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          RichText(
                                                            maxLines: 1,
                                                            text: TextSpan(
                                                              text: ",-   (" +
                                                                  arrsemua[
                                                                          index]
                                                                      .pembayaran
                                                                      .capitalizeFirstofEach1 +
                                                                  ")",
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(10, 3,
                                                                    0, 0),
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              text: "Status : ",
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          RichText(
                                                            maxLines: 1,
                                                            text: TextSpan(
                                                              text: arrsemua[
                                                                      index]
                                                                  .status
                                                                  .capitalizeFirstofEach1,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .green),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                //ini garis tengah
                                                Container(
                                                    //color: Colors.yellow,
                                                    height: 130,
                                                    child: VerticalDivider(
                                                        color: Colors.black)),
                                                Expanded(
                                                  flex: 5,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(10,
                                                                    10, 0, 0),
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              text:
                                                                  "Count Batal Hadir : ",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          RichText(
                                                            maxLines: 1,
                                                            text: TextSpan(
                                                              text: arrsemua[
                                                                      index]
                                                                  .total_cancel
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 0, 0, 0),
                                                        child: RichText(
                                                          maxLines: 1,
                                                          text: TextSpan(
                                                            text:
                                                                "Hari Booking",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 0, 0, 10),
                                                        child: RichText(
                                                          maxLines: 1,
                                                          text: TextSpan(
                                                            text: hri2[index]
                                                                    .toString() +
                                                                arrsemua[index]
                                                                    .tanggalbooking,
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                10, 0, 0, 5),
                                                        child: RichText(
                                                          maxLines: 1,
                                                          text: TextSpan(
                                                            text: "Jam Booking",
                                                            style: TextStyle(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(10,
                                                                    10, 0, 0),
                                                          ),
                                                          RichText(
                                                            text: TextSpan(
                                                              text: arrsemua[
                                                                          index]
                                                                      .jambooking +
                                                                  "  -  ",
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          RichText(
                                                            maxLines: 1,
                                                            text: TextSpan(
                                                              text: arrsemua[
                                                                      index]
                                                                  .jambookingselesai,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black),
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
                                        ),
                                      ],
                                    )
                                  //INI TAMPILAN HARI INI YANG STATUSNYA RESCHEDULE BY USER DAN STATUS RESCHEDULE NYA PENDING MAKA ACC
                                  : arrsemua[index].status ==
                                              "rescheduleuser" &&
                                          arrsemua[index].statusreschedule ==
                                              "pending"
                                      ? Column(
                                          children: <Widget>[
                                            FocusedMenuHolder(
                                              blurSize: 4,
                                              blurBackgroundColor: Colors.black,
                                              menuBoxDecoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(10)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black,
                                                        blurRadius: 1,
                                                        spreadRadius: 1)
                                                  ]),
                                              menuWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              duration:
                                                  Duration(microseconds: 500),
                                              onPressed: () {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Tekan lebih lama untuk mengkonfirmasi pesanan",
                                                    toastLength:
                                                        Toast.LENGTH_LONG,
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                    backgroundColor:
                                                        Colors.grey,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              },
                                              menuItems: <FocusedMenuItem>[
                                                FocusedMenuItem(
                                                    title: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10),
                                                      child: Text(
                                                          "Lihat Reschedule",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 17,
                                                            letterSpacing: 1,
                                                          )),
                                                    ),
                                                    onPressed: () {
                                                      print("acc reschedule");
                                                      myTgl_temp.text =
                                                          arrsemua[index]
                                                              .jamres;
                                                      myTime_temp.text =
                                                          arrsemua[index]
                                                              .tglres;
                                                      myidupdate =
                                                          arrsemua[index].id;
                                                      print(arrsemua[index]
                                                          .jamres);
                                                      print(arrsemua[index]
                                                          .tglres);
                                                      acc_lihat_reschedule(
                                                          context);
                                                    },
                                                    trailingIcon: Icon(
                                                      Icons
                                                          .follow_the_signs_sharp,
                                                      color: Colors.white,
                                                    ),
                                                    backgroundColor:
                                                        Colors.blueAccent),
                                                FocusedMenuItem(
                                                    title: Container(
                                                      margin: EdgeInsets.only(
                                                          left: 10),
                                                      child: Text(
                                                          "Cancel Booking",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 17,
                                                            letterSpacing: 1,
                                                          )),
                                                    ),
                                                    onPressed: () {
                                                      print("cancel booking");
                                                      myidupdate =
                                                          arrsemua[index].id;
                                                      myStatus.text = "cancel";
                                                      usernamecancel =
                                                          arrsemua[index]
                                                              .requestpegawai;
                                                      updatestatusbooking();
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Booking Telah Cancel",
                                                          toastLength:
                                                              Toast.LENGTH_LONG,
                                                          gravity: ToastGravity
                                                              .CENTER,
                                                          backgroundColor:
                                                              Colors.redAccent,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0);
                                                    },
                                                    trailingIcon: Icon(
                                                      Icons
                                                          .follow_the_signs_sharp,
                                                      color: Colors.white,
                                                    ),
                                                    backgroundColor:
                                                        Colors.redAccent),
                                              ],
                                              child: Card(
                                                child: Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 6,
                                                      //color: Colors.red,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(10,
                                                                    10, 0, 0),
                                                            child: RichText(
                                                              maxLines: 1,
                                                              text: TextSpan(
                                                                text: arr[index]
                                                                    .namauser
                                                                    .capitalizeFirstofEach1,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        10,
                                                                        0,
                                                                        0,
                                                                        0),
                                                              ),
                                                              RichText(
                                                                text: TextSpan(
                                                                  text:
                                                                      "Pegawai : ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                              RichText(
                                                                maxLines: 1,
                                                                text: TextSpan(
                                                                  text: arrsemua[
                                                                          index]
                                                                      .requestpegawai
                                                                      .capitalizeFirstofEach1,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(10,
                                                                    10, 0, 0),
                                                            child: RichText(
                                                              maxLines: 1,
                                                              text: TextSpan(
                                                                text: arrsemua[
                                                                        index]
                                                                    .namalayanan
                                                                    .capitalizeFirstofEach1,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    letterSpacing:
                                                                        1.5,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        10,
                                                                        3,
                                                                        0,
                                                                        0),
                                                              ),
                                                              RichText(
                                                                text: TextSpan(
                                                                  text: "Rp. " +
                                                                      numberFormat
                                                                          .format(
                                                                              int.parse(arrsemua[index].total)),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                              RichText(
                                                                maxLines: 1,
                                                                text: TextSpan(
                                                                  text: ",-   (" +
                                                                      arrsemua[
                                                                              index]
                                                                          .pembayaran
                                                                          .capitalizeFirstofEach1 +
                                                                      ")",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        10,
                                                                        3,
                                                                        0,
                                                                        0),
                                                              ),
                                                              RichText(
                                                                text: TextSpan(
                                                                  text:
                                                                      "Status : ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                              RichText(
                                                                maxLines: 1,
                                                                text: TextSpan(
                                                                  text: arrsemua[index]
                                                                              .status ==
                                                                          "rescheduleuser"
                                                                      ? "Reschedule (Pending)"
                                                                      : "",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                              .green[
                                                                          800]),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    //ini garis tengah
                                                    Container(
                                                        //color: Colors.yellow,
                                                        height: 130,
                                                        child: VerticalDivider(
                                                            color:
                                                                Colors.black)),
                                                    Expanded(
                                                      flex: 5,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(10, 0,
                                                                    0, 10),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        10,
                                                                        0,
                                                                        0,
                                                                        0),
                                                              ),
                                                              RichText(
                                                                text: TextSpan(
                                                                  text:
                                                                      "Count Batal Hadir : ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                              RichText(
                                                                maxLines: 1,
                                                                text: TextSpan(
                                                                  text: arrsemua[
                                                                          index]
                                                                      .total_cancel,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .red),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(10, 0,
                                                                    0, 0),
                                                            child: RichText(
                                                              maxLines: 1,
                                                              text: TextSpan(
                                                                text:
                                                                    "Hari Booking",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(10, 0,
                                                                    0, 10),
                                                            child: RichText(
                                                              maxLines: 1,
                                                              text: TextSpan(
                                                                text: hri2[index]
                                                                        .toString() +
                                                                    arrsemua[
                                                                            index]
                                                                        .tanggalbooking,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(10, 0,
                                                                    0, 5),
                                                            child: RichText(
                                                              maxLines: 1,
                                                              text: TextSpan(
                                                                text:
                                                                    "Jam Booking",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        10,
                                                                        10,
                                                                        0,
                                                                        0),
                                                              ),
                                                              RichText(
                                                                text: TextSpan(
                                                                  text: arrsemua[
                                                                              index]
                                                                          .jambooking +
                                                                      "  -  ",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                              ),
                                                              RichText(
                                                                maxLines: 1,
                                                                text: TextSpan(
                                                                  text: arrsemua[
                                                                          index]
                                                                      .jambookingselesai,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .black),
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
                                            ),
                                          ],
                                        )
                                      //INI TAMPILAN HARI INI YANG STATUSNYA RESCHEDULE BY SALON DAN STATUS RESCHEDULE NYA PENDING MAKA LIHAT RESCH TUNGGU ACC DARI CUSTOMER
                                      : arrsemua[index].status ==
                                                  "reschedulesalon" &&
                                              arrsemua[index]
                                                      .statusreschedule ==
                                                  "pending"
                                          ? Column(
                                              children: <Widget>[
                                                FocusedMenuHolder(
                                                  blurSize: 4,
                                                  blurBackgroundColor:
                                                      Colors.black,
                                                  menuBoxDecoration:
                                                      BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.black,
                                                            blurRadius: 1,
                                                            spreadRadius: 1)
                                                      ]),
                                                  menuWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.7,
                                                  duration: Duration(
                                                      microseconds: 500),
                                                  onPressed: () {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Tekan lebih lama untuk mengkonfirmasi pesanan",
                                                        toastLength:
                                                            Toast.LENGTH_LONG,
                                                        gravity:
                                                            ToastGravity.CENTER,
                                                        backgroundColor:
                                                            Colors.grey,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0);
                                                  },
                                                  menuItems: <FocusedMenuItem>[
                                                    FocusedMenuItem(
                                                        title: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: Text(
                                                              "Lihat Reschedule",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 17,
                                                                letterSpacing:
                                                                    1,
                                                              )),
                                                        ),
                                                        onPressed: () {
                                                          print(
                                                              "lihat res reschedule");
                                                          myTime_temp.text =
                                                              arrsemua[index]
                                                                  .jamres;
                                                          myTgl_temp.text =
                                                              arr[index].tglres;
                                                          print(arrsemua[index]
                                                              .jamres);
                                                          print(arrsemua[index]
                                                              .tglres);
                                                          tampilan_lihat_reschedule(
                                                              context);
                                                        },
                                                        trailingIcon: Icon(
                                                          Icons
                                                              .follow_the_signs_sharp,
                                                          color: Colors.white,
                                                        ),
                                                        backgroundColor:
                                                            Colors.blueAccent),
                                                    FocusedMenuItem(
                                                        title: Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 10),
                                                          child: Text(
                                                              "Cancel Booking",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 17,
                                                                letterSpacing:
                                                                    1,
                                                              )),
                                                        ),
                                                        onPressed: () {
                                                          print(
                                                              "cancel booking");
                                                          myidupdate =
                                                              arrsemua[index]
                                                                  .id;
                                                          myStatus.text =
                                                              "cancel";
                                                          usernamecancel =
                                                              arrsemua[index]
                                                                  .requestpegawai;
                                                          updatestatusbooking();
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Booking Telah Cancel",
                                                              toastLength: Toast
                                                                  .LENGTH_LONG,
                                                              gravity:
                                                                  ToastGravity
                                                                      .CENTER,
                                                              backgroundColor:
                                                                  Colors
                                                                      .redAccent,
                                                              textColor:
                                                                  Colors.white,
                                                              fontSize: 16.0);
                                                        },
                                                        trailingIcon: Icon(
                                                          Icons
                                                              .follow_the_signs_sharp,
                                                          color: Colors.white,
                                                        ),
                                                        backgroundColor:
                                                            Colors.redAccent),
                                                  ],
                                                  child: Card(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Expanded(
                                                          flex: 6,
                                                          //color: Colors.red,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        10,
                                                                        10,
                                                                        0,
                                                                        0),
                                                                child: RichText(
                                                                  maxLines: 1,
                                                                  text:
                                                                      TextSpan(
                                                                    text: arrsemua[
                                                                            index]
                                                                        .namauser
                                                                        .capitalizeFirstofEach1,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                  ),
                                                                  RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      text:
                                                                          "Pegawai : ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                  RichText(
                                                                    maxLines: 1,
                                                                    text:
                                                                        TextSpan(
                                                                      text: arrsemua[
                                                                              index]
                                                                          .requestpegawai
                                                                          .capitalizeFirstofEach1,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        10,
                                                                        10,
                                                                        0,
                                                                        0),
                                                                child: RichText(
                                                                  maxLines: 1,
                                                                  text:
                                                                      TextSpan(
                                                                    text: arrsemua[
                                                                            index]
                                                                        .namalayanan
                                                                        .capitalizeFirstofEach1,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        letterSpacing:
                                                                            1.5,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            3,
                                                                            0,
                                                                            0),
                                                                  ),
                                                                  RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      text: "Rp. " +
                                                                          numberFormat
                                                                              .format(int.parse(arrsemua[index].total)),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                  RichText(
                                                                    maxLines: 1,
                                                                    text:
                                                                        TextSpan(
                                                                      text: ",-   (" +
                                                                          arrsemua[index]
                                                                              .pembayaran
                                                                              .capitalizeFirstofEach1 +
                                                                          ")",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            3,
                                                                            0,
                                                                            0),
                                                                  ),
                                                                  RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      text:
                                                                          "Status : ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                  RichText(
                                                                    maxLines: 1,
                                                                    text:
                                                                        TextSpan(
                                                                      text: arrsemua[index].status ==
                                                                              "reschedulesalon"
                                                                          ? "Reschedule (Pending)"
                                                                          : "",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          color:
                                                                              Colors.green[800]),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        //ini garis tengah
                                                        Container(
                                                            //color: Colors.yellow,
                                                            height: 130,
                                                            child:
                                                                VerticalDivider(
                                                                    color: Colors
                                                                        .black)),
                                                        Expanded(
                                                          flex: 5,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        10,
                                                                        0,
                                                                        0,
                                                                        10),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                  ),
                                                                  RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      text:
                                                                          "Count Batal Hadir : ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                  RichText(
                                                                    maxLines: 1,
                                                                    text:
                                                                        TextSpan(
                                                                      text: arrsemua[
                                                                              index]
                                                                          .total_cancel,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color:
                                                                              Colors.red),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        10,
                                                                        0,
                                                                        0,
                                                                        0),
                                                                child: RichText(
                                                                  maxLines: 1,
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        "Hari Booking",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        10,
                                                                        0,
                                                                        0,
                                                                        10),
                                                                child: RichText(
                                                                  maxLines: 1,
                                                                  text:
                                                                      TextSpan(
                                                                    text: hri2[index]
                                                                            .toString() +
                                                                        arrsemua[index]
                                                                            .tanggalbooking,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        10,
                                                                        0,
                                                                        0,
                                                                        5),
                                                                child: RichText(
                                                                  maxLines: 1,
                                                                  text:
                                                                      TextSpan(
                                                                    text:
                                                                        "Jam Booking",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            10,
                                                                            0,
                                                                            0),
                                                                  ),
                                                                  RichText(
                                                                    text:
                                                                        TextSpan(
                                                                      text: arrsemua[index]
                                                                              .jambooking +
                                                                          "  -  ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              Colors.black),
                                                                    ),
                                                                  ),
                                                                  RichText(
                                                                    maxLines: 1,
                                                                    text:
                                                                        TextSpan(
                                                                      text: arrsemua[
                                                                              index]
                                                                          .jambookingselesai,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          color:
                                                                              Colors.black),
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
                                                ),
                                              ],
                                            )
                                          //INI TAMPILAN HARI INI YANG STATUSNYA RESCHEDULE BY USER(SUDAH KETERIMA MAKA STATUS NYA TERIMA) DAN STATUS RESCHEDULE TERIMA
                                          : arrsemua[index].status ==
                                                      "terima" &&
                                                  arrsemua[index]
                                                          .statusreschedule ==
                                                      "terima"
                                              ? Column(
                                                  children: <Widget>[
                                                    FocusedMenuHolder(
                                                      blurSize: 4,
                                                      blurBackgroundColor:
                                                          Colors.black,
                                                      menuBoxDecoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors
                                                                    .black,
                                                                blurRadius: 1,
                                                                spreadRadius: 1)
                                                          ]),
                                                      menuWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                      duration: Duration(
                                                          microseconds: 500),
                                                      onPressed: () {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Tekan lebih lama untuk mengkonfirmasi pesanan",
                                                            toastLength: Toast
                                                                .LENGTH_LONG,
                                                            gravity:
                                                                ToastGravity
                                                                    .CENTER,
                                                            backgroundColor:
                                                                Colors.grey,
                                                            textColor:
                                                                Colors.white,
                                                            fontSize: 16.0);
                                                      },
                                                      menuItems: <
                                                          FocusedMenuItem>[
                                                        FocusedMenuItem(
                                                            title: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 10),
                                                              child: Text(
                                                                  "Reschedule Booking",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        17,
                                                                    letterSpacing:
                                                                        1,
                                                                  )),
                                                            ),
                                                            onPressed: () {
                                                              print(
                                                                  "reschedule booking");
                                                              idservice =
                                                                  arrsemua[
                                                                          index]
                                                                      .idservice;
                                                              myidupdate =
                                                                  arrsemua[
                                                                          index]
                                                                      .id;
                                                              usernamecancel =
                                                                  "-";
                                                              //updatestatusbooking();
                                                              print(idservice +
                                                                  "  bbbbb");
                                                              reschedule_popup(
                                                                  context);
                                                            },
                                                            trailingIcon: Icon(
                                                              Icons
                                                                  .follow_the_signs_sharp,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            backgroundColor:
                                                                Colors
                                                                    .blueAccent),
                                                        FocusedMenuItem(
                                                            title: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 10),
                                                              child: Text(
                                                                  "Cancel Booking",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        17,
                                                                    letterSpacing:
                                                                        1,
                                                                  )),
                                                            ),
                                                            onPressed: () {
                                                              print(
                                                                  "cancel booking");
                                                              myidupdate =
                                                                  arrsemua[
                                                                          index]
                                                                      .id;
                                                              myStatus.text =
                                                                  "cancel";
                                                              usernamecancel =
                                                                  arrsemua[
                                                                          index]
                                                                      .requestpegawai;
                                                              updatestatusbooking();
                                                              Fluttertoast.showToast(
                                                                  msg:
                                                                      "Booking Telah Di Cancel",
                                                                  toastLength: Toast
                                                                      .LENGTH_LONG,
                                                                  gravity:
                                                                      ToastGravity
                                                                          .CENTER,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .redAccent,
                                                                  textColor:
                                                                      Colors
                                                                          .white,
                                                                  fontSize:
                                                                      16.0);
                                                            },
                                                            trailingIcon: Icon(
                                                              Icons
                                                                  .follow_the_signs_sharp,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            backgroundColor:
                                                                Colors
                                                                    .redAccent),
                                                      ],
                                                      child: Card(
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                              flex: 6,
                                                              //color: Colors.red,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            10,
                                                                            0,
                                                                            0),
                                                                    child:
                                                                        RichText(
                                                                      maxLines:
                                                                          1,
                                                                      text:
                                                                          TextSpan(
                                                                        text: arrsemua[index]
                                                                            .namauser
                                                                            .capitalizeFirstofEach1,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                      ),
                                                                      RichText(
                                                                        text:
                                                                            TextSpan(
                                                                          text:
                                                                              "Pegawai : ",
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      RichText(
                                                                        maxLines:
                                                                            1,
                                                                        text:
                                                                            TextSpan(
                                                                          text: arrsemua[index]
                                                                              .requestpegawai
                                                                              .capitalizeFirstofEach1,
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            10,
                                                                            0,
                                                                            0),
                                                                    child:
                                                                        RichText(
                                                                      maxLines:
                                                                          1,
                                                                      text:
                                                                          TextSpan(
                                                                        text: arrsemua[index]
                                                                            .namalayanan
                                                                            .capitalizeFirstofEach1,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            letterSpacing:
                                                                                1.5,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            10,
                                                                            3,
                                                                            0,
                                                                            0),
                                                                      ),
                                                                      RichText(
                                                                        text:
                                                                            TextSpan(
                                                                          text: "Rp. " +
                                                                              numberFormat.format(int.parse(arrsemua[index].total)),
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      RichText(
                                                                        maxLines:
                                                                            1,
                                                                        text:
                                                                            TextSpan(
                                                                          text: ",-   (" +
                                                                              arrsemua[index].pembayaran.capitalizeFirstofEach1 +
                                                                              ")",
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            10,
                                                                            3,
                                                                            0,
                                                                            0),
                                                                      ),
                                                                      RichText(
                                                                        text:
                                                                            TextSpan(
                                                                          text:
                                                                              "Status : ",
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      RichText(
                                                                        maxLines:
                                                                            1,
                                                                        text:
                                                                            TextSpan(
                                                                          text: arrsemua[index].status == "terima"
                                                                              ? "Terima"
                                                                              : "",
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold,
                                                                              color: Colors.green[800]),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            //ini garis tengah
                                                            Container(
                                                                //color: Colors.yellow,
                                                                height: 130,
                                                                child: VerticalDivider(
                                                                    color: Colors
                                                                        .black)),
                                                            Expanded(
                                                              flex: 5,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            10),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                      ),
                                                                      RichText(
                                                                        text:
                                                                            TextSpan(
                                                                          text:
                                                                              "Count Batal Hadir : ",
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      RichText(
                                                                        maxLines:
                                                                            1,
                                                                        text:
                                                                            TextSpan(
                                                                          text:
                                                                              arrsemua[index].total_cancel,
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: Colors.red),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                    child:
                                                                        RichText(
                                                                      maxLines:
                                                                          1,
                                                                      text:
                                                                          TextSpan(
                                                                        text:
                                                                            "Hari Booking",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            10),
                                                                    child:
                                                                        RichText(
                                                                      maxLines:
                                                                          1,
                                                                      text:
                                                                          TextSpan(
                                                                        text: hri2[index].toString() +
                                                                            arrsemua[index].tglres,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                Colors.black),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            5),
                                                                    child:
                                                                        RichText(
                                                                      maxLines:
                                                                          1,
                                                                      text:
                                                                          TextSpan(
                                                                        text:
                                                                            "Jam Booking",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: Colors.black),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            10,
                                                                            10,
                                                                            0,
                                                                            0),
                                                                      ),
                                                                      RichText(
                                                                        text:
                                                                            TextSpan(
                                                                          text: arrsemua[index].jamres +
                                                                              "  -  ",
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.black),
                                                                        ),
                                                                      ),
                                                                      RichText(
                                                                        maxLines:
                                                                            1,
                                                                        text:
                                                                            TextSpan(
                                                                          text:
                                                                              arrsemua[index].jamresselesai,
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: Colors.black),
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
                                                    ),
                                                  ],
                                                )
                                              //INI BUAT STATUS TOLAK
                                              : arrsemua[index].status ==
                                                      'datang'
                                                  ? Column(
                                                      children: <Widget>[
                                                        FocusedMenuHolder(
                                                          blurSize: 4,
                                                          blurBackgroundColor:
                                                              Colors.black,
                                                          menuBoxDecoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(10)),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .black,
                                                                    blurRadius:
                                                                        1,
                                                                    spreadRadius:
                                                                        1)
                                                              ]),
                                                          menuWidth:
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.7,
                                                          duration: Duration(
                                                              microseconds:
                                                                  500),
                                                          onPressed: () {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    "Tekan lebih lama untuk mengkonfirmasi pesanan",
                                                                toastLength: Toast
                                                                    .LENGTH_LONG,
                                                                gravity:
                                                                    ToastGravity
                                                                        .CENTER,
                                                                backgroundColor:
                                                                    Colors.grey,
                                                                textColor:
                                                                    Colors
                                                                        .white,
                                                                fontSize: 16.0);
                                                          },
                                                          menuItems: <
                                                              FocusedMenuItem>[
                                                            FocusedMenuItem(
                                                                title:
                                                                    Container(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10),
                                                                  child: Text(
                                                                      "Layanan Selesai",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontSize:
                                                                            17,
                                                                        letterSpacing:
                                                                            1,
                                                                      )),
                                                                ),
                                                                onPressed: () {
                                                                  print(
                                                                      "ini ini selesai");
                                                                  myidupdate =
                                                                      arr[index]
                                                                          .id;
                                                                  myStatus.text =
                                                                      "selesai";
                                                                  usernamecancel =
                                                                      "-";
                                                                  updatestatusbooking();
                                                                  Fluttertoast.showToast(
                                                                      msg:
                                                                          "1 Booking Layanan Telah Selesai",
                                                                      toastLength:
                                                                          Toast
                                                                              .LENGTH_LONG,
                                                                      gravity:
                                                                          ToastGravity
                                                                              .CENTER,
                                                                      backgroundColor:
                                                                          Colors.blue[
                                                                              300],
                                                                      textColor:
                                                                          Colors
                                                                              .black,
                                                                      fontSize:
                                                                          16.0);
                                                                },
                                                                trailingIcon:
                                                                    Icon(
                                                                  Icons
                                                                      .follow_the_signs_sharp,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                backgroundColor:
                                                                    Colors
                                                                        .blueAccent),
                                                          ],
                                                          child: Card(
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Expanded(
                                                                  flex: 6,
                                                                  //color: Colors.red,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            RichText(
                                                                          maxLines:
                                                                              1,
                                                                          text:
                                                                              TextSpan(
                                                                            text:
                                                                                arrsemua[index].namauser.capitalizeFirstofEach1,
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
                                                                                10,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                          ),
                                                                          RichText(
                                                                            text:
                                                                                TextSpan(
                                                                              text: "Pegawai : ",
                                                                              style: TextStyle(fontSize: 14, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                          RichText(
                                                                            maxLines:
                                                                                1,
                                                                            text:
                                                                                TextSpan(
                                                                              text: arrsemua[index].requestpegawai.capitalizeFirstofEach1,
                                                                              style: TextStyle(fontSize: 15, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Container(
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            10,
                                                                            10,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            RichText(
                                                                          maxLines:
                                                                              1,
                                                                          text:
                                                                              TextSpan(
                                                                            text:
                                                                                arrsemua[index].namalayanan.capitalizeFirstofEach1,
                                                                            style: TextStyle(
                                                                                fontSize: 15,
                                                                                letterSpacing: 1.5,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                            margin: EdgeInsets.fromLTRB(
                                                                                10,
                                                                                3,
                                                                                0,
                                                                                0),
                                                                          ),
                                                                          RichText(
                                                                            text:
                                                                                TextSpan(
                                                                              text: "Rp. " + numberFormat.format(int.parse(arrsemua[index].total)),
                                                                              style: TextStyle(fontSize: 15, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                          RichText(
                                                                            maxLines:
                                                                                1,
                                                                            text:
                                                                                TextSpan(
                                                                              text: ",-   (" + arrsemua[index].pembayaran.capitalizeFirstofEach1 + ")",
                                                                              style: TextStyle(fontSize: 15, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                            margin: EdgeInsets.fromLTRB(
                                                                                10,
                                                                                3,
                                                                                0,
                                                                                0),
                                                                          ),
                                                                          RichText(
                                                                            text:
                                                                                TextSpan(
                                                                              text: "Status : ",
                                                                              style: TextStyle(fontSize: 15, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                          RichText(
                                                                            maxLines:
                                                                                1,
                                                                            text:
                                                                                TextSpan(
                                                                              text: arrsemua[index].status.capitalizeFirstofEach1,
                                                                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                //ini garis tengah
                                                                Container(
                                                                    //color: Colors.yellow,
                                                                    height: 130,
                                                                    child: VerticalDivider(
                                                                        color: Colors
                                                                            .black)),
                                                                Expanded(
                                                                  flex: 5,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                            margin: EdgeInsets.fromLTRB(
                                                                                10,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                          ),
                                                                          RichText(
                                                                            text:
                                                                                TextSpan(
                                                                              text: "Count Batal Hadir : ",
                                                                              style: TextStyle(fontSize: 14, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                          RichText(
                                                                            maxLines:
                                                                                1,
                                                                            text:
                                                                                TextSpan(
                                                                              text: arrsemua[index].total_cancel.toString(),
                                                                              style: TextStyle(fontSize: 15, color: Colors.red),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Container(
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                        child:
                                                                            RichText(
                                                                          maxLines:
                                                                              1,
                                                                          text:
                                                                              TextSpan(
                                                                            text:
                                                                                "Hari Booking",
                                                                            style: TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            10),
                                                                        child:
                                                                            RichText(
                                                                          maxLines:
                                                                              1,
                                                                          text:
                                                                              TextSpan(
                                                                            text:
                                                                                hri2[index].toString() + arrsemua[index].tanggalbooking,
                                                                            style:
                                                                                TextStyle(fontSize: 15, color: Colors.black),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        margin: EdgeInsets.fromLTRB(
                                                                            10,
                                                                            0,
                                                                            0,
                                                                            5),
                                                                        child:
                                                                            RichText(
                                                                          maxLines:
                                                                              1,
                                                                          text:
                                                                              TextSpan(
                                                                            text:
                                                                                "Jam Booking",
                                                                            style: TextStyle(
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Colors.black),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                            margin: EdgeInsets.fromLTRB(
                                                                                10,
                                                                                10,
                                                                                0,
                                                                                0),
                                                                          ),
                                                                          RichText(
                                                                            text:
                                                                                TextSpan(
                                                                              text: arrsemua[index].jambooking + "  -  ",
                                                                              style: TextStyle(fontSize: 14, color: Colors.black),
                                                                            ),
                                                                          ),
                                                                          RichText(
                                                                            maxLines:
                                                                                1,
                                                                            text:
                                                                                TextSpan(
                                                                              text: arrsemua[index].jambookingselesai,
                                                                              style: TextStyle(fontSize: 15, color: Colors.black),
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
                                                        ),
                                                      ],
                                                    )
                                                  : SizedBox()),
                ),
        ],
      ),
    );
  }
}
