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
  TextEditingController myEmail = new TextEditingController();
  TextEditingController myUsername = new TextEditingController();
  TextEditingController myNama = new TextEditingController();
  TextEditingController mySalon = new TextEditingController();
  TextEditingController myAlamat = new TextEditingController();

  List<ClassListBookingWithLayanan> arrbooking = new List();
  List<ClassListBookingWithLayanan> arrselesai = new List();
  List<String> hri1 = new List();
  List<String> arr = ['semua', 'dibatalkan', 'selesai'];

  DateTime dateTime = DateTime.now();
  var hri;

  bool isStrechedDropDown = false;
  int groupValue;
  String title = 'Select Filter Status', hari = "default";

  String arrcmb = null;
  String cari = "";

  bool tampil = false;
  int _selectedIndexcarousel = 0;
  double _rating = 1;
  String foto = main_variable.ipnumber + "/gambar/default.png";

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
    print(main_variable.userlogin);
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
      var data = json.decode(res.body);
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
            data[i]['total_cancel'].toString(),
            data[i]['kota'].toString());
        arrtemp.add(databaru);
        print("ini data arr : " + arrtemp[0].usernamesalon);

        dateTime = DateTime.parse(arrtemp[i].tanggalbooking);
        print("ini jumlah " +
            i.toString() +
            ": " +
            arrtemp[i].total_cancel.toString());

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

      print("ini panjang arr : " + arrtemp.length.toString());

      setState(() => this.arrbooking = arrtemp);

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

  Widget _buildPanel() {
    return Container(
      child: ExpansionPanelList(
          animationDuration: Duration(milliseconds: 2000),
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              tampil = !tampil;
            });
          },
          children: [
            ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text("Filter Data"),
                );
              },
              body: Column(
                children: [
                  ListTile(
                      title: Text(arr[0].toString()),
                      subtitle:
                          const Text('Menampilkan Semua Pemesanan Booking'),
                      //trailing: const Icon(Icons.delete),
                      onTap: () {
                        cari = arr[0].toString();
                        print("ini cari : " + cari);
                      }),
                  ListTile(
                      title: Text(arr[1].toString()),
                      subtitle: const Text(
                          'Menampilkan Pemesanan Booking Dengan Status Cancel'),
                      //trailing: const Icon(Icons.delete),
                      onTap: () {
                        cari = arr[1].toString();
                        print("ini cari : " + cari);
                      }),
                  ListTile(
                      title: Text(arr[2].toString()),
                      subtitle: const Text(
                          'Menampilkan Pemesanan Booking Dengan Status Selesai'),
                      //trailing: const Icon(Icons.delete),
                      onTap: () {
                        cari = arr[2].toString();
                        print("ini cari : " + cari);
                      }),
                ],
              ),
              isExpanded: tampil,
            ),
          ]),
    );
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
                                children: [
                                  //Sedang berjalan
                                  // Container(
                                  //   child: _buildPanel(),
                                  // ),
                                  Container(
                                    color: Warnalayer.backgroundColor,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      itemCount: arrbooking.length == 0
                                          ? 1
                                          : arrbooking.length,
                                      itemBuilder:
                                          (BuildContext context, int index) =>
                                              arrbooking.length == 1
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
                                                                      top: 100),
                                                              height: 350,
                                                              width: 450,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
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
                                                  //INI TAMPILAN SEDANG BERJALAN
                                                  : Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .height,
                                                      // color: Colors.red,
                                                      child: ListView(
                                                        children: [
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Container(
                                                            margin: EdgeInsets
                                                                .fromLTRB(10, 0,
                                                                    10, 10),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20.0),
                                                            ),
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height -
                                                                610,
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  padding: EdgeInsets
                                                                      .fromLTRB(
                                                                          0,
                                                                          5,
                                                                          20,
                                                                          0),
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  //  color: Colors
//.teal,
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .end,
                                                                    children: [
                                                                      Text(
                                                                        hari.toString() +
                                                                            " " +
                                                                            arrbooking[index].tanggalbooking,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.grey[600]),
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
                                                                          margin: EdgeInsets.fromLTRB(
                                                                              10,
                                                                              0,
                                                                              10,
                                                                              10),
                                                                          child:
                                                                              ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(13.0),
                                                                            child:
                                                                                Image.network(
                                                                              main_variable.ipnumber + "/gambar/" + arrbooking[index].foto,
                                                                              width: 120.0,
                                                                              height: 120,
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                          flex:
                                                                              3,
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                130,
                                                                            // color:
                                                                            // Colors.blue,
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Container(
                                                                                    margin: EdgeInsets.only(top: 7),
                                                                                    child: Text(
                                                                                      arrbooking[index].usernamesalon + " - " + arrbooking[index].kota,
                                                                                      style: TextStyle(
                                                                                        fontWeight: FontWeight.bold,
                                                                                        fontSize: 18,
                                                                                        letterSpacing: 1,
                                                                                      ),
                                                                                    )),
                                                                                Container(
                                                                                    margin: EdgeInsets.only(top: 12),
                                                                                    child: Text(
                                                                                      "Layanan : " + arrbooking[index].namalayanan,
                                                                                      style: TextStyle(
                                                                                        //fontWeight: FontWeight.bold,
                                                                                        fontSize: 15,
                                                                                        letterSpacing: 1,
                                                                                      ),
                                                                                    )),
                                                                                Container(
                                                                                    margin: EdgeInsets.only(top: 7),
                                                                                    child: Text(
                                                                                      "Pegawai : " + arrbooking[index].requestpegawai,
                                                                                      style: TextStyle(
                                                                                        // fontWeight: FontWeight.bold,
                                                                                        fontSize: 15,
                                                                                        letterSpacing: 1,
                                                                                      ),
                                                                                    )),
                                                                                Container(
                                                                                    margin: EdgeInsets.only(top: 7),
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
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                Container(
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                          child:
                                                                              Container(
                                                                        child:
                                                                            Container(
                                                                          margin: EdgeInsets.fromLTRB(
                                                                              20,
                                                                              0,
                                                                              0,
                                                                              10),
                                                                          child:
                                                                              Text(
                                                                            arrbooking[index].status,
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
                                                                      arrbooking[index].status ==
                                                                              "pending"
                                                                          ? Row(
                                                                              children: [
                                                                                Container(
                                                                                  width: 120,
                                                                                  //color: Colors.green,
                                                                                  margin: EdgeInsets.fromLTRB(8, 0, 0, 10),
                                                                                  child: Row(
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
                                                                                  width: 100,
                                                                                  //color: Colors.green,
                                                                                  margin: EdgeInsets.fromLTRB(0, 0, 10, 10),
                                                                                  child: Row(
                                                                                    children: [
                                                                                      RaisedButton(
                                                                                        onPressed: () {
                                                                                          print("aaaaa");
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
                                                                                  width: 165,
                                                                                  //color: Colors.green,
                                                                                  margin: EdgeInsets.fromLTRB(8, 0, 0, 10),
                                                                                  child: Container(
                                                                                    padding: const EdgeInsets.all(9.0),
                                                                                    decoration: BoxDecoration(border: Border.all(color: Colors.grey[600])),
                                                                                    child: Text(
                                                                                      'Penilaian Telah Diberikan',
                                                                                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                //tampilan button apabila sudah memberikan rating maka pesan lagi dan penilaian telah diberikan (itu text dikasi bordder)

                                                                                Container(
                                                                                  width: 100,
                                                                                  //color: Colors.green,
                                                                                  margin: EdgeInsets.fromLTRB(8, 0, 10, 10),
                                                                                  child: RaisedButton(
                                                                                    onPressed: () {
                                                                                      print("aaaaa");
                                                                                    },
                                                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                    color: Colors.blue[800],
                                                                                    child: Text(
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
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                    ),
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
                                                arrselesai.length == 1
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
}
