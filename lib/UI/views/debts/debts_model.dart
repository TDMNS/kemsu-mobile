class AcademyDebts {
  int? course;
  int? semester;
  String? discipline;
  String? mark;
  String? markShort;

  AcademyDebts(
      {this.course, this.semester, this.discipline, this.mark, this.markShort});

  AcademyDebts.fromJson(Map<String, dynamic> json) {
    course = json["COURSE"];
    semester = json["SEMESTER"];
    discipline = json["DISCIPLINE"];
    mark = json["OCENKA"];
    markShort = json["OCENKA_SHORT"];
  }
}