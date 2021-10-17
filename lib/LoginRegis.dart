import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:ta_salon/ClassIklan.dart';
import 'package:ta_salon/DashboardMember.dart';
import 'package:ta_salon/DashboardSalon.dart';
import 'package:ta_salon/ForgotPasswor.dart';
import 'package:ta_salon/dashboardadmin.dart';
import 'package:ta_salon/warnalayer.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'ClassUser.dart';
import 'dart:convert';
import 'main_variable.dart' as main_variable;
import 'package:shared_preferences/shared_preferences.dart';

class LoginRegis extends StatefulWidget {
  @override
  LoginRegisState createState() => LoginRegisState();
}

class LoginRegisState extends State<LoginRegis> {
  bool isSignupScreen = false;
  bool isMale = true;
  bool isFemale = false;
  bool isSalon = false;
  bool isMember = true;
  bool isRememberMe = false;
  TextEditingController myEmail = new TextEditingController();
  TextEditingController myUsername = new TextEditingController();
  TextEditingController myPassword = new TextEditingController();
  String roleuser, jeniskelamin;
  SharedPreferences pre;
  String username = "", role = "", kota = "";

  void initState() {
    super.initState();
    // if (isMale == true && isFemale == false) {
    //   jeniskelamin == "pria";
    // } else {
    //   jeniskelamin == "wanita";
    // }
    // if (isSalon == false && isMember == true) {
    //   roleuser == "member";
    // } else {
    //   jeniskelamin == "salon";
    // }

    //IS REMEMBERME BLM BISA NGELOAD LANGSUNG DATAUSER, KENDALA DI REGISTER HARUS MENCET JK DAN ROLEUSER DULU
    datauser();
    getrole();
  }

  Future<ClassIklan> autoselesai() async {
    Map paramData = {};
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/autoselesai",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];

      return data;
    }).catchError((err) {
      print(err);
    });
  }

  void datauser() async {
    pre = await SharedPreferences.getInstance();
    username = pre.getString("username") ?? "null";
    role = pre.getString("role") ?? "null";
    kota = pre.getString("kota") ?? "null";
    main_variable.userlogin = username;
    main_variable.roleuserlogin = role;
    main_variable.kotauser = kota;
    if (role != "") {
      if (role == "member") {
        Navigator.of(this.context).pushNamedAndRemoveUntil(
            '/DashboardMember', (Route<dynamic> route) => false);
      } else if (role == "admin") {
        Navigator.of(this.context).pushNamedAndRemoveUntil(
            '/DashboardAdmin', (Route<dynamic> route) => false);
      } else if (role == "salon") {
        Navigator.of(this.context).pushNamedAndRemoveUntil(
            '/DashboardSalon', (Route<dynamic> route) => false);
      }
    }
  }

  Future<String> loginUser_remember() async {
    // try {
    pre = await SharedPreferences.getInstance();
    Map paramData = {
      'password': myPassword.text,
      'username': myUsername.text,
    };
    var parameter = json.encode(paramData);
    http
        .post(main_variable.ipnumber + "/login",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      print(res.body);
      main_variable.userlogin = myUsername.text;

      data = data[0]['status'];
      print(data);
      if (data[0]['role'] == "admin") {
        autoselesai();
        pre.setString("username", data[0]['username'].toString());
        pre.setString("role", data[0]['role'].toString());
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboardadmin(),
            ));
        Fluttertoast.showToast(
            msg: "Berhasil Login",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.blue[300],
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (data[0]['role'] == "member" && data[0]['status'] == "aktif") {
        autoselesai();
        pre.setString("username", data[0]['username'].toString());
        pre.setString("role", data[0]['role'].toString());
        pre.setString("kota", data[0]['kota'].toString());
        main_variable.namauser = data[0]['nama'];
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboardmember(),
            ));
        Fluttertoast.showToast(
            msg: "Berhasil Login",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.blue[300],
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (data[0]['role'] == "salon" && data[0]['status'] == "aktif" ||
          data[0]['status'] == "tutup") {
        autoselesai();
        pre.setString("username", data[0]['username'].toString());
        pre.setString("role", data[0]['role'].toString());
        pre.setString("kota", data[0]['kota'].toString());
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboardsalon(),
            ));
        Fluttertoast.showToast(
            msg: "Berhasil Login",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.blue[300],
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        alertnonaktif(this.context);
      }
    }).catchError((err) {
      alertgagal(this.context);
      print(err);
    });
    return "";
  }

  Future<String> loginUser() async {
    pre = await SharedPreferences.getInstance();
    Map paramData = {
      'password': myPassword.text,
      'username': myUsername.text,
    };
    var parameter = json.encode(paramData);
    http
        .post(main_variable.ipnumber + "/login",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      print(res.body);
      main_variable.userlogin = myUsername.text;

      data = data[0]['status'];
      print(data);
      if (data[0]['role'] == "admin") {
        autoselesai();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboardadmin(),
            ));
        Fluttertoast.showToast(
            msg: "Berhasil Login",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.blue[300],
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (data[0]['role'] == "member" && data[0]['status'] == "aktif") {
        autoselesai();
        main_variable.namauser = data[0]['nama'];
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboardmember(),
            ));
        Fluttertoast.showToast(
            msg: "Berhasil Login",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.blue[300],
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (data[0]['role'] == "salon" && data[0]['status'] == "aktif" ||
          data[0]['status'] == "tutup") {
        autoselesai();
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboardsalon(),
            ));
        Fluttertoast.showToast(
            msg: "Berhasil Login",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.blue[300],
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        alertnonaktif(this.context);
      }
    }).catchError((err) {
      alertgagal(this.context);
      print(err);
    });
    return "";
  }

  Future<String> getrole() async {
    //try {
    Map paramData = {'username': main_variable.userlogin};

    print(paramData);
    var parameter = json.encode(paramData);
    ClassUser databaru = new ClassUser(
        "email",
        "username",
        "password",
        "nama",
        "alamat",
        "kota",
        "telp",
        "foto",
        "saldo",
        "tgllahir",
        "jeniskelamin",
        "role",
        "status");
    http
        .post(main_variable.ipnumber + "/getrole",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      var data = json.decode(res.body);
      data = data[0]['status'];
      print(res.body);
      print(data.length);

      databaru = ClassUser(
          data[0]['email'].toString(),
          data[0]['username'].toString(),
          data[0]['password'].toString(),
          data[0]['nama'].toString(),
          data[0]['alamat'].toString(),
          data[0]['kota'].toString(),
          data[0]['telp'].toString(),
          data[0]['foto'].toString(),
          data[0]['saldo'].toString(),
          data[0]['tgllahir'].toString(),
          data[0]['jenikelamin'].toString(),
          data[0]['role'].toString(),
          data[0]['status'].toString());

      main_variable.roleuserlogin = databaru.role;
      main_variable.kotauser = databaru.kota;
      //main_variable.namauser = databaru.nama;
      print("ini roleuserlogin : " + main_variable.roleuserlogin);
      //print("ini nama user yang sedang login : " + main_variable.namauser);
      print("ini kotauser : " + main_variable.kotauser);

      return databaru;
    }).catchError((err) {
      print(err);
    });
  }

  alertnonaktif(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop(true);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Message"),
      content: Text("Opps..sorry, your account has been disabled"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  alertgagal(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop(true);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Message"),
      content: Text(
          "Opps, Login Failed.. please check your password or username or email"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

//INI FUNC REGIS SEMUA
  Future<String> insertsalon() async {
    Map paramData = {
      'email': myEmail.text,
      'username': myUsername.text,
      'password': myPassword.text,
    };
    var parameter = json.encode(paramData);
    http
        .post(main_variable.ipnumber + "/insertsalon",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body);

      if (res.body.contains("sukses")) {
        Fluttertoast.showToast(msg: "Berhasil Login");
        print("Berhasil Register");
      } else {
        print("Register gagal");
      }
    }).catchError((err) {
      alertgagal(this.context);
      print(err);
    });
    return "";
  }

  Future<String> tambahUser() async {
    Map paramData = {
      'email': myEmail.text,
      'username': myUsername.text,
      'password': myPassword.text,
      'jeniskelamin': jeniskelamin,
      'roleuser': roleuser,
    };
    var parameter = json.encode(paramData);
    http
        .post(main_variable.ipnumber + "/register",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print(res.body);

      if (res.body.contains("sukses")) {
        print("Berhasil Register");
        myEmail.text = "";
        myUsername.text = "";
        myPassword.text = "";
      } else {
        print("Register gagal");
      }
    }).catchError((err) {
      alertgagal(this.context);
      print(err);
    });
    return "";
  }
//

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Warnalayer.backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("images/background.png"),
                      fit: BoxFit.fill)),
              child: Container(
                padding: EdgeInsets.only(top: 90, left: 20),
                color: Color(0xFF3b5999).withOpacity(.85),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                          text: "Welcome to",
                          style: TextStyle(
                            fontSize: 25,
                            letterSpacing: 2,
                            color: Colors.yellow[700],
                          ),
                          children: [
                            TextSpan(
                              text: isSignupScreen
                                  ? " Salon-Online,"
                                  : " Salon-Online,",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow[700],
                              ),
                            )
                          ]),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      isSignupScreen
                          ? "Signup to Continue"
                          : "Signin to Continue",
                      style: TextStyle(
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          //Main Contianer for Login and Signup
          AnimatedPositioned(
            duration: Duration(milliseconds: 700),
            curve: Curves.easeInCubic,
            //ini atur jarak atas signin dan signup
            top: isSignupScreen ? 200 : 230,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 700),
              curve: Curves.easeInCubic,
              //ini atur besar container signup dan signin
              height: isSignupScreen ? 475 : 350,
              padding: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 40,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5),
                  ]),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignupScreen = false;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "LOGIN",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: !isSignupScreen
                                        ? Warnalayer.activeColor
                                        : Warnalayer.textColor1),
                              ),
                              if (!isSignupScreen)
                                Container(
                                  margin: EdgeInsets.only(top: 3),
                                  height: 2,
                                  width: 55,
                                  color: Colors.orange,
                                )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isSignupScreen = true;
                            });
                          },
                          child: Column(
                            children: [
                              Text(
                                "SIGNUP",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSignupScreen
                                        ? Warnalayer.activeColor
                                        : Warnalayer.textColor1),
                              ),
                              if (isSignupScreen)
                                Container(
                                  margin: EdgeInsets.only(top: 3),
                                  height: 2,
                                  width: 55,
                                  color: Colors.orange,
                                )
                            ],
                          ),
                        )
                      ],
                    ),
                    if (isSignupScreen) buildSignupSection(),
                    if (!isSignupScreen) buildSigninSection()
                  ],
                ),
              ),
            ),
          ),
          // Bottom buttons
          Positioned(
            top: MediaQuery.of(context).size.height - 100,
            right: 0,
            left: 0,
            child: Column(
              children: [
                Text(isSignupScreen ? "Or Signup with" : "Or Signin with"),
                Container(
                  margin: EdgeInsets.only(right: 20, left: 20, top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // buildTextButton(MaterialCommunityIcons.facebook,
                      //     "Facebook", Warnalayer.facebookColor),
                      buildTextButton(MaterialCommunityIcons.google_plus,
                          "Google", Warnalayer.googleColor),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Container buildSigninSection() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          buildTextField(MaterialCommunityIcons.account_outline, "User Name",
              false, false, myUsername),
          // buildTextField(
          //     Icons.mail_outline, "TA_SALON@gmail.com", false, true, myEmail),
          buildTextField(MaterialCommunityIcons.lock_outline, "**********",
              true, false, myPassword),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: isRememberMe,
                    activeColor: Warnalayer.textColor2,
                    onChanged: (value) {
                      setState(() {
                        isRememberMe = !isRememberMe;
                        print("isremember kecetak " + isRememberMe.toString());
                      });
                    },
                  ),
                  Text("Remember me",
                      style:
                          TextStyle(fontSize: 12, color: Warnalayer.textColor1))
                ],
              ),
              TextButton(
                onPressed: () {
                  print("ini forgot password");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPassword(),
                      ));
                },
                child: Text("Forgot Password?",
                    style:
                        TextStyle(fontSize: 12, color: Warnalayer.textColor1)),
              )
            ],
          ),
          //ini button login
          Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: RaisedButton(
                onPressed: () {
                  if (isRememberMe == false) {
                    loginUser();
                  } else {
                    loginUser_remember();
                  }

                  getrole();
                  print("ini email : " + myEmail.text.toString());
                  //print("ini username : " + myUsername.text.toString());
                  print("ini password : " + myPassword.text.toString());
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Container(
                    constraints:
                        BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text(
                      "Login",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildSignupSection() {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          buildTextField(MaterialCommunityIcons.account_outline, "User Name",
              false, false, myUsername),
          buildTextField(MaterialCommunityIcons.email_outline, "email", false,
              true, myEmail),
          buildTextField(MaterialCommunityIcons.lock_outline, "password", true,
              false, myPassword),
          //ini padding unntuk role (member/salon)
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMember = true;
                      isSalon = false;
                      roleuser = "member";
                      print("ini role user mem: " + roleuser);
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                            color: isMember
                                ? Warnalayer.textColor2
                                : Colors.transparent,
                            border: Border.all(
                                width: 1,
                                color: isMember
                                    ? Colors.transparent
                                    : Warnalayer.textColor1),
                            borderRadius: BorderRadius.circular(15)),
                        child: Icon(
                          MaterialCommunityIcons.account_outline,
                          color: isMember ? Colors.white : Warnalayer.iconColor,
                        ),
                      ),
                      Text(
                        "Member",
                        style: TextStyle(color: Warnalayer.textColor1),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMember = false;
                      isSalon = true;
                      roleuser = "salon";
                      print("ini role user sal: " + roleuser);
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                            color: isMember
                                ? Colors.transparent
                                : Warnalayer.textColor2,
                            border: Border.all(
                                width: 1,
                                color: isMember
                                    ? Warnalayer.textColor1
                                    : Colors.transparent),
                            borderRadius: BorderRadius.circular(15)),
                        child: Icon(
                          MaterialCommunityIcons.store,
                          color: isMember ? Warnalayer.iconColor : Colors.white,
                        ),
                      ),
                      Text(
                        "Salon",
                        style: TextStyle(color: Warnalayer.textColor1),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          //ini padding unntuk JK (female/male)
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMale = true;
                      isFemale = false;
                      jeniskelamin = "pria";
                      print("ini jk pria: " + jeniskelamin);
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        decoration: BoxDecoration(
                            color: isMale
                                ? Warnalayer.textColor2
                                : Colors.transparent,
                            border: Border.all(
                                width: 1,
                                color: isMale
                                    ? Colors.transparent
                                    : Warnalayer.textColor1),
                            borderRadius: BorderRadius.circular(15)),
                        child: Icon(
                          MaterialCommunityIcons.account_outline,
                          color: isMale ? Colors.white : Warnalayer.iconColor,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 17, 0),
                          child: Text('Male',
                              style: TextStyle(color: Warnalayer.textColor1))),
                    ],
                  ),
                ),
                SizedBox(
                  width: 30,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isMale = false;
                      isFemale = true;
                      jeniskelamin = "wanita";
                      print("ini jk wanita: " + jeniskelamin);
                    });
                  },
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                            color: isMale
                                ? Colors.transparent
                                : Warnalayer.textColor2,
                            border: Border.all(
                                width: 1,
                                color: isMale
                                    ? Warnalayer.textColor1
                                    : Colors.transparent),
                            borderRadius: BorderRadius.circular(15)),
                        child: Icon(
                          MaterialCommunityIcons.account_outline,
                          color: isMale ? Warnalayer.iconColor : Colors.white,
                        ),
                      ),
                      Text(
                        "Female",
                        style: TextStyle(color: Warnalayer.textColor1),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 200,
            margin: EdgeInsets.only(top: 20),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: "By pressing 'Register' you agree to our ",
                  style: TextStyle(color: Warnalayer.textColor2),
                  children: [
                    TextSpan(
                      //recognizer: ,
                      text: "term & conditions",
                      style: TextStyle(color: Colors.orange),
                    ),
                  ]),
            ),
          ),
          //ini button regis
          Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: RaisedButton(
                onPressed: () {
                  if (roleuser == "salon") {
                    insertsalon();
                  }
                  if (isRememberMe == true) {
                    datauser();
                    tambahUser();
                  } else {
                    tambahUser();
                  }
                  print("ini jk : " + jeniskelamin);
                  print("ini role user : " + roleuser);
                  print("ini email : " + myEmail.text);
                  print("ini username : " + myUsername.text);
                  print("ini password : " + myPassword.text);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                padding: EdgeInsets.all(0.0),
                child: Ink(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff374ABE), Color(0xff64B6FF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Container(
                    constraints:
                        BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                    alignment: Alignment.center,
                    child: Text(
                      "Register",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextButton buildTextButton(
      IconData icon, String title, Color backgroundColor) {
    return TextButton(
      //ini on press sign up with facebook or google
      onPressed: () {
        print("ini code buat sign up pake goole account");
      },
      style: TextButton.styleFrom(
          side: BorderSide(width: 1, color: Colors.grey),
          minimumSize: Size(145, 40),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          primary: Colors.white,
          backgroundColor: backgroundColor),
      child: Row(
        children: [
          Icon(
            icon,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            title,
          )
        ],
      ),
    );
  }

  Widget buildBottomHalfContainer(bool showShadow) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 700),
      curve: Curves.easeInCubic,
      top: isSignupScreen ? 535 : 430,
      right: 0,
      left: 0,
      child: Center(
        child: Container(
          height: 90,
          width: 90,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                if (showShadow)
                  BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    spreadRadius: 1.5,
                    blurRadius: 10,
                  )
              ]),
          child: !showShadow
              //ini panah kiri
              ? Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.orange[200], Colors.red[400]],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(.3),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 1))
                      ]),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                )
              : Center(),
        ),
      ),
    );
  }

  Widget buildTextField(IconData icon, String hintText, bool isPassword,
      bool isEmail, TextEditingController myControll) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: TextField(
        obscureText: isPassword,
        controller: myControll,
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
