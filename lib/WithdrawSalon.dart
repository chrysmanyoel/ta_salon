import 'package:flutter/material.dart';
import 'package:ta_salon/ClassBank.dart';
import 'dart:async';
import 'package:ta_salon/warnalayer.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:ta_salon/warnalayer.dart';
import 'package:path/path.dart';
import 'ClassUser.dart';
import 'ClassBank.dart';
import 'constants.dart';
import 'main_variable.dart' as main_variable;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class WithdrawSalon extends StatefulWidget {
  @override
  WithdrawSalonState createState() => WithdrawSalonState();
}

class WithdrawSalonState extends State<WithdrawSalon> {
  TextEditingController Atasnama1 = new TextEditingController();
  TextEditingController Nama_bank = new TextEditingController();
  TextEditingController Jenis_transaksi = new TextEditingController();
  TextEditingController Melalui = new TextEditingController();
  TextEditingController Norek1 = new TextEditingController();
  TextEditingController Jumlah = new TextEditingController();
  TextEditingController Status = new TextEditingController();

  NumberFormat numberFormat = NumberFormat(',000');

  List<ClassUser> arrsaldo = new List();
  List<ClassBank> arrpilihanbank = new List();

  bool suksesupdate = false;

  ClassBank selectedbank1 = null, pilihan1;

  double money = 50.00;

  void initState() {
    super.initState();
    setState(() {
      arrsaldo.add(new ClassUser(
          "email",
          "username",
          "password",
          "nama",
          "alamat",
          "kota",
          "telp",
          "foto",
          "0",
          "tgllahir",
          "jeniskelamin",
          "role",
          "status"));
    });

    getsaldouser();

    arrpilihanbank.add(new ClassBank("BNI", "images/bni.png"));
    arrpilihanbank.add(new ClassBank("MANDIRI", "images/mandiri.png"));
    arrpilihanbank.add(new ClassBank("BCA", "images/bca.png"));
    arrpilihanbank.add(new ClassBank("BRI", "images/BRI.png"));
    print(arrpilihanbank.length.toString());
  }

  Future<String> transaksiTopUp_Withdraw() async {
    Map paramData = {
      'dari': main_variable.namauser,
      'atasnama': Atasnama1.text,
      'nama_bank': Nama_bank.text,
      'jenis_transaksi': Jenis_transaksi.text,
      'melalui': Melalui.text,
      'norek': Norek1.text,
      'jumlah': Jumlah.text,
      'status': Status.text,
    };
    var parameter = json.encode(paramData);
    http
        .post(main_variable.ipnumber + "/transaksiTopUp_Withdraw",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body);
      if (res.body.contains("sukses")) {
        print("Berhasil Update Profile");
        setState(() => this.suksesupdate = true);
      } else {
        print("Update gagal");
      }
    }).catchError((err) {
      print(err);
    });
    return suksesupdate.toString();
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
        arrtemp.add(databaru);
      }
      setState(() => this.arrsaldo = arrtemp);

      return arrtemp;
    }).catchError((err) {
      print(err);
    });
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
                              text: " \nWithDraw SALDO",
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
                        //WITHDRAW
                        Padding(
                          padding: const EdgeInsets.fromLTRB(50, 8, 20, 8),
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
                                          image: AssetImage("images/bank.png"),
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
                                        selectedbank1 = Value;
                                        print("ini adalah pilihan : " +
                                            selectedbank1.nama_bank.toString());
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
                                      print("masuk button3");
                                      Jenis_transaksi.text = "Top Up";
                                      Melalui.text = "Bank";
                                      Nama_bank.text = selectedbank1.nama_bank;
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
                                        "Tarik Tunai",
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
                      backgroundImage: AssetImage("images/bank.png"),
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
