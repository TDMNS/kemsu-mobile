class AcademyDebts {
  int? COURSE;
  int? SEMESTER;
  String? DISCIPLINE;
  String? OCENKA;

  AcademyDebts(
      {this.COURSE, this.SEMESTER, this.DISCIPLINE, this.OCENKA});

  AcademyDebts.fromJson(Map<String, dynamic> json) {
    COURSE = json["COURSE"];
    SEMESTER = json["SEMESTER"];
    DISCIPLINE = json["DISCIPLINE"];
    OCENKA = json["OCENKA"];
  }
}