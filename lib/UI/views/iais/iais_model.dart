class CourseIais {
  String? DISC_NAME;
  String? DISC_REP; //отчётность
  String? DISC_HOURS;
  String? FIO;
  String? DISC_FIRST_DATE;
  String? DISC_LAST_DATE;
  int? DISC_MARK;

  CourseIais(
      {this.DISC_NAME, this.DISC_REP, this.DISC_HOURS, this.FIO, this.DISC_FIRST_DATE, this.DISC_LAST_DATE, this.DISC_MARK});

  CourseIais.fromJson(Map<String, dynamic> json) {
    DISC_NAME = json["DISC_NAME"];
    DISC_REP = json["DISC_REP"];
    DISC_HOURS = json["DISC_HOURS"];
    FIO = json["FIO"];
    DISC_FIRST_DATE = json["DISC_FIRST_DATE"];
    DISC_LAST_DATE = json["DISC_LAST_DATE"];
    DISC_MARK = json["DISC_MARK"];
  }
}