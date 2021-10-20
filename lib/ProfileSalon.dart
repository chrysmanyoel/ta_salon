import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ta_salon/EditProfileSalon.dart';
import 'profile_menu.dart';
import 'main_variable.dart' as main_variable;
import 'dart:async';
import 'package:ta_salon/ClassSalon.dart';
import 'package:ta_salon/ClassUser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ta_salon/warnalayer.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:convert';

class ProfileSalon extends StatefulWidget {
  @override
  ProfileSalonState createState() => ProfileSalonState();
}

class ProfileSalonState extends State<ProfileSalon> {
  TextEditingController myFoto = new TextEditingController();
  String nama;
  String email;
  String role;
  String foto = main_variable.ipnumber + "/gambar/default.png";
  File _image;
  List<ClassUser> arr = new List();

  void initState() {
    super.initState();

    arr.add(new ClassUser(
        "email",
        "username",
        "password",
        "nama",
        "alamat",
        "kota",
        "telp",
        "default.png",
        "0",
        "tgllahir",
        "jeniskelamin",
        "role",
        "status"));
    getuser();
  }

  void logout() async {
    SharedPreferences keluar = await SharedPreferences.getInstance();
    keluar.remove('usename');
    keluar.remove('role');
    keluar.remove('kota');
    main_variable.idsalonlogin = "";
    main_variable.usernamesalon = "";
    main_variable.roleuserlogin = "";
    main_variable.namauser = "";
    main_variable.kotauser = "";
    Navigator.of(this.context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });

    String namaFile = image.path;
    String basenamegallery = basename(namaFile);
  }

  Future<ClassUser> getuser() async {
    List<ClassUser> arrtemp = new List();
    Map paramData = {
      'username': main_variable.userlogin,
    };
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/getuser",
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
            data[i]['status'].toString());
        arrtemp.add(databaru);
        foto = main_variable.ipnumber + "/gambar/" + arrtemp[i].foto;
        nama = arrtemp[i].nama;
        email = arrtemp[i].email;
        role = arrtemp[i].role;
      }
      setState(() => this.arr = arrtemp);

      return arrtemp;
    }).catchError((err) {
      print(err);
    });
  }

//KARNA PAKAI ONPRESED MAKA NGGA BISA PAKAI NAVIGATOR PUSH.. JADI DIAKALI PAKE BUAT VOID DAN TAMBAHKAN ALAMAT MANUAL DI MAIN.DART LALU TEMBAK ALAMATNYA
  void goEditProfile(BuildContext context) async {
    String tujuan = "/";
    if (role == "member") {
      tujuan = "/EditProfileMember";
      // print("Role nya M: " + main_variable.roleuserlogin);
      // print(tujuan);
    } else if (role == "salon") {
      tujuan = "/EditProfileSalon";
      // print("Role nya S: " + main_variable.roleuserlogin);
      // print(tujuan);
    }
    await Navigator.of(context).pushNamed(tujuan);
  }

  void goEditJadwalSalon(BuildContext context) async {
    String tujuan = "/JamKejaSalon";
    await Navigator.of(context).pushNamed(tujuan);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warnalayer.backgroundColor,
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(40.0, 40.0, 20.0, 5.0),
              ),
              fotoprofile1(this.context),
              Container(
                  margin: EdgeInsets.fromLTRB(30, 10, 20, 0),
                  child: Text(
                    nama.toString(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Colors.black),
                  )),
              Container(
                  margin: EdgeInsets.fromLTRB(30, 5, 20, 10),
                  child: Text(
                    email.toString(),
                    style: TextStyle(
                        fontSize: 15,
                        //fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: Colors.black),
                  )),
              SizedBox(height: 20),
              ProfileMenu(
                  text: "My Account",
                  icon: "assets/icons/User Icon.svg",
                  press: () => goEditProfile(context)
                  // press: () {
                  //   print("role user profile : " + role);
                  // },
                  ),
              ProfileMenu(
                text: "Notifications",
                icon: "assets/icons/Bell.svg",
                press: () {},
              ),
              ProfileMenu(
                  text: "Jam Kerja Salon",
                  icon: "assets/icons/Settings.svg",
                  press: () => Navigator.pushNamed(context, '/JamKerjaSalon')),
              ProfileMenu(
                text: "Chat / Message",
                icon: "assets/icons/Chat bubble Icon.svg",
                press: () {},
              ),
              ProfileMenu(
                text: "Log Out",
                icon: "assets/icons/Log out.svg",
                press: () {
                  logout();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget fotoprofile1(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          SizedBox(height: 50),
          ClipRRect(
            borderRadius: BorderRadius.circular(60.0),
            child: Image.network(
              this.foto,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
