class ClassSalon {
  String id,
      username,
      namasalon,
      alamat,
      kota,
      telp,
      longitude,
      latitude,
      keterangan,
      status;

  ClassSalon(this.id, this.username, this.namasalon, this.alamat, this.kota,
      this.telp, this.longitude, this.latitude, this.keterangan, this.status);

  void setstatus(String status) {
    this.status = status;
  }
}
