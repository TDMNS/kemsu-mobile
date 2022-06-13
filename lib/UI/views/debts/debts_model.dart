class AcademyDebts {
  int? COURSE;
  int? SEMESTER;
  String? DISCIPLINE;
  String? OCENKA;
  String? OCENKA_SHORT;

  AcademyDebts(
      {this.COURSE, this.SEMESTER, this.DISCIPLINE, this.OCENKA, this.OCENKA_SHORT});

  AcademyDebts.fromJson(Map<String, dynamic> json) {
    COURSE = json["COURSE"];
    SEMESTER = json["SEMESTER"];
    DISCIPLINE = json["DISCIPLINE"];
    OCENKA = json["OCENKA"];
    OCENKA_SHORT = json["OCENKA_SHORT"];
  }
}