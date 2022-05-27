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

class ReitList {
  String? discipline;
  String? intermediateAttestationForm;
  int? currentScore;
  int? frontScore;
  int? commonScore;
  String? mark;
  int? studyId;

  ReitList(
      {this.discipline,
      this.intermediateAttestationForm,
      this.currentScore,
      this.frontScore,
      this.commonScore,
      this.mark,
      this.studyId});

  ReitList.fromJson(Map<String, dynamic> json) {
    discipline = json["DEK_DISCIP_NAME"];
    intermediateAttestationForm = json["TIP_OTCH_SHORT"];
    currentScore = json["CURRENT_BALL"];
    frontScore = json["FRONT_BALL"];
    commonScore = json["COMMON_BALL"];
    mark = json["MARK_SHORT"];
    studyId = json["STUDY_ID"];
  }
}

class ReitItemList {
  String? activityName;
  String? comment;
  int? count;
  int? maxBall;
  int? ball;

  ReitItemList(
      {this.activityName, this.comment, this.count, this.maxBall, this.ball});

  ReitItemList.fromJson(Map<String, dynamic> json) {
    activityName = json["ACTIVITY_NAME"];
    comment = json["comment"];
    count = json["COUNT"];
    maxBall = json["MAX_BALL"];
    ball = json["BALL"];
  }
}
