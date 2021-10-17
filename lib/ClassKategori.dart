class ClassKategori {
  String id,idkategori, namakategori;
  bool flag = false;
  String aktif;

  ClassKategori(this.id,this.idkategori, this.namakategori);

  bool getFlagAktif() {
    if (this.aktif == "1") {
      return true;
    } else {
      return false;
    }
  }

  Map toJson() =>
      {"idkategori": idkategori, "namakategori": namakategori, "aktif": aktif};
}
