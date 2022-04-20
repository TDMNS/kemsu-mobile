class StudyCard {
  String? speciality;
  int? id;

  StudyCard({this.speciality, this.id});

  StudyCard.fromJson(Map<String, dynamic> json) {
    speciality = json["SPECIALITY"];
    id = json["ID"];
  }
}

class PrsSemesterList {
  int? semester;
  int? startDate;
  int? endDate;
  int? commonScore;

  PrsSemesterList(
      {this.semester, this.startDate, this.endDate, this.commonScore});

  PrsSemesterList.fromJson(Map<String, dynamic> json) {
    semester = json["SEMESTER"];
    startDate = json["STUD_YEAR_START"];
    endDate = json["STUD_YEAR_END"];
    commonScore = json["COMMON_BALL_FOR_SEMESTER"];
  }
}
