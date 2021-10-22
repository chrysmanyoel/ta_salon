import 'dart:developer';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ta_salon/ClassSalon.dart';
import 'package:ta_salon/ClassUserJoinSalonJoinJadwalsalon.dart';
import 'package:ta_salon/DetailSalon.dart';
import 'ExpandedListAnimationWidget.dart';
import 'Scrollbar.dart';
import 'ClassListBookingWithLayanan.dart';
import 'package:ta_salon/LihatSalon.dart';
import 'main_variable.dart' as main_variable;
import 'dart:async';
import 'ClassUserJoinSalonJoinJadwalsalon.dart';
import 'dart:io';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:ta_salon/dashboardadmin.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:ta_salon/warnalayer.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:path/path.dart';
//import 'package:getflutter/components/rating/gf_rating.dart';

class Pesanansaya extends StatefulWidget {
  @override
  PesanansayaState createState() => PesanansayaState();
}

class PesanansayaState extends State<Pesanansaya> {
  NumberFormat numberFormat = NumberFormat(',000');
  TextEditingController myStatus = new TextEditingController();
  TextEditingController myTgl = new TextEditingController();
  TextEditingController myTime = new TextEditingController();

  List<ClassListBookingWithLayanan> arrbooking = new List();
  List<ClassListBookingWithLayanan> arrselesai = new List();
  List<String> hri1 = new List();
  List<String> arr = ['semua', 'dibatalkan', 'selesai'];

  var hri;

  bool isStrechedDropDown = false, _like = false;
  int groupValue;
  String title = 'Select Filter Status',
      hari = "default",
      usernamecancel = "",
      myidupdate = "";

  String arrcmb = null;
  String cari = "";

  bool tampil = false;
  int _selectedIndexcarousel = 0;
  double _rating = 1;
  String foto = main_variable.ipnumber + "/gambar/default.png";

  DateTime dateTime = DateTime.now();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = new TimeOfDay.now();

  void initState() {
    super.initState();

    setState(() {
      arrselesai.add(new ClassListBookingWithLayanan(
          "id",
          "tanggal",
          "username",
          "namauser",
          "usernamesalon",
          "0",
          "tanggalbooking",
          "jambooking",
          "requestpegawai",
          "0",
          "namalayanan",
          "status",
          "pembayaran",
          "default.png",
          "jambookingselesai",
          "0",
          ""));
      arrbooking.add(new ClassListBookingWithLayanan(
          "id",
          "tanggal",
          "username",
          "namauser",
          "usernamesalon",
          "0",
          "tanggalbooking",
          "jambooking",
          "requestpegawai",
          "0",
          "namalayanan",
          "status",
          "pembayaran",
          "default.png",
          "jambookingselesai",
          "0",
          ""));
    });

    getlistbookinguser();
    getlistbookingselesai();
    print("nama user L : " + main_variable.userlogin);
  }

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

  Future<String> updatestatusbooking() async {
    Map paramData = {
      'id': myidupdate,
      'status': myStatus.text,
      'usernamecancel': usernamecancel,
      'username': main_variable.userlogin
    };
    var parameter = json.encode(paramData);
    http
        .post(main_variable.ipnumber + "/updatestatusbooking",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print("object" + res.body);
      var data = json.decode(res.body);
      var data1 = data[0]['bookinguser'];

      getlistbookinguser();
      getlistbookingselesai();

      return "";
    }).catchError((err) {
      print(err);
    });
  }

  Future<ClassListBookingWithLayanan> getlistbookinguser() async {
    List<ClassListBookingWithLayanan> arrtemp = new List();
    Map paramData = {
      'username': main_variable.userlogin,
    };
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/getlistbookingwithlayananuser",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print("body : " + res.body);
      var data = json.decode(res.body);
      data = data[0]['status'];

      for (int i = 0; i < data.length; i++) {
        ClassListBookingWithLayanan databaru = new ClassListBookingWithLayanan(
            data[i]['id'].toString(),
            data[i]['tanggal'].toString(),
            data[i]['username'].toString(),
            data[i]['namauser'].toString(),
            data[i]['usernamesalon'].toString(),
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
            data[i]['total_cancel'].toString(),
            data[i]['kota'].toString());
        arrtemp.add(databaru);

        dateTime = DateTime.parse(arrtemp[i].tanggalbooking);

        hri = DateFormat('EEEE').format(dateTime);
        if (hri.toString() == "Monday") {
          hari = 'Senin, ';
          setState(() {
            hri1.add(hari);
          });
        } else if (hri.toString() == 'Tuesday') {
          hari = "Selasa, ";
          setState(() {
            hri1.add(hari);
          });
        } else if (hri.toString() == 'Wednesday') {
          hari = "Rabu, ";
          setState(() {
            hri1.add(hari);
          });
        } else if (hri.toString() == 'Thursday') {
          hari = "Kamis, ";
          setState(() {
            hri1.add(hari);
          });
        } else if (hri.toString() == 'Friday') {
          hari = "Jumat, ";
          setState(() {
            hri1.add(hari);
          });
        } else if (hri.toString() == 'Saturday') {
          hari = "Sabtu, ";
          setState(() {
            hri1.add(hari);
          });
        } else if (hri.toString() == 'Sunday') {
          hari = "Minggu, ";
          setState(() {
            hri1.add(hari);
          });
        }
      }

      setState(() => this.arrbooking = arrtemp);
      print("ini panjang arr : " + this.arrbooking[1].usernamesalon);

      return arrtemp;
    }).catchError((err) {
      print(err);
    });
  }

  Future<ClassListBookingWithLayanan> getlistbookingselesai() async {
    List<ClassListBookingWithLayanan> arrtemp = new List();
    Map paramData = {
      'username': main_variable.userlogin,
    };
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/getlistbookingwithlayananuserselesai",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      //print(res.body.substring(100));
      var data = json.decode(res.body);
      data = data[0]['status'];

      for (int i = 0; i < data.length; i++) {
        ClassListBookingWithLayanan databaru = new ClassListBookingWithLayanan(
            data[i]['id'].toString(),
            data[i]['tanggal'].toString(),
            data[i]['username'].toString(),
            data[i]['namauser'].toString(),
            data[i]['usernamesalon'].toString(),
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
            data[i]['total_cancel'].toString(),
            data[i]['kota'].toString());
        arrtemp.add(databaru);
        // myNamauser.text = arrsemua[i].namauser;
      }
      setState(() => this.arrselesai = arrtemp);
      print("mango : " + this.arrselesai.length.toString());

      return arrtemp;
    }).catchError((err) {
      print(err);
    });
  }

  tampilan_sedangberjalan(index) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(this.context).size.height,
        child: ListView(
          children: [],
        ),
      ),
    );
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

  Widget Dropdown_filter() {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Container(
          height: 200,
          width: 400,
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Color(0xffbbbbbb)),
                          borderRadius: BorderRadius.all(Radius.circular(27))),
                      child: Column(
                        children: [
                          Container(
                              // height: 45,
                              width: double.infinity,
                              padding: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xffbbbbbb),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25))),
                              constraints: BoxConstraints(
                                minHeight: 45,
                                minWidth: double.infinity,
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Text(
                                        title,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isStrechedDropDown =
                                              !isStrechedDropDown;
                                        });
                                      },
                                      child: Icon(isStrechedDropDown
                                          ? Icons.arrow_upward
                                          : Icons.arrow_downward))
                                ],
                              )),
                          ExpandedSection(
                            expand: isStrechedDropDown,
                            height: 100,
                            child: MyScrollbar(
                              builder: (context, scrollController2) =>
                                  ListView.builder(
                                      padding: EdgeInsets.all(0),
                                      controller: scrollController2,
                                      shrinkWrap: true,
                                      itemCount: arr.length,
                                      itemBuilder: (context, index) {
                                        return RadioListTile(
                                            title: Text(arr.elementAt(index)),
                                            value: index,
                                            groupValue: groupValue,
                                            onChanged: (val) {
                                              setState(() {
                                                groupValue = val;
                                                title = arr.elementAt(index);
                                              });
                                            });
                                      }),
                            ),
                          )
                        ],
                      ),
                    )),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Warnalayer.backgroundColor,
      body: SingleChildScrollView(
        child: Container(
          child: Column(children: <Widget>[
            Transform.translate(
              offset: Offset(0.0, -(height * 0.23 - height * 0.26)),
              child: Container(
                width: width,
                padding: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(0))),
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: <Widget>[
                      TabBar(
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey[400],
                        unselectedLabelStyle: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 15),
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: Colors.blueAccent[200],
                        tabs: <Widget>[
                          Tab(
                            child: Text("Sedang Berjalan"),
                          ),
                          Tab(
                            child: Text("Riwayat"),
                          ),
                        ],
                      ),
                      Container(
                        color: Colors.transparent,
                        height: height,
                        child: TabBarView(
                          children: <Widget>[
                            //ini container besar isi nya filter sama sedang berjalan
                            Container(
                              child: ListView(
                                physics: const BouncingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics()),
                                children: [
                                  Container(
                                    color: Warnalayer.backgroundColor,
                                    child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: arrbooking.length == 0
                                            ? 1
                                            : arrbooking.length,
                                        itemBuilder: (BuildContext context,
                                                int index) =>
                                            arrbooking.length == 0
                                                ? Container(
                                                    child: Card(
                                                      elevation: 10,
                                                      shadowColor: Colors.black,
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    top: 100),
                                                            height: 350,
                                                            width: 450,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        30),
                                                                image: DecorationImage(
                                                                    image: AssetImage(
                                                                        "images/kosong.jpg"),
                                                                    fit: BoxFit
                                                                        .cover)),
                                                            child: Container(),
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(0, 10,
                                                                    0, 200),
                                                            child: Text(
                                                                "Anda Tidak Mempunyai Jadwal Hari Ini",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 20,
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                //INI TAMPILAN SEDANG BERJALAN
                                                : Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        10, 10, 10, 10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.0),
                                                    ),
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height -
                                                            610,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          padding: EdgeInsets
                                                              .fromLTRB(
                                                                  0, 5, 20, 0),
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                hri1[index]
                                                                        .toString() +
                                                                    " " +
                                                                    arrbooking[
                                                                            index]
                                                                        .tanggalbooking,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                            .grey[
                                                                        600]),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                flex: 2,
                                                                child:
                                                                    Container(
                                                                  margin: EdgeInsets
                                                                      .fromLTRB(
                                                                          10,
                                                                          0,
                                                                          10,
                                                                          10),
                                                                  child:
                                                                      ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            13.0),
                                                                    child: Image
                                                                        .network(
                                                                      main_variable
                                                                              .ipnumber +
                                                                          "/gambar/" +
                                                                          arrbooking[index]
                                                                              .foto,
                                                                      width:
                                                                          120.0,
                                                                      height:
                                                                          120,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                  flex: 3,
                                                                  child:
                                                                      Container(
                                                                    height: 130,
                                                                    // color:
                                                                    // Colors.blue,
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                            margin:
                                                                                EdgeInsets.only(top: 7),
                                                                            child: Text(
                                                                              arrbooking[index].usernamesalon + " - " + arrbooking[index].kota,
                                                                              style: TextStyle(
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 18,
                                                                                letterSpacing: 1,
                                                                              ),
                                                                            )),
                                                                        Container(
                                                                            margin:
                                                                                EdgeInsets.only(top: 12),
                                                                            child: Text(
                                                                              "Layanan : " + arrbooking[index].namalayanan,
                                                                              style: TextStyle(
                                                                                //fontWeight: FontWeight.bold,
                                                                                fontSize: 15,
                                                                                letterSpacing: 1,
                                                                              ),
                                                                            )),
                                                                        Container(
                                                                            margin:
                                                                                EdgeInsets.only(top: 7),
                                                                            child: Text(
                                                                              "Pegawai : " + arrbooking[index].requestpegawai,
                                                                              style: TextStyle(
                                                                                // fontWeight: FontWeight.bold,
                                                                                fontSize: 15,
                                                                                letterSpacing: 1,
                                                                              ),
                                                                            )),
                                                                        Container(
                                                                          margin:
                                                                              EdgeInsets.only(top: 7),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              Text(
                                                                                'Waktu        : ' + arrbooking[index].jambooking.substring(0, 5) + " - ",
                                                                                style: TextStyle(
                                                                                  fontSize: 15,
                                                                                  color: Colors.black,
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                arrbooking[index].jambookingselesai.substring(0, 5),
                                                                                style: TextStyle(
                                                                                  fontSize: 15,
                                                                                  color: Colors.black,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                            margin:
                                                                                EdgeInsets.only(top: 7),
                                                                            child: Text(
                                                                              "Rp. " + numberFormat.format(int.parse(arrbooking[index].total)) + " - " + arrbooking[index].pembayaran,
                                                                              style: TextStyle(
                                                                                //fontWeight: FontWeight.bold,
                                                                                fontSize: 15,
                                                                                letterSpacing: 1,
                                                                              ),
                                                                            )),
                                                                      ],
                                                                    ),
                                                                  ))
                                                            ],
                                                          ),
                                                        ),
                                                        Divider(
                                                          color: Colors.grey,
                                                        ),
                                                        Container(
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                  child:
                                                                      Container(
                                                                child:
                                                                    Container(
                                                                  margin: EdgeInsets
                                                                      .fromLTRB(
                                                                          20,
                                                                          0,
                                                                          0,
                                                                          10),
                                                                  child: Text(
                                                                    arrbooking[
                                                                            index]
                                                                        .status,
                                                                    style: TextStyle(
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.bold,
                                                                        color: arrbooking[index].status == "pending"
                                                                            ? Colors.orange[800]
                                                                            : arrbooking[index].status == "terima"
                                                                                ? Colors.green
                                                                                : ""),
                                                                  ),
                                                                ),
                                                              )),
                                                              //tampilan button apabila selesai maka 2 buton beri rating dan pesan lagi
                                                              arrbooking[index]
                                                                          .status ==
                                                                      "pending"
                                                                  ? Row(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              120,
                                                                          //color: Colors.green,
                                                                          margin: EdgeInsets.fromLTRB(
                                                                              8,
                                                                              0,
                                                                              0,
                                                                              10),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              RaisedButton(
                                                                                onPressed: () {
                                                                                  print("aaaaa");
                                                                                },
                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                color: Colors.red[800],
                                                                                child: Text(
                                                                                  "Reschedule",
                                                                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          width:
                                                                              100,
                                                                          //color: Colors.green,
                                                                          margin: EdgeInsets.fromLTRB(
                                                                              0,
                                                                              0,
                                                                              10,
                                                                              10),
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              RaisedButton(
                                                                                onPressed: () {
                                                                                  print("cancel booking");
                                                                                  myidupdate = arrbooking[index].id;
                                                                                  myStatus.text = "cancel";
                                                                                  usernamecancel = arrbooking[index].requestpegawai;
                                                                                  updatestatusbooking();
                                                                                },
                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                color: Colors.blue[800],
                                                                                child: Text(
                                                                                  "Cancel",
                                                                                  style: TextStyle(color: Colors.white, fontSize: 14),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    )
                                                                  : Row(
                                                                      children: [
                                                                        Container(
                                                                          width:
                                                                              165,
                                                                          //color: Colors.green,
                                                                          margin: EdgeInsets.fromLTRB(
                                                                              8,
                                                                              0,
                                                                              0,
                                                                              10),
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                const EdgeInsets.all(9.0),
                                                                            decoration:
                                                                                BoxDecoration(border: Border.all(color: Colors.grey[600])),
                                                                            child:
                                                                                Text(
                                                                              'Penilaian Telah Diberikan',
                                                                              style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        //tampilan button apabila sudah memberikan rating maka pesan lagi dan penilaian telah diberikan (itu text dikasi bordder)

                                                                        Container(
                                                                          width:
                                                                              100,
                                                                          //color: Colors.green,
                                                                          margin: EdgeInsets.fromLTRB(
                                                                              8,
                                                                              0,
                                                                              10,
                                                                              10),
                                                                          child:
                                                                              RaisedButton(
                                                                            onPressed:
                                                                                () {
                                                                              print("aaaaa");
                                                                            },
                                                                            shape:
                                                                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                            color:
                                                                                Colors.blue[800],
                                                                            child:
                                                                                Text(
                                                                              "Pesan Lagi",
                                                                              style: TextStyle(color: Colors.white, fontSize: 14),
                                                                            ),
                                                                          ),
                                                                          //tampilan button apabila sudah memberikan rating maka pesan lagi dan penilaian telah diberikan (itu text dikasi bordder)
                                                                        )
                                                                      ],
                                                                    )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                  ),
                                ],
                              ),
                            ),

                            //Riwayaat
                            Container(
                              child: ListView(
                                children: [
                                  //Sedang berjalan
                                  // Container(
                                  //   child: _buildPanel(),
                                  // ),
                                  Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                              child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color(0xffbbbbbb)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(27))),
                                            child: Column(
                                              children: [
                                                Container(
                                                    // height: 45,
                                                    width: double.infinity,
                                                    padding: EdgeInsets.only(
                                                        right: 10),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color:
                                                              Color(0xffbbbbbb),
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    25))),
                                                    constraints: BoxConstraints(
                                                      minHeight: 45,
                                                      minWidth: double.infinity,
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 10),
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    isStrechedDropDown =
                                                                        !isStrechedDropDown;
                                                                  });
                                                                },
                                                                child: Text(
                                                                  title,
                                                                ),
                                                              )),
                                                        ),
                                                        GestureDetector(
                                                            onTap: () {
                                                              setState(() {
                                                                isStrechedDropDown =
                                                                    !isStrechedDropDown;
                                                              });
                                                            },
                                                            child: Icon(isStrechedDropDown
                                                                ? Icons
                                                                    .arrow_upward
                                                                : Icons
                                                                    .arrow_downward))
                                                      ],
                                                    )),
                                                ExpandedSection(
                                                  expand: isStrechedDropDown,
                                                  height: 100,
                                                  child: MyScrollbar(
                                                    builder: (context,
                                                            scrollController2) =>
                                                        ListView.builder(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    0),
                                                            controller:
                                                                scrollController2,
                                                            shrinkWrap: true,
                                                            itemCount:
                                                                arr.length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return RadioListTile(
                                                                  title: Text(
                                                                      arr.elementAt(
                                                                          index)),
                                                                  value: index,
                                                                  groupValue:
                                                                      groupValue,
                                                                  onChanged:
                                                                      (val) {
                                                                    setState(
                                                                        () {
                                                                      groupValue =
                                                                          val;
                                                                      cari = arr[
                                                                          val];
                                                                      print("ini cari : " +
                                                                          cari);
                                                                      title = arr
                                                                          .elementAt(
                                                                              index);
                                                                      isStrechedDropDown =
                                                                          !isStrechedDropDown;
                                                                    });
                                                                  });
                                                            }),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                        ],
                                      )
                                    ],
                                  ),
                                  Container(
                                    color: Warnalayer.backgroundColor,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: arrselesai.length == 0
                                            ? 1
                                            : arrselesai.length,
                                        itemBuilder:
                                            (BuildContext context, int index) =>
                                                arrselesai.length == 0
                                                    ? Container(
                                                        child: Card(
                                                          elevation: 10,
                                                          shadowColor:
                                                              Colors.black,
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            100),
                                                                height: 350,
                                                                width: 450,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30),
                                                                    image: DecorationImage(
                                                                        image: AssetImage(
                                                                            "images/kosong.jpg"),
                                                                        fit: BoxFit
                                                                            .cover)),
                                                                child:
                                                                    Container(),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .fromLTRB(
                                                                        0,
                                                                        10,
                                                                        0,
                                                                        200),
                                                                child: Text(
                                                                    "Anda Tidak Mempunyai Jadwal Hari Ini",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                    )),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .transparent,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                              ),
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  print("ini jum arrboking.length " +
                                                                      arrselesai[
                                                                              index]
                                                                          .usernamesalon
                                                                          .toString());
                                                                },
                                                                child: Stack(
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      margin: EdgeInsets.fromLTRB(
                                                                          10.0,
                                                                          5.0,
                                                                          10.0,
                                                                          0.0),
                                                                      width:
                                                                          400,
                                                                      height:
                                                                          140,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(20.0),
                                                                      ),
                                                                      child:
                                                                          Row(
                                                                        children: <
                                                                            Widget>[
                                                                          Container(
                                                                            margin:
                                                                                EdgeInsets.all(10),
                                                                            child:
                                                                                ClipRRect(
                                                                              borderRadius: BorderRadius.circular(13.0),
                                                                              child: Image.network(
                                                                                main_variable.ipnumber + "/gambar/" + arrselesai[index].foto,
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
                                                                                10,
                                                                                0,
                                                                                0,
                                                                                0),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Container(
                                                                                  child: Text(
                                                                                    arrselesai[index].usernamesalon,
                                                                                    style: TextStyle(
                                                                                      fontSize: 18.0,
                                                                                      fontWeight: FontWeight.w600,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                                                                  child: Text(
                                                                                    'Layanan        : ' + arrselesai[index].namalayanan,
                                                                                    style: TextStyle(
                                                                                      fontSize: 16,
                                                                                      color: Colors.grey,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  margin: EdgeInsets.fromLTRB(0, 0, 50, 0),
                                                                                  child: Text(
                                                                                    'Pembayaran : ' + arrselesai[index].pembayaran,
                                                                                    style: TextStyle(
                                                                                      fontSize: 16,
                                                                                      color: Colors.grey,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  margin: EdgeInsets.fromLTRB(0, 0, 50, 0),
                                                                                  child: Text(
                                                                                    'Total : Rp. ' + numberFormat.format(int.parse(arrselesai[index].total)),
                                                                                    style: TextStyle(
                                                                                      fontSize: 16,
                                                                                      color: Colors.grey,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  padding: EdgeInsets.only(top: 10),
                                                                                ),
                                                                                Row(
                                                                                  children: [
                                                                                    TextButton(
                                                                                      onPressed: () {
                                                                                        print("button1");
                                                                                      },
                                                                                      style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), primary: Colors.white, backgroundColor: Color(0xff374ABE)),
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Text(
                                                                                            "Beri penilaian",
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Container(
                                                                                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                                                                    ),
                                                                                    TextButton(
                                                                                      onPressed: () {
                                                                                        print("button 2");
                                                                                      },
                                                                                      style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), primary: Colors.white, backgroundColor: Colors.red[600]),
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
                                                            )
                                                          ],
                                                        ),
                                                      )),
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
            ),
          ]),
        ),
      ),
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
                  // Container(
                  //   margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: <Widget>[
                  //       Text(
                  //         "Tanggal Booking :",
                  //         style: TextStyle(
                  //             fontSize: 16,
                  //             letterSpacing: 1.2,
                  //             color: Colors.black),
                  //       ),
                  //       SizedBox(
                  //         height: 5,
                  //       ),
                  //     ],
                  //   ),
                  // ),
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
                  // Container(
                  //   margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: <Widget>[
                  //       Text(
                  //         "Jam Booking :",
                  //         style: TextStyle(
                  //             fontSize: 16,
                  //             letterSpacing: 1.2,
                  //             color: Colors.black),
                  //       ),
                  //       SizedBox(
                  //         height: 5,
                  //       ),
                  //     ],
                  //   ),
                  // ),
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
}
