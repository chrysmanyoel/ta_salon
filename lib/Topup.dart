import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ta_salon/warnalayer.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:ta_salon/warnalayer.dart';
import 'package:path/path.dart';
import 'constants.dart';
import 'main_variable.dart' as main_variable;
import 'dart:io';
import 'ClassBank.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'ShowHtlmPage.dart';
import 'ClassUser.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Topup extends StatefulWidget {
  @override
  TopupState createState() => TopupState();
}

class TopupState extends State<Topup> {
  TextEditingController Atasnama1 = new TextEditingController();
  TextEditingController Atasnama2 = new TextEditingController();
  String Nama_bank, jumlah;
  TextEditingController Jenis_transaksi = new TextEditingController();
  TextEditingController Melalui = new TextEditingController();
  TextEditingController Norek1 = new TextEditingController();
  TextEditingController Norek2 = new TextEditingController();
  TextEditingController Jumlah = new TextEditingController();
  TextEditingController Jumlah1 = new TextEditingController();
  TextEditingController Jumlah2 = new TextEditingController();
  NumberFormat numberFormat = NumberFormat(',000');
  List<ClassUser> arrsaldo = new List();
  TextEditingController NoHP = new TextEditingController();
  TextEditingController Status = new TextEditingController();
  bool suksesupdate = false;
  String Atasnama = "", Norek = "";
  List<ClassBank> arrpilihanbank = new List();
  ClassBank selectedbank = null, selectedbank1 = null;
  String pilihan, pilihan1;
  double money = 50.00;

  void initState() {
    super.initState();
    //print(main_variable.namauser);
    arrpilihanbank.add(new ClassBank("BNI", "images/bni.png"));
    arrpilihanbank.add(new ClassBank("MANDIRI", "images/mandiri.png"));
    arrpilihanbank.add(new ClassBank("BCA", "images/BRI.png"));
    arrpilihanbank.add(new ClassBank("BRI", "images/BRI.png"));
    getsaldouser();
  }

  Future<String> transaksiTopUp_Withdraw() async {
    Map paramData = {
      'atasnama': Atasnama,
      'nama_bank': Nama_bank,
      'jenis_transaksi': Jenis_transaksi.text,
      'melalui': Melalui.text,
      'norek': Norek,
      'jumlah': jumlah,
      'status': Status.text,
    };
    var parameter = json.encode(paramData);
    http
        .post(main_variable.ipnumber + "/transaksiTopUp_bank",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body);
      if (res.body.contains("sukses")) {
        print("Berhasil");
        setState(() => this.suksesupdate = true);
      } else {
        print("Gagal");
      }
    }).catchError((err) {
      print(err);
    });
    return suksesupdate.toString();
  }

  Future<String> getsaldouser() async {
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
      print(res.body);
      print(data.length);

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
          data[i]['status'].toString(),
        );
        this.arrsaldo.add(databaru);
      }
      setState(() => this.arrsaldo = arrsaldo);

      return arrsaldo;
    }).catchError((err) {
      print(err);
    });
  }

  Future openXendit(double amount, context) async {
    print("masuk open xendit");

    ///arnold punya
    // var uname =
    //     'xnd_development_tU93YGYMu0kc4YrPAipFA0OcAsR2TIvWhprXbRQWduq7Sj6QsvEJq28IMnYCO9x';
    ///punyaku
    var uname =
        'xnd_development_q57y6XqXTu8R4fXUIuUDp6vOYg6t8Ox1ASMpnreEU8sTHOCphsJ26AsDfu2u';
    var pword = '';
    var authn = 'Basic ' + base64Encode(utf8.encode('$uname:'));
    print(uname);
    print("-----------------------------------------------------------------");
    print(authn);
    var data = {
      'external_id': "testing",
      'payer_email': "testing@gmail.com",
      'description': 'Top Up Rp. ' + amount.toString(), // _moneyFormat(amount),
      'amount': amount.toString(),
    };
    var res = await http.post(
        Uri.encodeFull("https://api.xendit.co/v2/invoices"),
        headers: {'Authorization': authn},
        body: data);
    if (res.statusCode != 200)
      throw Exception('post error: statusCode= ${res.statusCode}');
    var resData = jsonDecode(res.body);
    print(resData);
    print("invoice url = " + resData["invoice_url"]);
    /*
    databaseReference.child("TopUp/${_userProfile.key}/${resData["id"]}").update({
      'amount': amount,
      'status': "PENDING",
      'url': resData["invoice_url"],
      'timestamp': DateTime.now().millisecondsSinceEpoch
    });
    */
    //launchWebViewExample(resData["invoice_url"].toString());
    //updatesaldo();
    String url = resData["invoice_url"].toString();
    /*
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
    */

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowHtmlPage(url: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Warnalayer.backgroundColor,
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              height: 320,
              decoration: BoxDecoration(
                  color: Colors.blueAccent[200],
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(60),
                    bottomLeft: Radius.circular(60),
                  )),
            ),
            SafeArea(
              child: ListView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 320),
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: "\nTotal Saldo\n",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 18)),
                          TextSpan(
                              text: "\Rp. ",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 30)),
                          TextSpan(
                              text: numberFormat
                                      .format(int.parse(arrsaldo[0].saldo)) +
                                  " \n",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 36)),
                          TextSpan(
                              text: " \nTop Up & WithDraw SALDO",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                        ])),
                      ),
                      // IconButton(
                      //     icon: Icon(
                      //       Icons.more_vert,
                      //       color: Colors.white,
                      //       size: 40,
                      //     ),
                      //     onPressed: () {})
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    height: 440,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        //ini card nya
                        //VIA MIDTRANS
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 8, 20, 8),
                          child: Container(
                            height: 180,
                            width: 300,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey[600],
                                      offset: Offset(3, 1),
                                      blurRadius: 7,
                                      spreadRadius: 2)
                                ]),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: Image(
                                          width: 50.0,
                                          height: 50,
                                          image: AssetImage("images/paris.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'TOP UP VIA XENDIT',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              //fontWeight: FontWeight.bold,
                                              foreground: Paint()
                                                ..color = Colors.black
                                                ..strokeWidth = 1.5
                                                ..style = PaintingStyle.stroke,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.more_vert,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 10),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              print("masuk 50K");
                                              Jumlah.text = "50.000";
                                            },
                                            style: TextButton.styleFrom(
                                                side: BorderSide(
                                                    width: 1,
                                                    color: Colors.grey),
                                                minimumSize: Size(40, 35),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                primary: Colors.white,
                                                backgroundColor:
                                                    Color(0xff374ABE)),
                                            child: Center(
                                              child: Text(
                                                "50.000",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 25),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              print("masuk 75K");
                                              Jumlah.text = "75.000";
                                            },
                                            style: TextButton.styleFrom(
                                                side: BorderSide(
                                                    width: 1,
                                                    color: Colors.grey),
                                                minimumSize: Size(40, 35),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                primary: Colors.white,
                                                backgroundColor:
                                                    Color(0xff374ABE)),
                                            child: Center(
                                              child: Text(
                                                "75.000 ",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 25),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              print("masuk 100k");
                                              Jumlah.text = "100000";
                                            },
                                            style: TextButton.styleFrom(
                                                side: BorderSide(
                                                    width: 1,
                                                    color: Colors.grey),
                                                minimumSize: Size(40, 35),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                primary: Colors.white,
                                                backgroundColor:
                                                    Color(0xff374ABE)),
                                            child: Center(
                                              child: Text(
                                                "100.000",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 10),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              print("masuk 150K");
                                              Jumlah.text = "150.000";
                                            },
                                            style: TextButton.styleFrom(
                                                side: BorderSide(
                                                    width: 1,
                                                    color: Colors.grey),
                                                minimumSize: Size(40, 35),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                primary: Colors.white,
                                                backgroundColor:
                                                    Color(0xff374ABE)),
                                            child: Center(
                                              child: Text(
                                                "150.000",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 20),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              print("masuk 175K");
                                              Jumlah.text = "175.000";
                                            },
                                            style: TextButton.styleFrom(
                                                side: BorderSide(
                                                    width: 1,
                                                    color: Colors.grey),
                                                minimumSize: Size(40, 35),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                primary: Colors.white,
                                                backgroundColor:
                                                    Color(0xff374ABE)),
                                            child: Center(
                                              child: Text(
                                                "175.000",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 20),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              print("masuk 200K");
                                              Jumlah.text = "200.000";
                                            },
                                            style: TextButton.styleFrom(
                                                side: BorderSide(
                                                    width: 1,
                                                    color: Colors.grey),
                                                minimumSize: Size(40, 35),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                primary: Colors.white,
                                                backgroundColor:
                                                    Color(0xff374ABE)),
                                            child: Center(
                                              child: Text(
                                                "200.000",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Nominal ",
                                        style: TextStyle(
                                            fontSize: 15,
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
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 55,
                                    child: buildTextField(
                                        MaterialCommunityIcons.bank_transfer,
                                        "Rp. 100.000",
                                        false,
                                        false,
                                        true,
                                        Jumlah),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "No HP ",
                                        style: TextStyle(
                                            fontSize: 15,
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
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 55,
                                    child: buildTextField(
                                        MaterialCommunityIcons.phone,
                                        "08**********",
                                        false,
                                        false,
                                        true,
                                        NoHP),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(20, 15, 20, 10),
                                  child: TextButton(
                                    onPressed: () async {
                                      print("jumlah top up : " + Jumlah.text);
                                      openXendit(
                                          double.parse(Jumlah.text), context);
                                      // print("masuk button1");
                                      // Jenis_transaksi.text = "Top Up";
                                      // Melalui.text = "Xendit";
                                      // Nama_bank = "-";
                                      // Norek = "-";
                                      // Atasnama = "-";
                                      // Status.text = "pending";
                                      // jumlah = Jumlah.text;
                                      // transaksiTopUp_Withdraw();
                                    },
                                    style: TextButton.styleFrom(
                                        side: BorderSide(
                                            width: 1, color: Colors.grey),
                                        minimumSize: Size(40, 35),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        primary: Colors.white,
                                        backgroundColor: Color(0xff374ABE)),
                                    child: Center(
                                      child: Text(
                                        "Top Up",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //VIA BANK
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 20, 8),
                          child: Container(
                            height: 180,
                            width: 300,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey[600],
                                      offset: Offset(3, 1),
                                      blurRadius: 7,
                                      spreadRadius: 2)
                                ]),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: Image.asset(
                                    //     "images/background.png",
                                    //     width: 50,
                                    //   ),
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: Image(
                                          width: 50.0,
                                          height: 50,
                                          image: AssetImage("images/paris.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.fromLTRB(
                                    //       0, 8, 20, 8),
                                    //   child: Text("BANK"),
                                    // ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'TOP UP VIA BANK',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              //fontWeight: FontWeight.bold,
                                              foreground: Paint()
                                                ..color = Colors.black
                                                ..strokeWidth = 1.5
                                                ..style = PaintingStyle.stroke,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.more_vert,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                                  width: double.infinity,
                                  child: DropdownButton<ClassBank>(
                                    hint: Text("Pilih Bank"),
                                    value: selectedbank,
                                    onChanged: (ClassBank Value) {
                                      setState(() {
                                        pilihan = Value.nama_bank;
                                        print("nanas : " +
                                            pilihan.length.toString());
                                      });
                                    },
                                    items: arrpilihanbank
                                        .map((ClassBank arrpilihanbank) {
                                      return DropdownMenuItem<ClassBank>(
                                        value: arrpilihanbank,
                                        child: Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: 50,
                                              height: 50,
                                              child: Image.asset(
                                                arrpilihanbank.foto,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                            ),
                                            Text(
                                              arrpilihanbank.nama_bank,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Nominal ",
                                        style: TextStyle(
                                            fontSize: 14,
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
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: buildTextField(
                                        MaterialCommunityIcons.counter,
                                        "Rp. 100.000",
                                        false,
                                        false,
                                        true,
                                        Jumlah1),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "No Rekening",
                                        style: TextStyle(
                                            fontSize: 14,
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
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: buildTextField(
                                        MaterialCommunityIcons.bank_transfer,
                                        "08**********",
                                        false,
                                        false,
                                        true,
                                        Norek1),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Atas Nama",
                                        style: TextStyle(
                                            fontSize: 14,
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
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: buildTextField(
                                        MaterialCommunityIcons.face_profile,
                                        "AN/ ******",
                                        false,
                                        false,
                                        true,
                                        Atasnama1),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                                  child: TextButton(
                                    onPressed: () {
                                      print("masuk button2");
                                      Jenis_transaksi.text = "Top Up";
                                      Melalui.text = "Bank";
                                      Norek = Norek1.text;
                                      Atasnama = Atasnama1.text;
                                      Status.text = "pending";
                                      jumlah = Jumlah1.text;
                                      Nama_bank = pilihan.toString();
                                      transaksiTopUp_Withdraw();
                                    },
                                    style: TextButton.styleFrom(
                                        side: BorderSide(
                                            width: 1, color: Colors.grey),
                                        minimumSize: Size(40, 35),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        primary: Colors.white,
                                        backgroundColor: Color(0xff374ABE)),
                                    child: Center(
                                      child: Text(
                                        "Top Up",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //WITHDRAW
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 20, 8),
                          child: Container(
                            height: 180,
                            width: 300,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey[600],
                                      offset: Offset(3, 1),
                                      blurRadius: 7,
                                      spreadRadius: 2)
                                ]),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: Image(
                                          width: 50.0,
                                          height: 50,
                                          image: AssetImage("images/paris.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'WITHDRAW VIA BANK',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 18.0,
                                              //fontWeight: FontWeight.bold,
                                              foreground: Paint()
                                                ..color = Colors.black
                                                ..strokeWidth = 1.5
                                                ..style = PaintingStyle.stroke,
                                              letterSpacing: 1.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.more_vert,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                                  width: double.infinity,
                                  child: DropdownButton<ClassBank>(
                                    hint: Text("Pilih Bank"),
                                    value: selectedbank1,
                                    onChanged: (ClassBank Value) {
                                      setState(() {
                                        pilihan1 = Value.nama_bank;
                                      });
                                    },
                                    items: arrpilihanbank
                                        .map((ClassBank arrpilihanbank) {
                                      return DropdownMenuItem<ClassBank>(
                                        value: arrpilihanbank,
                                        child: Row(
                                          children: <Widget>[
                                            SizedBox(
                                              width: 50,
                                              height: 50,
                                              child: Image.asset(
                                                arrpilihanbank.foto,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                            ),
                                            Text(
                                              arrpilihanbank.nama_bank,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Nominal ",
                                        style: TextStyle(
                                            fontSize: 14,
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
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: buildTextField(
                                        MaterialCommunityIcons.counter,
                                        "Rp. 100.000",
                                        false,
                                        false,
                                        true,
                                        Jumlah2),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "No Rekening",
                                        style: TextStyle(
                                            fontSize: 14,
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
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: buildTextField(
                                        MaterialCommunityIcons.bank_transfer,
                                        "08**********",
                                        false,
                                        false,
                                        true,
                                        Norek2),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(20, 0, 0, 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Atas Nama",
                                        style: TextStyle(
                                            fontSize: 14,
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
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: buildTextField(
                                        MaterialCommunityIcons.face_profile,
                                        "AN/ ******",
                                        false,
                                        false,
                                        true,
                                        Atasnama2),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                                  child: TextButton(
                                    onPressed: () {
                                      print("masuk button3");
                                      Jenis_transaksi.text = "Top Up";
                                      Melalui.text = "Bank";
                                      Norek = Norek2.text;
                                      Atasnama = Atasnama2.text;
                                      Nama_bank = pilihan1.toString();
                                      jumlah = Jumlah2.text;
                                      Status.text = "pending";
                                      transaksiTopUp_Withdraw();
                                    },
                                    style: TextButton.styleFrom(
                                        side: BorderSide(
                                            width: 1, color: Colors.grey),
                                        minimumSize: Size(40, 35),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        primary: Colors.white,
                                        backgroundColor: Color(0xff374ABE)),
                                    child: Center(
                                      child: Text(
                                        "Top Up",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Row(
                  //   children: <Widget>[
                  //     Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Text("Send money"),
                  //     ),
                  //   ],
                  // ),
                  // Container(
                  //   height: 50,
                  //   child: ListView(
                  //     scrollDirection: Axis.horizontal,
                  //     children: <Widget>[
                  //       Padding(
                  //         padding: const EdgeInsets.all(2.0),
                  //         child: CircleAvatar(
                  //           child: Icon(Icons.add),
                  //           radius: 25,
                  //         ),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.all(2.0),
                  //         child: CircleAvatar(
                  //           backgroundImage:
                  //               AssetImage("images/background.png"),
                  //         ),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.all(2.0),
                  //         child: CircleAvatar(
                  //           backgroundImage:
                  //               AssetImage("images/background.png"),
                  //         ),
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.all(2.0),
                  //         child: CircleAvatar(
                  //           backgroundImage:
                  //               AssetImage("images/background.png"),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Transaksi Terakhir"),
                      ),
                    ],
                  ),
                  ListTile(
                    onTap: () {
                      _settingModalBottomSheet(context);
                    },
                    leading: CircleAvatar(
                      backgroundImage: AssetImage("images/background.png"),
                    ),
                    title: RichText(
                        text: TextSpan(children: [
                      TextSpan(text: 'Top Up\n'),
                      TextSpan(
                          text: 'Money received - Today 9AM',
                          style: TextStyle(fontSize: 14, color: Colors.grey))
                    ], style: TextStyle(color: Colors.black, fontSize: 18))),
                    trailing: Text(
                      "+ \Rp. 50.000",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      _settingModalBottomSheet(context);
                    },
                    leading: CircleAvatar(
                      backgroundImage: AssetImage("images/background.png"),
                    ),
                    title: RichText(
                        text: TextSpan(children: [
                      TextSpan(text: 'Pembayaran\n'),
                      TextSpan(
                          text: 'Money Sent - Today 12PM',
                          style: TextStyle(fontSize: 14, color: Colors.grey))
                    ], style: TextStyle(color: Colors.black, fontSize: 18))),
                    trailing: Text(
                      "- \Rp. 20.000",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20))),
            child: new Wrap(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage("images/p2.jpg"),
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Jason Martin",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text("Amount to send"),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: InkWell(
                          onTap: () {
                            if (money != 0) {
                              money -= 10;
                            }
                          },
                          child: CircleAvatar(
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                            radius: 20,
                            backgroundColor: Colors.grey,
                          )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "$money",
                      style:
                          TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: InkWell(
                          onTap: () {
                            setState(() {
                              money += 10;
                            });
                          },
                          child: CircleAvatar(
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            radius: 20,
                            backgroundColor: Colors.grey,
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.yellow,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            "Send Money",
                            style: TextStyle(fontSize: 22, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
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
