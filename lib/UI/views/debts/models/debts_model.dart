class AcademyDebts {
  int? course;
  int? semester;
  String? discipline;
  String? mark;
  String? shortMark;

  AcademyDebts(
      {this.course, this.semester, this.discipline, this.mark, this.shortMark});

  AcademyDebts.fromJson(Map<String, dynamic> json) {
    course = json["COURSE"];
    semester = json["SEMESTER"];
    discipline = json["DISCIPLINE"];
    mark = json["OCENKA"];
    shortMark = json["OCENKA_SHORT"];
  }
}