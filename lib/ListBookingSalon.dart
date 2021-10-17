import 'package:flutter/material.dart';
import 'package:ta_salon/ClassLayananWithUsers.dart';
import 'package:ta_salon/ClassListBookingWithLayanan.dart';
import 'package:ta_salon/HomeSalon.dart';
import 'package:ta_salon/ServiceSalon.dart';
import 'main_variable.dart' as main_variable;
import 'dart:async';
import 'package:ta_salon/warnalayer.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:ta_salon/ClassUser.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'ClassBookingService.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
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
  NumberFormat numberFormat = NumberFormat(',000');

  String myidupdate;
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

  bool iscreambath;
  bool tampilsemua = false;
  bool buttonberubah = false;

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
          foto,
          'jambookingselesai',
          "0"));
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
          foto,
          'jambookingselesai',
          "0"));
      arrcount.add(new ClassBookingService(
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
          "pembayaran"));
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
            data1[i].toString());
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
            data1[i].toString());
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
      // print("ini data" + data.toString());

      getlistbookingsalon();
      getlistbookingsalonsemua();

      // for (int i = 0; i < data1.length; i++) {
      //   ClassListBookingWithLayanan databaru = new ClassListBookingWithLayanan(
      //       data1[i]['id'].toString(),
      //       data1[i]['tanggal'].toString(),
      //       data1[i]['username'].toString(),
      //       data1[i]['namauser'].toString(),
      //       data1[i]['usenamesalon'].toString(),
      //       data1[i]['idservice'].toString(),
      //       data1[i]['tanggalbooking'].toString(),
      //       data1[i]['jambooking'].toString(),
      //       data1[i]['requestpegawai'].toString(),
      //       data1[i]['total'].toString(),
      //       data1[i]['namalayanan'].toString(),
      //       data1[i]['status'].toString(),
      //       data[i]['pembayaran'].toString(),
      //       data[i]['foto'].toString(),
      //       data[i]['jambookingselesai'].toString(),
      //       data[i].toString());
      //   temp1.add(databaru);
      // }
      // //print("ini data2 : " + data.toString());
      // for (int i = 0; i < data.length; i++) {
      //   ClassListBookingWithLayanan databaru = new ClassListBookingWithLayanan(
      //       data[i]['id'].toString(),
      //       data[i]['tanggal'].toString(),
      //       data[i]['username'].toString(),
      //       data[i]['namauser'].toString(),
      //       data[i]['usenamesalon'].toString(),
      //       data[i]['idservice'].toString(),
      //       data[i]['tanggalbooking'].toString(),
      //       data[i]['jambooking'].toString(),
      //       data[i]['requestpegawai'].toString(),
      //       data[i]['total'].toString(),
      //       data[i]['namalayanan'].toString(),
      //       data[i]['status'].toString(),
      //       data[i]['pembayaran'].toString(),
      //       data[i]['foto'].toString(),
      //       data[i]['jambookingselesai'].toString(),
      //       data[i].toString());
      //   temp2.add(databaru);
      // }
      // setState(() {
      //   this.arr = temp1;
      //   this.arrsemua = temp2;
      // });

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

  showDialogFunc(context, img, title, desc) {
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
              height: 280,
              width: MediaQuery.of(context).size.width * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.asset(
                      img,
                      width: 150,
                      height: 150,
                    ),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    //width: 200,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        desc,
                        maxLines: 3,
                        style: TextStyle(fontSize: 15, color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // buildTextButton(MaterialCommunityIcons.check, "",
                      //     Warnalayer.facebookColor),
                      // buildTextButton1(MaterialCommunityIcons.close, "",
                      //     Warnalayer.googleColor)
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
      body: Column(
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
                          arr[index].status == "pending"
                              ? Column(
                                  children: <Widget>[
                                    Card(
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
                                                      text: arr[index]
                                                          .namauser
                                                          .capitalizeFirstofEach1,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
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
                                                          color: Colors.black),
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
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      0, 10, 0, 10),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                8, 0, 0, 0),
                                                        child: Row(
                                                          children: [
                                                            RaisedButton(
                                                              onPressed: () {
                                                                print(
                                                                    "ini ini terima");
                                                                myidupdate =
                                                                    arr[index]
                                                                        .id;
                                                                usernamecancel =
                                                                    "-";
                                                                myStatus.text =
                                                                    "terima";
                                                                updatestatusbooking();
                                                                getlistbookingsalon();
                                                                getlistbookingsalonsemua();
                                                              },
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              color: Colors
                                                                  .green[600],
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          10,
                                                                          10,
                                                                          10),
                                                              child: Text(
                                                                "Terima",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                8, 0, 0, 0),
                                                        child: Row(
                                                          children: [
                                                            RaisedButton(
                                                              onPressed: () {
                                                                print(
                                                                    "ini ini Tolak");
                                                                myidupdate =
                                                                    arr[index]
                                                                        .id;
                                                                usernamecancel =
                                                                    "-";
                                                                myStatus.text =
                                                                    "tolak";
                                                                updatestatusbooking();
                                                                getlistbookingsalon();
                                                                getlistbookingsalonsemua();
                                                              },
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              color: Colors
                                                                  .red[900],
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          10,
                                                                          10,
                                                                          10),
                                                              child: Text(
                                                                "Tolak",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          //ini garis tengah
                                          Container(
                                              //color: Colors.yellow,
                                              height: 180,
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
                                                      10, 10, 0, 0),
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
                                                            color: Colors.red),
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
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.fromLTRB(
                                                      10, 0, 0, 20),
                                                  child: RichText(
                                                    maxLines: 1,
                                                    text: TextSpan(
                                                      text: hri1[index]
                                                              .toString() +
                                                          arr[index]
                                                              .tanggalbooking,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black),
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
                                                          color: Colors.black),
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
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 50,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : arr[index].status == 'terima'
                                  ?

                                  //ini untuk status terima
                                  Column(
                                      children: <Widget>[
                                        GestureDetector(
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
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                8, 0, 0, 0),
                                                        child: Row(
                                                          children: [
                                                            RaisedButton(
                                                              onPressed: () {
                                                                print(
                                                                    "ini ini datang");
                                                                myidupdate =
                                                                    arr[index]
                                                                        .id;
                                                                usernamecancel =
                                                                    "-";
                                                                myStatus.text =
                                                                    "datang";
                                                                updatestatusbooking();
                                                                getlistbookingsalon();
                                                                getlistbookingsalonsemua();
                                                              },
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              color: Colors
                                                                  .blue[600],
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          20,
                                                                          10,
                                                                          20,
                                                                          10),
                                                              child: Text(
                                                                "Datang",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            RaisedButton(
                                                              onPressed: () {
                                                                print(
                                                                    "ini ini reschedule");
                                                                myidupdate =
                                                                    arr[index]
                                                                        .id;
                                                                usernamecancel =
                                                                    "-";
                                                                myStatus.text =
                                                                    "reschedule";
                                                                //updatestatusbooking();
                                                                //getlistbookingsalon();
                                                                //buat pop up untuk tampilkan pilihan jam reschedule
                                                              },
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              color: Colors
                                                                  .yellow[900],
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          10,
                                                                          10,
                                                                          10),
                                                              child: Text(
                                                                "Reschedule",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                8, 0, 0, 10),
                                                        child: Row(
                                                          children: [
                                                            RaisedButton(
                                                              onPressed: () {
                                                                myidupdate =
                                                                    arr[index]
                                                                        .id;
                                                                myStatus.text =
                                                                    "tidak datang";
                                                                usernamecancel =
                                                                    arr[index]
                                                                        .username;
                                                                updatestatusbooking();
                                                                getlistbookingsalon();
                                                                getlistbookingsalonsemua();
                                                                print("a : " +
                                                                    usernamecancel);
                                                              },
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              color: Colors
                                                                  .red[800],
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          30,
                                                                          10,
                                                                          30,
                                                                          10),
                                                              child: Text(
                                                                "Customer Tidak Hadir",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                //ini garis tengah
                                                Container(
                                                    //color: Colors.yellow,
                                                    height: 220,
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
                                                                10, 0, 0, 20),
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
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                8, 0, 0, 0),
                                                        child: Row(
                                                          children: [
                                                            RaisedButton(
                                                              onPressed: () {},
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              color: Colors
                                                                  .grey[300],
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          40,
                                                                          10,
                                                                          40,
                                                                          10),
                                                              child: Text(
                                                                "Chatting",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                8, 0, 0, 10),
                                                        child: Row(
                                                          children: [
                                                            RaisedButton(
                                                              onPressed: () {
                                                                myidupdate =
                                                                    arr[index]
                                                                        .id;
                                                                myStatus.text =
                                                                    "cancel";
                                                                usernamecancel =
                                                                    arr[index]
                                                                        .requestpegawai;
                                                                updatestatusbooking();
                                                                getlistbookingsalonsemua();
                                                              },
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              color: Colors
                                                                  .grey[300],
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          22,
                                                                          10,
                                                                          22,
                                                                          10),
                                                              child: Text(
                                                                "Cancel Booking",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            )
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
                                    )
                                  //INI BUAT STATUS TOLAK SUPAYA TIDAK DITAMPILKAN
                                  : arr[index].status == 'datang'
                                      ? Column(
                                          children: <Widget>[
                                            Card(
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
                                                                  .fromLTRB(10,
                                                                      0, 0, 0),
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
                                                                text: arr[index]
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
                                                              .fromLTRB(
                                                                  10, 20, 0, 0),
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
                                                                  .fromLTRB(10,
                                                                      3, 0, 0),
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
                                                                  .fromLTRB(10,
                                                                      3, 0, 0),
                                                            ),
                                                            RichText(
                                                              text: TextSpan(
                                                                text:
                                                                    "Status : ",
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
                                                                text: arr[index]
                                                                    .status
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
                                                              .fromLTRB(
                                                                  8, 10, 0, 10),
                                                          child: Row(
                                                            children: [
                                                              RaisedButton(
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
                                                                  getlistbookingsalonsemua();
                                                                },
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                color: Colors
                                                                        .orange[
                                                                    800],
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            50,
                                                                            10,
                                                                            50,
                                                                            10),
                                                                child: Text(
                                                                  "Selesai",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  //ini garis tengah
                                                  Container(
                                                      //color: Colors.yellow,
                                                      height: 220,
                                                      child: VerticalDivider(
                                                          color: Colors.black)),
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
                                                              margin: EdgeInsets
                                                                  .fromLTRB(10,
                                                                      0, 0, 0),
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
                                                                text: arr[index]
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
                                                              .fromLTRB(
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
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  10, 0, 0, 20),
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
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  10, 0, 0, 5),
                                                          child: RichText(
                                                            maxLines: 1,
                                                            text: TextSpan(
                                                              text:
                                                                  "Jam Booking",
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
                                                        Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 0, 0, 50),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
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
                          arrsemua[index].status == "pending"
                              ? Column(
                                  children: <Widget>[
                                    GestureDetector(
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
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        0, 10, 0, 10),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  8, 0, 0, 0),
                                                          child: Row(
                                                            children: [
                                                              RaisedButton(
                                                                onPressed: () {
                                                                  print(
                                                                      "ini ini terima");
                                                                  myidupdate =
                                                                      arrsemua[
                                                                              index]
                                                                          .id;
                                                                  myStatus.text =
                                                                      "terima";
                                                                  usernamecancel =
                                                                      "-";
                                                                  updatestatusbooking();
                                                                  //getlistbookingsalonsemua();
                                                                },
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                color: Colors
                                                                    .green[600],
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            10,
                                                                            10,
                                                                            10),
                                                                child: Text(
                                                                  "Terima",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  8, 0, 0, 0),
                                                          child: Row(
                                                            children: [
                                                              RaisedButton(
                                                                onPressed: () {
                                                                  print(
                                                                      "ini ini Tolak");
                                                                  myidupdate =
                                                                      arrsemua[
                                                                              index]
                                                                          .id;
                                                                  myStatus.text =
                                                                      "tolak";
                                                                  usernamecancel =
                                                                      "-";
                                                                  updatestatusbooking();
                                                                  //getlistbookingsalonsemua();
                                                                },
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                color: Colors
                                                                    .red[900],
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            10,
                                                                            10,
                                                                            10,
                                                                            10),
                                                                child: Text(
                                                                  "Tolak",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            //ini garis tengah
                                            Container(
                                                //color: Colors.yellow,
                                                height: 180,
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
                                                        10, 0, 0, 20),
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
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        8, 0, 0, 10),
                                                    child: Row(
                                                      children: [
                                                        RaisedButton(
                                                          onPressed: () {
                                                            myidupdate =
                                                                arrsemua[index]
                                                                    .id;
                                                            myStatus.text =
                                                                "cancel";
                                                            usernamecancel =
                                                                arrsemua[index]
                                                                    .requestpegawai;
                                                            updatestatusbooking();
                                                            getlistbookingsalonsemua();
                                                          },
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          color:
                                                              Colors.grey[300],
                                                          padding: EdgeInsets
                                                              .fromLTRB(22, 10,
                                                                  22, 10),
                                                          child: Text(
                                                            "Cancel Booking",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14),
                                                          ),
                                                        )
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
                                )
                              : arrsemua[index].status == 'terima'
                                  ?

                                  //ini untuk status terima
                                  Column(
                                      children: <Widget>[
                                        GestureDetector(
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
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                8, 0, 0, 0),
                                                        child: Row(
                                                          children: [
                                                            RaisedButton(
                                                              onPressed: () {
                                                                print(
                                                                    "ini ini datang");
                                                                myidupdate =
                                                                    arrsemua[
                                                                            index]
                                                                        .id;
                                                                myStatus.text =
                                                                    "datang";
                                                                usernamecancel =
                                                                    "-";
                                                                updatestatusbooking();
                                                                getlistbookingsalonsemua();
                                                              },
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              color: Colors
                                                                  .blue[600],
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          20,
                                                                          10,
                                                                          20,
                                                                          10),
                                                              child: Text(
                                                                "Datang",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 10,
                                                            ),
                                                            RaisedButton(
                                                              onPressed: () {
                                                                print(
                                                                    "ini ini reschedule");
                                                                myidupdate =
                                                                    arrsemua[
                                                                            index]
                                                                        .id;
                                                                myStatus.text =
                                                                    "reschedule";
                                                                usernamecancel =
                                                                    "-";
                                                                //updatestatusbooking();
                                                                //getlistbookingsalon();
                                                                //buat pop up untuk tampilkan pilihan jam reschedule
                                                              },
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              color: Colors
                                                                  .yellow[900],
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          10,
                                                                          10,
                                                                          10),
                                                              child: Text(
                                                                "Reschedule",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                8, 0, 0, 10),
                                                        child: Row(
                                                          children: [
                                                            RaisedButton(
                                                              onPressed: () {
                                                                myidupdate =
                                                                    arrsemua[
                                                                            index]
                                                                        .id;
                                                                myStatus.text =
                                                                    "tidak datang";
                                                                usernamecancel =
                                                                    arrsemua[
                                                                            index]
                                                                        .username;

                                                                updatestatusbooking();
                                                                getlistbookingsalonsemua();
                                                                print("a : " +
                                                                    usernamecancel);
                                                              },
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              color: Colors
                                                                  .red[800],
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          30,
                                                                          10,
                                                                          30,
                                                                          10),
                                                              child: Text(
                                                                "Customer Tidak Hadir",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                //ini garis tengah
                                                Container(
                                                    //color: Colors.yellow,
                                                    height: 180,
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
                                                                10, 0, 0, 20),
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
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                8, 0, 0, 0),
                                                        child: Row(
                                                          children: [
                                                            RaisedButton(
                                                              onPressed: () {},
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              color: Colors
                                                                  .grey[300],
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          40,
                                                                          10,
                                                                          40,
                                                                          10),
                                                              child: Text(
                                                                "Chatting",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Container(
                                                        margin:
                                                            EdgeInsets.fromLTRB(
                                                                8, 0, 0, 10),
                                                        child: Row(
                                                          children: [
                                                            RaisedButton(
                                                              onPressed: () {
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
                                                                getlistbookingsalonsemua();
                                                              },
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              color: Colors
                                                                  .grey[300],
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          22,
                                                                          10,
                                                                          22,
                                                                          10),
                                                              child: Text(
                                                                "Cancel Booking",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            )
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
                                    )
                                  //INI BUAT STATUS TOLAK
                                  : arrsemua[index].status == 'datang'
                                      ? Column(
                                          children: <Widget>[
                                            Card(
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
                                                                  10, 10, 0, 0),
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
                                                                  .fromLTRB(10,
                                                                      0, 0, 0),
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
                                                              .fromLTRB(
                                                                  10, 20, 0, 0),
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
                                                                  .fromLTRB(10,
                                                                      3, 0, 0),
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
                                                                  .fromLTRB(10,
                                                                      3, 0, 0),
                                                            ),
                                                            RichText(
                                                              text: TextSpan(
                                                                text:
                                                                    "Status : ",
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
                                                                text: arrsemua[
                                                                        index]
                                                                    .status
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
                                                              .fromLTRB(
                                                                  8, 10, 0, 10),
                                                          child: Row(
                                                            children: [
                                                              RaisedButton(
                                                                onPressed: () {
                                                                  print(
                                                                      "ini ini selesai");
                                                                  myidupdate =
                                                                      arrsemua[
                                                                              index]
                                                                          .id;
                                                                  myStatus.text =
                                                                      "selesai";
                                                                  usernamecancel =
                                                                      "-";
                                                                  updatestatusbooking();
                                                                  getlistbookingsalonsemua();
                                                                },
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                color: Colors
                                                                        .orange[
                                                                    800],
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            50,
                                                                            10,
                                                                            50,
                                                                            10),
                                                                child: Text(
                                                                  "Selesai",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  //ini garis tengah
                                                  Container(
                                                      //color: Colors.yellow,
                                                      height: 220,
                                                      child: VerticalDivider(
                                                          color: Colors.black)),
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
                                                              margin: EdgeInsets
                                                                  .fromLTRB(10,
                                                                      0, 0, 0),
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
                                                                    .total_cancel
                                                                    .toString(),
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
                                                              .fromLTRB(
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
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  10, 0, 0, 20),
                                                          child: RichText(
                                                            maxLines: 1,
                                                            text: TextSpan(
                                                              text: hri2[index]
                                                                      .toString() +
                                                                  arrsemua[
                                                                          index]
                                                                      .tanggalbooking,
                                                              style: TextStyle(
                                                                  fontSize: 15,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  10, 0, 0, 5),
                                                          child: RichText(
                                                            maxLines: 1,
                                                            text: TextSpan(
                                                              text:
                                                                  "Jam Booking",
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
                                                        Container(
                                                          margin: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 0, 0, 50),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
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
