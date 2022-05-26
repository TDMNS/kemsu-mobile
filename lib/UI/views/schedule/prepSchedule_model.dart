class TeacherList {
  int? prepId;
  String? fio;

  TeacherList({this.fio, this.prepId});

  TeacherList.fromJson(Map<String, dynamic> json) {
    prepId = json["prepId"];
    fio = json["fio"];
  }
}

class PrepScheduleModel {
  String? discName;
  String? auditoryName;
  String? lessonType;
  int? loadDiscipId;
  String? groupName;
  int? startWeekNum;
  int? endWeekNum;
  int? selectFlag;

  PrepScheduleModel(
      {this.groupName,
      this.auditoryName,
      this.discName,
      this.endWeekNum,
      this.lessonType,
      this.loadDiscipId,
      this.selectFlag,
      this.startWeekNum});

  PrepScheduleModel.fromJson(Map<String, dynamic> json) {
    discName = json["discName"];
    auditoryName = json["auditoryName"];
    lessonType = json["lessonType"];
    loadDiscipId = json["loadDiscipId"];
    groupName = json["groupName"];
    startWeekNum = json["startWeekNum"];
    endWeekNum = json["endWeekNum"];
    selectFlag = json["selectFlag"];
  }
}

class WeekList {
  int? Id;
  int? DayNum;
  String? DayName;
  String? DayNameShort;

  WeekList({this.DayName, this.DayNameShort, this.DayNum, this.Id});

  WeekList.fromJson(Map<String, dynamic> json) {
    Id = json["Id"];
    DayNum = json["DayNum"];
    DayName = json["DayName"];
    DayNameShort = json["DayNameShort"];
  }
}

class CoupleList {
  int? Id;
  int? Num;
  String? Description;

  CoupleList({this.Id, this.Num, this.Description});

  CoupleList.fromJson(Map<String, dynamic> json) {
    Id = json["Id"];
    Num = json["Num"];
    Description = json["Description"];
  }
}
