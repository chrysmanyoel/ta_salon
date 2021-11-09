import 'package:flutter/material.dart';
import 'package:ta_salon/ClassLayananSalon.dart';
import 'package:ta_salon/DetailServiceSalon.dart';
import 'main_variable.dart' as main_variable;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ServiceSalon extends StatefulWidget {
  @override
  ServiceSalonState createState() => ServiceSalonState();
}

//ini buat proper kata / Kapitalisasi 2 kata jadi besar
extension CapExtension on String {
  String get caps =>
      this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
  String get capitalizeFirstofEach1 => this
      .replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.caps)
      .join(" ");
}

class ServiceSalonState extends State<ServiceSalon> {
  List<ClassLayanansalon> arr = new List();
  String foto = main_variable.ipnumber + "/gambar/default.png";

  void initState() {
    super.initState();

    setState(() {
      arr.add(new ClassLayanansalon(
          "id",
          "0",
          "username",
          "namalayanan",
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
          "0",
          "default.png"));
    });

    print('3. ' +
        main_variable.usernamesalon +
        " - " +
        main_variable.idsalonlogin);
    getlayanansalon();
    print('nanas');
  }

  Future<ClassLayanansalon> getlayanansalon() async {
    List<ClassLayanansalon> arrtemp = new List();
    Map paramData = {
      'idsalon': main_variable.idsalonlogin,
    };
    var parameter = json.encode(paramData);

    http
        .post(main_variable.ipnumber + "/getlayanansalon",
            headers: {"Content-Type": "application/json"}, body: parameter)
        .then((res) {
      print('semangka');
      var data = json.decode(res.body);
      data = data[0]['status'];
      print('melon');
      //print("ini service salon : " + data);

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
            data[i]['keterlambatan_waktu'].toString(),
            data[i]['foto'].toString());
        arrtemp.add(databaru);
        foto = main_variable.ipnumber + "/gambar/" + arrtemp[i].foto;
      }

      setState(() => this.arr = arrtemp);
      print('panjang arr : ' + this.arr.length.toString());

      return arrtemp;
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
        itemCount: arr.length,
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  print(index);
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(90.0, 5.0, 20.0, 5.0),
                      height: 180.0,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(100.0, 10.0, 20.0, 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              arr[index].namalayanan.capitalizeFirstofEach1,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              //"Potong rambut kekinian dengan style korean asli ",
                              arr[index].deskripsi,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w300),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              //"Potong rambut kekinian dengan style korean asli ",
                              "Peruntukan : " + arr[index].peruntukan,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w300),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              //"Potong rambut kekinian dengan style korean asli ",
                              "Jenjang Usia : " + arr[index].jenjangusia,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.w300),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: <Widget>[
                                GestureDetector(
                                  child: RaisedButton(
                                    onPressed: () {
                                      print('ini button see detail ' +
                                          index.toString());
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetailServiceSalon(
                                                    namaservicekirim:
                                                        arr[index].namalayanan,
                                                    idservice: arr[index].id,
                                                    kodelayanan:
                                                        arr[index].idkategori),
                                          ));
                                    },
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(95.0)),
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
                                            maxWidth: 100.0, minHeight: 35.0),
                                        alignment: Alignment.center,
                                        child: Text(
                                          "See Detail",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.0),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Positioned(
                      left: 45.0,
                      top: 15.0,
                      bottom: 15.0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          main_variable.ipnumber + "/gambar/" + arr[index].foto,
                          width: 110.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                color: Colors.teal.shade100,
                thickness: 1.0,
              ),
            ],
          );
        },
      ),
    );
  }
}
