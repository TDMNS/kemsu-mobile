class LibraryDebts {
  String? info;
  String? extraditionDay;
  String? estimatedReturnDay;

  LibraryDebts({this.info, this.extraditionDay, this.estimatedReturnDay});

  LibraryDebts.fromJson(Map<String, dynamic> json) {
    info = json["info"];
    extraditionDay = json["extraditionDay"];
    estimatedReturnDay = json["estimatedReturnDay"];
  }
}
