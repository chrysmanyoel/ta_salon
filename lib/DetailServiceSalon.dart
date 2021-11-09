import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:ta_salon/ClassPilihJenjangPeruntukan.dart';
import 'main_variable.dart' as main_variable;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'ClassLayananSalon.dart';
import 'ClassBookingService.dart';
import 'package:intl/intl.dart';
import 'ClassPilihJenjangPeruntukan.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'ClassUser.dart';
import 'ClassPegawai.dart';
import 'dart:convert';

class DetailServiceSalon extends StatefulWidget {
  final int index;
  final String namaservicekirim, idservice, kodelayanan;

  DetailServiceSalon(
      {Key key,
      this.index,
      @required this.namaservicekirim,
      @required this.idservice,
      @required this.kodelayanan})
      : super(key: key);

  @override
  DetailServiceSalonState createState() => DetailServiceSalonState(
      this.namaservicekirim, this.idservice, this.kodelayanan);
}

//ini buat proper kata / Kapitalisasi 2 kata jadi besar
extension CapExtension on String {
  String get inCaps =>
      this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
  String get capitalizeFirstofEach => this
      .replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.inCaps)
      .join(" ");
}

class DetailServiceSalonState extends State<DetailServiceSalon> {
  NumberFormat numberFormat = NumberFormat(',000');

  DetailServiceSalonState(
      this.namaservicekirim, this.idservice, this.kodelayanan);

  List<ClassLayanansalon> arr = new List();
  List<ClassBookingService> arrbooking = new List();
  List<ClassPilihJenjangPeruntukan> arrjenjangperuntukan = new List();
  List<ClassPegawai> arrpegawai = new List();
  List<ClassUser> arrsaldo = new List();

  int saldo = 0;
  int _radioValue = 0;

  String namaservicekirim, idservice, kotakrim, total = "0", kodelayanan;
  String tgl, jam, reqmua, pembayarankirim = "";
  String cekpembayaran = "";

  TextEditingController myTgl = new TextEditingController();
  TextEditingController myTime = new TextEditingController();
  TextEditingController myMua = new TextEditingController();
  TextEditingController myNamauser = new TextEditingController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = new TimeOfDay.now();

  ClassPilihJenjangPeruntukan selectedarr = null;
  ClassPegawai selectarrpeg = null;
  bool _like = false;
  ClassLayanansalon datalama = new ClassLayanansalon(
      "", "", '', "", "", "", "", "", "", "", "", "", "", "", '', '', '');
  String foto = main_variable.ipnumber + "/gambar/default.png";

  void initState() {
    super.initState();
    setState(() {
      arr.add(new ClassLayanansalon(
          "id",
          "0",
          "username",
          "namalayanan",
          "0",
          "peruntukan",
          "0",
          "jenjangusia",
          "0",
          "deskripsi",
          "status",
          "0",
          "0",
          "0",
          "0",
          "0",
          "default.png"));
      arrbooking.add(new ClassBookingService(
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
      arrpegawai.add(new ClassPegawai(
          "id", "idsalon", "nama", "alamat", "telp", "status"));
      arrsaldo.add(new ClassUser(
          "email",
          "username",
          "password",
          "nama",
          "alamat",
          "kota",
          "0",
          "default.png",
          "0",
          "tgllahir",
          "jeniskelamin",
          "role",
          "status"));
    });

    getlayanansalondetail();
    getperuntukanjenjang();
    getsaldouser();
    getpegawai_halamanmember();
    print("idsalon : " + main_variable.idsalonlogin);
    print("ini kodelayanan : " + kodelayanan);
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      if (_radioValue == 0) {
        //status = "aktif";
        print("aktif");
      } else if (_radioValue == 1) {
        //status = "non-aktif";
        print("nonaktif");
      }
    });
  }

  void pembayaran(int value) {
    setState(() {
      _radioValue = value;

      if (_radioValue == 1) {
        saldo = int.parse(arrsaldo[0].saldo);
        pembayarankirim = "saldo";
        if (saldo - int.parse(total) < 0) {
          cekpembayaran = "Saldo anda tidak mencukupi";
        } else {
          cekpembayaran = "";
          saldo = saldo - int.parse(total);
        }
      } else if (_radioValue == 0) {
        cekpembayaran = "";
        pembayarankirim = "cash";
        saldo = int.parse(arrsaldo[0].saldo);
      }
      print(pembayarankirim);
    });
  }

  Text _buildRatingStars(int rating) {
    String stars = '';
    for (int i = 0; i < rating; i++) {
      stars += '⭐ ';
    }
    stars.trim();
    return Text(stars);
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

  Future<ClassUser> getsaldouser() async {
    List<ClassUser> arrtemp = new List();
    Map paramData = {
      'username': main_variable.userlogin,
    };
    var parameter = json.encode(paramData);
    http
        .post(main_variable.ipnumber + "/getsaldouser",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];

      for (int i = 0; i < data.length; i++) {
        ClassUser databaru = new ClassUser(
            data[i]['email'].toString(),
            data[i]['username'].toString(),
            data[i]['password'].toString(),
            data[i]['nama'].toString(),
            data[i]['alamat'].toString(),
            data[i]['kota'].toString(),
            data[i]['telp'].toString(),
            data[i]['foto'].toString(),
            data[i]['saldo'].toString(),
            data[i]['tgllahir'].toString(),
            data[i]['jeniskelamin'].toString(),
            data[i]['role'].toString(),
            data[i]['status'].toString());
        arrtemp.add(databaru);
        saldo = int.parse(arrtemp[i].saldo);
      }

      setState(() => this.arrsaldo = arrtemp);
      print("aaa : " + this.arrsaldo.length.toString());

      return arrtemp;
    }).catchError((err) {
      print(err);
    });
  }

  Future<ClassLayanansalon> getlayanansalondetail() async {
    List<ClassLayanansalon> arrtemp = new List();
    Map paramData = {
      'idsalon': main_variable.idsalonlogin,
      'namalayanan': namaservicekirim.toString(),
    };
    var parameter = json.encode(paramData);
    http
        .post(main_variable.ipnumber + "/getlayanansalondetail",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];
      print(res.body);

      for (int i = 0; i < data.length; i++) {
        ClassLayanansalon databaru = new ClassLayanansalon(
            data[i]['id'].toString(),
            data[i]['idsalon'].toString(),
            data[i]['username'].toString(),
            data[i]['namalayanan'].toString(),
            data[i]['peruntukan'].toString(),
            data[i]['idkategori'].toString(),
            data[i]['jenjangusia'].toString(),
            data[i]['durasi'].toString(),
            data[i]['deskripsi'].toString(),
            data[i]['status'].toString(),
            data[i]['hargapriadewasa'].toString(),
            data[i]['hargawanitadewasa'].toString(),
            data[i]['hargapriaanak'].toString(),
            data[i]['hargawanitaanak'].toString(),
            data[i]['jumlah_kursi'].toString(),
            data[i]['toleransi_keterlambatan'].toString(),
            data[i]['foto'].toString());
        arrtemp.add(databaru);
        foto = main_variable.ipnumber + "/gambar/" + arrtemp[i].foto;
      }
      setState(() => this.arr = arrtemp);
      print("ini arr : " + this.arr.length.toString());
      print("aple " + this.arr[0].keterlambatan_waktu.toString());

      return arrtemp;
    }).catchError((err) {
      print(err);
    });
  }

  Future<ClassPilihJenjangPeruntukan> getperuntukanjenjang() async {
    List<ClassPilihJenjangPeruntukan> arrtemp = new List();
    Map paramData = {
      'idsalon': main_variable.idsalonlogin,
      'namalayanan': namaservicekirim.toString(),
    };
    var parameter = json.encode(paramData);
    http
        .post(main_variable.ipnumber + "/getlayanansalondetail",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print("bb" + res.body);
      var data = json.decode(res.body);
      data = data[0]['status'];
      print("b" + data.length.toString());

      for (int i = 0; i < data.length; i++) {
        if (data[i]['hargawanitadewasa'].toString() != "0") {
          ClassPilihJenjangPeruntukan databaru =
              new ClassPilihJenjangPeruntukan(
                  "Wanita", "Dewasa", data[i]['hargawanitadewasa'].toString());
          arrtemp.add(databaru);
        }
        if (data[i]['hargapriadewasa'].toString() != "0") {
          ClassPilihJenjangPeruntukan databaru =
              new ClassPilihJenjangPeruntukan(
                  "Pria", "Dewasa", data[i]['hargapriadewasa'].toString());
          arrtemp.add(databaru);
        }
        if (data[i]['hargawanitaanak'].toString() != "0") {
          ClassPilihJenjangPeruntukan databaru =
              new ClassPilihJenjangPeruntukan(
                  "Anak", "Perempuan", data[i]['hargawanitaanak'].toString());
          arrtemp.add(databaru);
        }
        if (data[i]['hargapriaanak'].toString() != "0") {
          ClassPilihJenjangPeruntukan databaru =
              new ClassPilihJenjangPeruntukan(
                  "Anak", "Laki-Laki", data[i]['hargapriaanak'].toString());
          arrtemp.add(databaru);
        }
      }
      setState(() => this.arrjenjangperuntukan = arrtemp);
      print("ini arrjenjangperuntukan : " +
          this.arrjenjangperuntukan.length.toString());

      return arrtemp;
    }).catchError((err) {
      print(err);
    });
  }

  Future<ClassBookingService> insertbookingservice() async {
    Map paramData = {
      'username': main_variable.userlogin,
      'idservice': idservice.toString(),
      'namauser': myNamauser.text,
      'idsalon': main_variable.idsalonlogin,
      'tanggalbooking': myTgl.text,
      'jambooking': myTime.text,
      'total': total,
      'idpegawai': myMua.text,
      'pembayaran': pembayarankirim,
    };
    var parameter = json.encode(paramData);

    ClassBookingService databaru = new ClassBookingService(
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
        "jamres");

    http
        .post(main_variable.ipnumber + "/insertbookingservice",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      //print(res.body.substring(100));
      print("d " + res.body.toString());
      var data = json.decode(res.body);
      data = data[0]['status'];

      print("d " + data.length.toString());

      print(data.toString());

      if (data == "sukses") {
        Fluttertoast.showToast(
            msg: "Berhasil Membuat Jadwal Booking",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.blue[300],
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (data == "tutup") {
        Fluttertoast.showToast(
            msg: "Gagal Booking, Salon Sedang Tutup",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red[300],
            textColor: Colors.white,
            fontSize: 16.0);
      }
      //kalo mau semua pending bisa tetep input maka di controler -2 diganti input ke boooking service dan yang ini di ubah message nya jadi berhasil booking
      else if (data == "-2") {
        Fluttertoast.showToast(
            msg: "Gagal Booking, Pegawai Sedang Berhalangan",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red[300],
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (data == "-1") {
        Fluttertoast.showToast(
            msg: "Gagal Booking, Jam Tersebut Telah Penuh",
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

  Future<ClassPegawai> getpegawai_halamanmember() async {
    List<ClassPegawai> arrtemp = new List();
    Map paramData = {
      'idsalon': main_variable.idsalonlogin,
      'kodelayanan': kodelayanan,
    };
    var parameter = json.encode(paramData);
    http
        .post(main_variable.ipnumber + "/getpegawai_halamanmember",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];
      print("c " + data.length.toString());

      for (int i = 0; i < data.length; i++) {
        ClassPegawai databaru = new ClassPegawai(
            data[i]['id'].toString(),
            data[i]['idsalon'].toString(),
            data[i]['nama'].toString(),
            data[i]['alamat'].toString(),
            data[i]['telp'].toString(),
            data[i]['status'].toString());
        arrtemp.add(databaru);
      }
      setState(() => this.arrpegawai = arrtemp);
      print("ini arrpeg : " + this.arrpegawai.length.toString());

      return arrtemp;
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: width,
          child: Stack(
            children: <Widget>[
              Container(
                height: height * 0.35,
                child: Image.network(
                  main_variable.ipnumber + "/gambar/" + arr[0].foto,
                  width: MediaQuery.of(context).size.width,
                  //fit: BoxFit.contain,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: width,
                margin: EdgeInsets.only(top: height * 0.3),
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      arr[0].namalayanan.capitalizeFirstofEach,
                      //"Nama Layanan",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 50,
                      width: width,
                      child: ListView.builder(
                        itemCount: 5,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, int key) {
                          return Icon(
                            Icons.star,
                            color: Colors.yellow[900],
                            size: 28,
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Description",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      arr[0].deskripsi,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 0.5,
                          wordSpacing: 1.5),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Peruntukan",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      arr[0].peruntukan,
                      //"Semua",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 0.5,
                          wordSpacing: 1.5),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Jenjang",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      arr[0].jenjangusia,
                      //"Semua",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 0.5,
                          wordSpacing: 1.5),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Durasi Layanan",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      arr[0].durasi + " menit",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 0.5,
                          wordSpacing: 1.5),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "Harga",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w900),
                    ),
                    //ini if 1 (simple if)
                    arr[0].peruntukan == "wanita" &&
                            arr[0].jenjangusia == "dewasa"
                        ? Padding(
                            padding:
                                EdgeInsets.only(left: 0, right: 0, top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Wanita Dewasa : Rp. " +
                                      numberFormat.format(
                                          int.parse(arr[0].harganwanitadewasa)),
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          )
                        //ini else if 1 untuk wanita
                        : arr[0].peruntukan == "wanita" &&
                                arr[0].jenjangusia == "anak-anak"
                            ? Padding(
                                padding:
                                    EdgeInsets.only(left: 0, right: 0, top: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Anak Perempuan : Rp. " +
                                          numberFormat.format(int.parse(
                                              arr[0].hargawanitaanak)),
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              )
                            ////ini else if 2 untuk pria dewasa
                            : arr[0].peruntukan == "pria" &&
                                    arr[0].jenjangusia == "dewasa"
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        left: 0, right: 0, top: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Pria Dewasa : Rp. " +
                                              numberFormat.format(int.parse(
                                                  arr[0].hargapriadewasa)),
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                  )
                                ////ini else if 3 untuk pria anak
                                : arr[0].peruntukan == "pria" &&
                                        arr[0].jenjangusia == "anak-anak"
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            left: 0, right: 0, top: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Anak Laki-Laki : Rp. " +
                                                  numberFormat.format(int.parse(
                                                      arr[0].hargapriaanak)),
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ],
                                        ),
                                      )
                                    ////ini else if 4 untuk semua tapi wanita
                                    : arr[0].peruntukan == "wanita" &&
                                            arr[0].jenjangusia == "semua"
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                left: 0, right: 0, top: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Wanita Dewasa : Rp. " +
                                                      numberFormat.format(
                                                          int.parse(arr[0]
                                                              .harganwanitadewasa)),
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Anak Perempuan : Rp. " +
                                                      numberFormat.format(
                                                          int.parse(arr[0]
                                                              .hargawanitaanak)),
                                                  style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ],
                                            ),
                                          )
                                        ////ini else if 5 untuk semua tapi pria
                                        : arr[0].peruntukan == "pria" &&
                                                arr[0].jenjangusia == "semua"
                                            ? Padding(
                                                padding: EdgeInsets.only(
                                                    left: 0, right: 0, top: 5),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Pria Dewasa : Rp. " +
                                                          numberFormat.format(
                                                              int.parse(arr[0]
                                                                  .hargapriadewasa)),
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      "Anak Laki-Laki : Rp. " +
                                                          numberFormat.format(
                                                              int.parse(arr[0]
                                                                  .hargapriaanak)),
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ////ini else if 6 untuk semua tapi anak-anak
                                            : arr[0].peruntukan == "semua" &&
                                                    arr[0].jenjangusia ==
                                                        "anak-anak"
                                                ? Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 0,
                                                        right: 0,
                                                        top: 5),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Anak Perempuan : Rp. " +
                                                              numberFormat.format(
                                                                  int.parse(arr[
                                                                          0]
                                                                      .hargawanitaanak)),
                                                          style: TextStyle(
                                                            fontSize: 18.0,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          "Anak Laki-Laki : Rp. " +
                                                              numberFormat.format(
                                                                  int.parse(arr[
                                                                          0]
                                                                      .hargapriaanak)),
                                                          style: TextStyle(
                                                            fontSize: 18.0,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                //ini else untuk cetak semua semua
                                                : Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 0,
                                                        right: 0,
                                                        top: 5),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          "Pria Dewasa : Rp. " +
                                                              arr[0]
                                                                  .hargapriadewasa,
                                                          style: TextStyle(
                                                            fontSize: 18.0,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          "Wanita Dewasa : Rp. " +
                                                              numberFormat.format(
                                                                  int.parse(arr[
                                                                          0]
                                                                      .harganwanitadewasa)),
                                                          style: TextStyle(
                                                            fontSize: 18.0,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          "Anak Perempuan : Rp. " +
                                                              numberFormat.format(
                                                                  int.parse(arr[
                                                                          0]
                                                                      .hargawanitaanak)),
                                                          style: TextStyle(
                                                            fontSize: 18.0,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(
                                                          "Anak Laki-Laki : Rp. " +
                                                              numberFormat.format(
                                                                  int.parse(arr[
                                                                          0]
                                                                      .hargapriaanak)),
                                                          style: TextStyle(
                                                            fontSize: 18.0,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                    SizedBox(
                      height: 35,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 0, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '--- Booking Layanan Salon ---',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22.0,
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
                                decoration: InputDecoration(
                                    labelText: 'Tanggal Booking'),
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
                    SizedBox(
                      height: 8,
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
                                    margin: EdgeInsets.fromLTRB(
                                        0.0, 20.0, 0.0, 0.0),
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
                      child: Text(
                        myTime.text == ""
                            ? ""
                            : "*Batas Keterlambatan waktu " +
                                arr[0].keterlambatan_waktu +
                                " menit",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    Container(
                      child: TextFormField(
                        controller: myNamauser,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        decoration: InputDecoration(
                          labelText: "Nama Customer",
                        ),
                        style: TextStyle(
                          letterSpacing: 1.0,
                        ),
                        validator: (value) => value.isEmpty ? "-" : null,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      width: double.infinity,
                      child: DropdownButton<ClassPilihJenjangPeruntukan>(
                        hint: Text("Pilih Peruntukan / Jenjang"),
                        value: selectedarr,
                        onChanged: (ClassPilihJenjangPeruntukan Value) {
                          setState(() {
                            selectedarr = Value;
                            total = Value.harga;
                            saldo = int.parse(arrsaldo[0].saldo);
                            if (pembayarankirim == "saldo") {
                              if (saldo - int.parse(total) < 0) {
                                cekpembayaran = " Saldo Anda Tidak Mencukupi";
                              } else {
                                saldo = saldo - int.parse(total);
                              }
                            } else {
                              cekpembayaran = "";
                            }
                          });
                        },
                        items: arrjenjangperuntukan.map(
                            (ClassPilihJenjangPeruntukan arrjenjangperuntukan) {
                          return DropdownMenuItem<ClassPilihJenjangPeruntukan>(
                            value: arrjenjangperuntukan,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  arrjenjangperuntukan.jenjang +
                                      " " +
                                      arrjenjangperuntukan.peruntukan,
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text(
                                  " - Rp. " + arrjenjangperuntukan.harga,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      width: double.infinity,
                      child: DropdownButton<ClassPegawai>(
                        hint: Text("Pilih Pegawai Yang Masuk Hari Ini"),
                        value: selectarrpeg,
                        onChanged: (ClassPegawai Value) {
                          setState(() {
                            selectarrpeg = Value;
                            myMua.text = Value.id;
                          });
                        },
                        items: arrpegawai.map((ClassPegawai arrpegawai) {
                          return DropdownMenuItem<ClassPegawai>(
                            value: arrpegawai,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  arrpegawai.nama,
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Text(
                      "Pembayaran",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 0, right: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          new Row(
                            children: [
                              new Radio(
                                value: 0,
                                groupValue: _radioValue,
                                onChanged: pembayaran,
                              ),
                              new Text(
                                'Cash',
                                style: new TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              new Radio(
                                value: 1,
                                groupValue: _radioValue,
                                onChanged: pembayaran,
                              ),
                              new Text(
                                'Saldo',
                                style: new TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 40),
                                padding: const EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey[400])),
                                child:
                                    Text('Rp. ' + numberFormat.format(saldo)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      cekpembayaran,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Total",
                              style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "Rp. " + numberFormat.format(int.parse(total)),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        RaisedButton(
                          onPressed: () {
                            // print("ini mua : " + myMua.text);
                            // print("ini time : " + main_variable.idsalonlogin);
                            // print("ini date : " + myTgl.text);
//                            print(pembayarankirim);
                            insertbookingservice();

                            //showDialogFunc(context, "images/background.png",
                            //   "INI JUDUL", "Deskripsi");
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.orange[800],
                          padding: EdgeInsets.fromLTRB(30, 15, 35, 15),
                          child: Text(
                            "Booking Service",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              //panah balik
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
              // Positioned(
              //   right: 30,
              //   top: height * 0.37,
              //   child: GestureDetector(
              //     onTap: () {
              //       print("masuk like");
              //       setState(() {
              //         _like = !_like;
              //       });
              //     },
              //     child: Container(
              //       height: 60,
              //       width: 60,
              //       decoration: BoxDecoration(
              //           color: Colors.white,
              //           borderRadius: BorderRadius.circular(35),
              //           boxShadow: [
              //             BoxShadow(
              //                 color: Colors.black.withOpacity(0.5),
              //                 blurRadius: 5,
              //                 spreadRadius: 1)
              //           ]),
              //       child: Icon(
              //         Icons.favorite,
              //         size: 38,
              //         color: (_like) ? Colors.red : Colors.grey[600],
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
