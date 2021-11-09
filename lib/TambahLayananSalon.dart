import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ta_salon/DashboardSalon.dart';
import 'main_variable.dart' as main_variable;
import 'dart:async';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ta_salon/ClassUser.dart';
import 'ExpandedListAnimationWidget.dart';
import 'Scrollbar.dart';
import 'package:ta_salon/ClassSalon.dart';
import 'package:ta_salon/ClassLayanansalon.dart';
import 'ClassLayanansalon.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'ClassKategori.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:ta_salon/warnalayer.dart';
import 'package:path/path.dart';
import 'package:flutter/src/material/dropdown.dart';

class TambahLayananSalon extends StatefulWidget {
  @override
  TambahLayananSalonState createState() => TambahLayananSalonState();
}

class TambahLayananSalonState extends State<TambahLayananSalon> {
  ClassKategori selectedKategori;
  ClassLayanansalon datalama = new ClassLayanansalon(
      "", "", "", "", '', "", "", "", "", "", "", "", "", "", '', '', '');

  TextEditingController myUsername = new TextEditingController();
  TextEditingController myNamalayanan = new TextEditingController();
  TextEditingController myJenjangusia = new TextEditingController();
  TextEditingController myHargapriadewasa = new TextEditingController();
  TextEditingController myHargapriaanak = new TextEditingController();
  TextEditingController myJumKursi = new TextEditingController();
  TextEditingController myBatasKeterlambatan = new TextEditingController();
  TextEditingController myHargawanitadewasa = new TextEditingController();
  TextEditingController myHargawanitaanak = new TextEditingController();
  TextEditingController myDurasi = new TextEditingController();
  TextEditingController myDeskripsi = new TextEditingController();

  double _rating = 1, tempcombobox = 850;

  int _radioValue = 0, _radioValue1 = 0, _radioValue2 = 0;

  bool isStrechedDropDown = false, isAktif = true, isNonAktif = false;
  int groupValue;
  String title = 'Select Kategori Layanan';

  String peruntukan = "", jenjang = "", status = "", kategori, ckategori = "";

  bool aktifpriadewasa = true,
      aktifwanitadewasa = true,
      aktifpriaanak = true,
      aktifwanitaanak = true,
      bolehinsert = false;

  String foto = main_variable.ipnumber + "/gambar/default.png";
  File _image;

  List<ClassKategori> arrkategori = new List();
  List<ClassLayanansalon> arr = new List();

  void initState() {
    super.initState();
    //print("kat : " + jenjang);
    setState(() {
      arrkategori.add(new ClassKategori("id", "idkategori", "namakategori"));
      arr.add(new ClassLayanansalon(
          "id",
          "0",
          "username",
          "namalayanan",
          "peruntukan",
          'idkategori',
          '0',
          '0',
          'deskripsi',
          'status',
          '0',
          '0',
          '0',
          '0',
          '0',
          '0',
          'default.png'));
    });

    getallkategori();
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      if (_radioValue1 == 0 && _radioValue == 0) {
        jenjang = "dewasa";
        peruntukan = "pria";
        myHargawanitadewasa.text = "0";
        myHargawanitaanak.text = "0";
        myHargapriaanak.text = "0";
        myHargapriadewasa.text = "";

        aktifpriadewasa = true;
        aktifpriaanak = false;
        aktifwanitaanak = false;
        aktifwanitadewasa = false;
      } else if (_radioValue1 == 1 && _radioValue == 0) {
        jenjang = "anak-anak";
        peruntukan = "pria";
        myHargawanitadewasa.text = "0";
        myHargawanitaanak.text = "0";
        myHargapriaanak.text = "";
        myHargapriadewasa.text = "0";

        aktifpriadewasa = false;
        aktifpriaanak = true;
        aktifwanitaanak = false;
        aktifwanitadewasa = false;
      } else if (_radioValue1 == 2 && _radioValue == 0) {
        jenjang = "semua";
        peruntukan = "pria";
        myHargawanitadewasa.text = "0";
        myHargawanitaanak.text = "0";
        myHargapriaanak.text = "";
        myHargapriadewasa.text = "";

        aktifpriadewasa = true;
        aktifpriaanak = true;
        aktifwanitaanak = false;
        aktifwanitadewasa = false;
      } else if (_radioValue1 == 0 && _radioValue == 1) {
        jenjang = "dewasa";
        peruntukan = "wanita";
        myHargawanitadewasa.text = "";
        myHargawanitaanak.text = "0";
        myHargapriaanak.text = "0";
        myHargapriadewasa.text = "0";

        aktifpriadewasa = false;
        aktifpriaanak = false;
        aktifwanitaanak = false;
        aktifwanitadewasa = true;
      } else if (_radioValue1 == 1 && _radioValue == 1) {
        jenjang = "anak-anak";
        peruntukan = "wanita";
        myHargawanitadewasa.text = "0";
        myHargawanitaanak.text = "";
        myHargapriaanak.text = "0";
        myHargapriadewasa.text = "0";

        aktifpriadewasa = false;
        aktifpriaanak = false;
        aktifwanitaanak = true;
        aktifwanitadewasa = false;
      } else if (_radioValue1 == 2 && _radioValue == 1) {
        jenjang = "semua";
        peruntukan = "wanita";
        myHargawanitadewasa.text = "";
        myHargawanitaanak.text = "";
        myHargapriaanak.text = "0";
        myHargapriadewasa.text = "0";

        aktifpriadewasa = false;
        aktifpriaanak = false;
        aktifwanitaanak = true;
        aktifwanitadewasa = true;
      } else if (_radioValue1 == 0 && _radioValue == 2) {
        jenjang = "dewasa";
        peruntukan = "semua";
        myHargawanitadewasa.text = "";
        myHargawanitaanak.text = "0";
        myHargapriaanak.text = "0";
        myHargapriadewasa.text = "";

        aktifpriadewasa = true;
        aktifpriaanak = false;
        aktifwanitaanak = false;
        aktifwanitadewasa = true;
      } else if (_radioValue1 == 1 && _radioValue == 2) {
        jenjang = "anak-anak";
        peruntukan = "semua";
        myHargawanitadewasa.text = "0";
        myHargawanitaanak.text = "";
        myHargapriaanak.text = "";
        myHargapriadewasa.text = "0";

        aktifpriadewasa = false;
        aktifpriaanak = true;
        aktifwanitaanak = true;
        aktifwanitadewasa = false;
      } else if (_radioValue1 == 2 && _radioValue == 2) {
        jenjang = "semua";
        peruntukan = "semua";
        myHargawanitadewasa.text = "";
        myHargawanitaanak.text = "";
        myHargapriaanak.text = "";
        myHargapriadewasa.text = "";

        aktifpriadewasa = true;
        aktifpriaanak = true;
        aktifwanitaanak = true;
        aktifwanitadewasa = true;
      }
    });
  }

  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue1 = value;

      if (_radioValue1 == 0 && _radioValue == 0) {
        jenjang = "dewasa";
        peruntukan = "pria";
        myHargawanitadewasa.text = "0";
        myHargawanitaanak.text = "0";
        myHargapriaanak.text = "0";
        myHargapriadewasa.text = "";

        aktifpriadewasa = true;
        aktifpriaanak = false;
        aktifwanitaanak = false;
        aktifwanitadewasa = false;
      } else if (_radioValue1 == 1 && _radioValue == 0) {
        jenjang = "anak-anak";
        peruntukan = "pria";
        myHargawanitadewasa.text = "0";
        myHargawanitaanak.text = "0";
        myHargapriaanak.text = "";
        myHargapriadewasa.text = "0";

        aktifpriadewasa = false;
        aktifpriaanak = true;
        aktifwanitaanak = false;
        aktifwanitadewasa = false;
      } else if (_radioValue1 == 2 && _radioValue == 0) {
        jenjang = "semua";
        peruntukan = "pria";
        myHargawanitadewasa.text = "0";
        myHargawanitaanak.text = "0";
        myHargapriaanak.text = "";
        myHargapriadewasa.text = "";

        aktifpriadewasa = true;
        aktifpriaanak = true;
        aktifwanitaanak = false;
        aktifwanitadewasa = false;
      } else if (_radioValue1 == 0 && _radioValue == 1) {
        jenjang = "dewasa";
        peruntukan = "wanita";
        myHargawanitadewasa.text = "";
        myHargawanitaanak.text = "0";
        myHargapriaanak.text = "0";
        myHargapriadewasa.text = "0";

        aktifpriadewasa = false;
        aktifpriaanak = false;
        aktifwanitaanak = false;
        aktifwanitadewasa = true;
      } else if (_radioValue1 == 1 && _radioValue == 1) {
        jenjang = "anak-anak";
        peruntukan = "wanita";
        myHargawanitadewasa.text = "0";
        myHargawanitaanak.text = "";
        myHargapriaanak.text = "0";
        myHargapriadewasa.text = "0";

        aktifpriadewasa = false;
        aktifpriaanak = false;
        aktifwanitaanak = true;
        aktifwanitadewasa = false;
      } else if (_radioValue1 == 2 && _radioValue == 1) {
        jenjang = "semua";
        peruntukan = "wanita";
        myHargawanitadewasa.text = "";
        myHargawanitaanak.text = "";
        myHargapriaanak.text = "0";
        myHargapriadewasa.text = "0";

        aktifpriadewasa = false;
        aktifpriaanak = false;
        aktifwanitaanak = true;
        aktifwanitadewasa = true;
      } else if (_radioValue1 == 0 && _radioValue == 2) {
        jenjang = "dewasa";
        peruntukan = "semua";
        myHargawanitadewasa.text = "";
        myHargawanitaanak.text = "0";
        myHargapriaanak.text = "0";
        myHargapriadewasa.text = "";

        aktifpriadewasa = true;
        aktifpriaanak = false;
        aktifwanitaanak = false;
        aktifwanitadewasa = true;
      } else if (_radioValue1 == 1 && _radioValue == 2) {
        jenjang = "anak-anak";
        peruntukan = "semua";
        myHargawanitadewasa.text = "0";
        myHargawanitaanak.text = "";
        myHargapriaanak.text = "";
        myHargapriadewasa.text = "0";

        aktifpriadewasa = false;
        aktifpriaanak = true;
        aktifwanitaanak = true;
        aktifwanitadewasa = false;
      } else if (_radioValue1 == 2 && _radioValue == 2) {
        jenjang = "semua";
        peruntukan = "semua";
        myHargawanitadewasa.text = "";
        myHargawanitaanak.text = "";
        myHargapriaanak.text = "";
        myHargapriadewasa.text = "";

        aktifpriadewasa = true;
        aktifpriaanak = true;
        aktifwanitaanak = true;
        aktifwanitadewasa = true;
      }
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

  Future<ClassLayanansalon> insertlayanansalon() async {
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
      'idsalon': main_variable.idsalonlogin,
      'username': main_variable.userlogin,
      'namalayanan': myNamalayanan.text,
      'jumlah_kursi': myJumKursi.text,
      'idkategori': ckategori,
      'jenjangusia': jenjang,
      'peruntukan': peruntukan,
      'hargapriadewasa': myHargapriadewasa.text,
      'hargawanitadewasa': myHargawanitadewasa.text,
      'hargawanitaanak': myHargawanitaanak.text,
      'hargapriaanak': myHargapriaanak.text,
      'durasi': myDurasi.text,
      'deskripsi': myDeskripsi.text,
      'status': status,
      'keterlambatan_waktu': myBatasKeterlambatan.text,
      'mfile': fileName,
      'mimage': base64Image
    };
    var parameter = json.encode(paramData);

    ClassLayanansalon databaru = new ClassLayanansalon(
        "id",
        'idsalon',
        "username",
        "namalayanan",
        "idkategori",
        "jenjangusia",
        "peruntukan",
        "hargapriadewasa",
        "hargawanitadewasa",
        "hargawanitaanak",
        "hargapriaanak",
        "durasi",
        "deskripsi",
        "status",
        "jumlah_kursi",
        "keterlambatan_waktu",
        "default.png");

    http
        .post(main_variable.ipnumber + "/insertlayanansalon",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body.substring(100));
      var data = json.decode(res.body);
      data = data[0]['status'];

      if (data == "gagal") {
        Fluttertoast.showToast(
            msg: "Nama Layanan Sudah Ada",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Berhasil Memasukan Layanan",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.blue[300],
            textColor: Colors.white,
            fontSize: 16.0);
      }

      return data;
    }).catchError((err) {
      print(err);
    });
  }

  Future<ClassKategori> getallkategori() async {
    List<ClassKategori> arrtemp = new List();
    Map paramData = {};
    var parameter = json.encode(paramData);

    ClassKategori databaru = new ClassKategori(
      "id",
      "idkategori",
      "namakategori",
    );

    http
        .post(main_variable.ipnumber + "/getallkategori",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];
      print(res.body);
      print(data.length);

      for (int i = 0; i < data.length; i++) {
        databaru = ClassKategori(
            data[i]['id'].toString(),
            data[i]['idkategori'].toString(),
            data[i]['namakategori'].toString());
        arrtemp.add(databaru);
      }
      setState(() => this.arrkategori = arrtemp);

      return arrtemp;
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warnalayer.backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Tambah Layanan Salon ",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white54,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 650,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 5.0),
                  height: 150.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(130.0, 18.0, 0.0, 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              width: 100.0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Nama Layanan : ",
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                  width: 130.0,
                                  child: Text(
                                    myNamalayanan.text,
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              width: 100.0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Kategori            : ",
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 130.0,
                              child: Text(
                                ckategori,
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              width: 100.0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Jenjang             : ",
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 130.0,
                              child: Text(
                                jenjang,
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              width: 100.0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Deskripsi           : ",
                                    style: TextStyle(
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 130.0,
                              child: Text(
                                myDeskripsi.text,
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            RaisedButton(
                              onPressed: () {},
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
                                      maxWidth: 100.0, minHeight: 35.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Booking",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.0),
                            RaisedButton(
                              onPressed: () {},
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
                                      maxWidth: 100.0, minHeight: 35.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Edit",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Stack(
                  fit: StackFit.expand,
                  overflow: Overflow.visible,
                  children: [
                    SizedBox(height: 50),
                    Positioned(
                      left: 20.0,
                      top: 35.0,
                      bottom: 20.0,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: _image == null
                              ? Image.network(
                                  this.foto,
                                  width: 110,
                                  height: 110,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(_image)),
                    ),
                    Positioned(
                      right: 250,
                      bottom: 10,
                      child: SizedBox(
                        height: 46,
                        width: 46,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                            side: BorderSide(color: Colors.grey),
                          ),
                          color: Colors.grey[350],
                          onPressed: () {
                            getImageFromGallery();
                          },
                          child: SvgPicture.asset(
                            "assets/icons/Camera Icon.svg",
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Positioned(
                  left: 140.0,
                  top: 10.0,
                  bottom: 145.0,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                        width: 150,
                        padding: EdgeInsets.fromLTRB(10, 7, 10, 0),
                        color: Colors.blue[100],
                        child: Text(
                          "Tampilan Layanan",
                          style: TextStyle(
                              fontSize: 15,
                              letterSpacing: 1,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            color: Colors.teal.shade100,
            thickness: 1.0,
          ),
          Container(
            child: Text(
              '--- Field Pengisian Layanan Salon ---',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                //fontWeight: FontWeight.bold,
                foreground: Paint()..color = Colors.black,
                letterSpacing: 1.5,
              ),
            ),
          ),
          Divider(
            color: Colors.teal.shade100,
            thickness: 1.0,
          ),
          Container(
            //color: Colors.amber,
            width: MediaQuery.of(context).size.width,
            height: tempcombobox,
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 5.0),
                  height: tempcombobox,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 20, 0, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: Text(
                                  "Nama Layanan : ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                      color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: SizedBox(
                                  width: 210,
                                  height: 40,
                                  child: buildTextField(
                                      MaterialCommunityIcons.book,
                                      "Nama Layanan",
                                      false,
                                      false,
                                      true,
                                      myNamalayanan),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    child: Container(
                                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Color(0xffbbbbbb)),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25))),
                                  child: Column(
                                    children: [
                                      Container(
                                          //width: double.infinity,
                                          width: 350,
                                          padding: EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Color(0xffbbbbbb),
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(25))),
                                          constraints: BoxConstraints(
                                            minHeight: 35,
                                            minWidth: double.infinity,
                                          ),
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20,
                                                        vertical: 10),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          if (isStrechedDropDown ==
                                                              true) {
                                                            tempcombobox = 980;
                                                          } else {
                                                            tempcombobox = 850;
                                                          }
                                                          isStrechedDropDown =
                                                              !isStrechedDropDown;
                                                          if (isStrechedDropDown ==
                                                              true) {
                                                            tempcombobox = 980;
                                                          } else {
                                                            tempcombobox = 850;
                                                          }
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
                                                      if (isStrechedDropDown ==
                                                          true) {
                                                        tempcombobox = 980;
                                                      } else {
                                                        tempcombobox = 850;
                                                      }
                                                      isStrechedDropDown =
                                                          !isStrechedDropDown;
                                                      if (isStrechedDropDown ==
                                                          true) {
                                                        tempcombobox = 980;
                                                      } else {
                                                        tempcombobox = 850;
                                                      }
                                                    });
                                                  },
                                                  child: Icon(isStrechedDropDown
                                                      ? Icons.arrow_upward
                                                      : Icons.arrow_downward))
                                            ],
                                          )),
                                      ExpandedSection(
                                        expand: isStrechedDropDown,
                                        height: 10,
                                        child: MyScrollbar(
                                          builder: (context,
                                                  scrollController2) =>
                                              ListView.builder(
                                                  padding: EdgeInsets.all(0),
                                                  controller: scrollController2,
                                                  shrinkWrap: true,
                                                  itemCount: arrkategori.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return RadioListTile(
                                                        title: Text(
                                                          arrkategori[index]
                                                                  .idkategori
                                                                  .toString() +
                                                              " - " +
                                                              arrkategori[index]
                                                                  .namakategori
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontSize: 14),
                                                        ),
                                                        value: index,
                                                        groupValue: groupValue,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            groupValue = val;
                                                            title = arrkategori[
                                                                        index]
                                                                    .idkategori
                                                                    .toString() +
                                                                " - " +
                                                                arrkategori[
                                                                        index]
                                                                    .namakategori
                                                                    .toString();
                                                            ckategori =
                                                                arrkategori[
                                                                        index]
                                                                    .idkategori
                                                                    .toString();
                                                            if (isStrechedDropDown ==
                                                                true) {
                                                              tempcombobox =
                                                                  980;
                                                            } else {
                                                              tempcombobox =
                                                                  800;
                                                            }
                                                            isStrechedDropDown =
                                                                !isStrechedDropDown;
                                                            if (isStrechedDropDown ==
                                                                true) {
                                                              tempcombobox =
                                                                  980;
                                                            } else {
                                                              tempcombobox =
                                                                  800;
                                                            }
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
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: Text(
                                  "Peruntukan ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                      color: Colors.black),
                                ),
                              ),
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  new Radio(
                                    value: 0,
                                    groupValue: _radioValue,
                                    onChanged: _handleRadioValueChange,
                                  ),
                                  new Text(
                                    'PRIA',
                                    style: new TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  new Radio(
                                    value: 1,
                                    groupValue: _radioValue,
                                    onChanged: _handleRadioValueChange,
                                  ),
                                  new Text(
                                    'WANITA',
                                    style: new TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  new Radio(
                                    value: 2,
                                    groupValue: _radioValue,
                                    onChanged: _handleRadioValueChange,
                                  ),
                                  new Text(
                                    'SEMUA',
                                    style: new TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: Text(
                                  "Jenjang Usia ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                      color: Colors.black),
                                ),
                              ),
                              new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  new Radio(
                                    value: 0,
                                    groupValue: _radioValue1,
                                    onChanged: _handleRadioValueChange1,
                                  ),
                                  new Text(
                                    'DEWASA',
                                    style: new TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  new Radio(
                                    value: 1,
                                    groupValue: _radioValue1,
                                    onChanged: _handleRadioValueChange1,
                                  ),
                                  new Text(
                                    'ANAK-ANAK',
                                    style: new TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  new Radio(
                                    value: 2,
                                    groupValue: _radioValue1,
                                    onChanged: _handleRadioValueChange1,
                                  ),
                                  new Text(
                                    'SEMUA',
                                    style: new TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                          child: Text(
                            "Harga Layanan : ",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: Colors.black),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 20, 0, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: SizedBox(
                                  width: 160,
                                  height: 40,
                                  child: buildTextField(
                                      Icons.attach_money_rounded,
                                      "Pria Dewasa",
                                      false,
                                      false,
                                      aktifpriadewasa,
                                      myHargapriadewasa),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: SizedBox(
                                  width: 168,
                                  height: 40,
                                  child: buildTextField(
                                      Icons.attach_money_rounded,
                                      "Anak Laki-Laki",
                                      false,
                                      false,
                                      aktifpriaanak,
                                      myHargapriaanak),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 10, 0, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: SizedBox(
                                  width: 160,
                                  height: 40,
                                  child: buildTextField(
                                      Icons.attach_money_rounded,
                                      "Wanita Dewasa",
                                      false,
                                      false,
                                      aktifwanitadewasa,
                                      myHargawanitadewasa),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: SizedBox(
                                  width: 168,
                                  height: 40,
                                  child: buildTextField(
                                      Icons.attach_money_rounded,
                                      "Anak Perempuan",
                                      false,
                                      false,
                                      aktifwanitaanak,
                                      myHargawanitaanak),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 10, 5, 0),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "*Jumlah kursi yang tersedia dalam layanan yang di daftarkan",
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 5, 0, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: Text(
                                  "Jumlah Kursi           : ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                      color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: SizedBox(
                                  width: 170,
                                  height: 40,
                                  child: buildTextField(
                                      MaterialCommunityIcons.chair_school,
                                      "Jumlah Kursi",
                                      false,
                                      false,
                                      true,
                                      myJumKursi),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 10, 5, 0),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "*Perkiraan lamanya waktu sebuah layanan dalam satuan menit ",
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 5, 0, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: Text(
                                  "Durasi Layanan        : ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                      color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: SizedBox(
                                  width: 170,
                                  height: 40,
                                  child: buildTextField(
                                      MaterialCommunityIcons.timer,
                                      "Durasi Layanan",
                                      false,
                                      false,
                                      true,
                                      myDurasi),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 10, 5, 0),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "*Batas waktu keterlambatan customer dalam satuan menit",
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(15, 5, 0, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: Text(
                                  "Batas Keterlambatan : ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                      color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: SizedBox(
                                  width: 170,
                                  height: 40,
                                  child: buildTextField(
                                      MaterialCommunityIcons.timer,
                                      "Maks Terlambat",
                                      false,
                                      false,
                                      true,
                                      myBatasKeterlambatan),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Deskripsi Layanan   : ",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            child: buildTextField(
                                MaterialCommunityIcons.book,
                                "Deskripsi Layanan",
                                false,
                                false,
                                true,
                                myDeskripsi),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(15, 5, 0, 0),
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            "Status Layanan : ",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: Colors.black),
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
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Icon(
                                        MaterialCommunityIcons.account_outline,
                                        color: isAktif
                                            ? Colors.white
                                            : Warnalayer.iconColor,
                                      ),
                                    ),
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 17, 0),
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
                                    status = "tutup";
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
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Icon(
                                        MaterialCommunityIcons.account_outline,
                                        color: isAktif
                                            ? Warnalayer.iconColor
                                            : Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "Non-Aktif ",
                                      style: TextStyle(
                                          color: Warnalayer.textColor1),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(45, 30, 20, 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 280,
                                height: 40,
                                child: RaisedButton(
                                  onPressed: () {
                                    if (myNamalayanan.text == "" &&
                                        myJumKursi == "") {
                                      bolehinsert = false;
                                      Fluttertoast.showToast(
                                          msg: "Data Tidak Boleh KOSONG!",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.CENTER,
                                          backgroundColor: Colors.red[300],
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    } else {
                                      print("a");
                                      bolehinsert = true;
                                    }

                                    if (bolehinsert == true) {
                                      print(ckategori);
                                      insertlayanansalon();
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(80.0)),
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
                                        "Submit Layanan",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
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
              ],
            ),
          ),
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
