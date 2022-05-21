class ScheduleRequest {
  int? id;
  String? studyYear;
  int? semesterType;
  int? weekNum;
  String? title;

  ScheduleRequest(
      {this.id, this.studyYear, this.semesterType, this.weekNum, this.title});

  ScheduleRequest.fromJson(Map<String, dynamic> json) {
    id = json["Id"];
    studyYear = json["StudyYear"];
    semesterType = json["SemesterType"];
    weekNum = json["WeekNum"];
    title = json["Title"];
  }
}

class FacultyList {
  int? id;
  String? faculty;

  FacultyList({this.id, this.faculty});

  FacultyList.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    faculty = json['Faculty'];
  }
}

class GroupList {
  int? id;
  String? groupName;
  String? specName;
  String? learnForm;

  GroupList({this.id, this.groupName, this.specName, this.learnForm});

  GroupList.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    groupName = json['GroupName'];
    specName = json['specName'];
    learnForm = json['learnForm'];
  }
}

class WeekGetId {
  int? id;
  int? num;

  WeekGetId({this.id, this.num});

  WeekGetId.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    num = json['Num'];
  }
}

class WeekList {
  int? id;
  int? dayNum;
  String? dayName;
  String? dayNameShort;

  WeekList({this.id, this.dayNum, this.dayName, this.dayNameShort});

  WeekList.fromJson(Map<String, dynamic> json) {
    id = json["Id"];
    dayNum = json["DayNum"];
    dayName = json["DayName"];
    dayNameShort = json["DayNameShort"];
  }
}

class WeekType {
  int? id;
  String? name;

  WeekType({this.id, this.name});

  WeekType.fromJson(Map<String, dynamic> json) {
    id = json["Id"];
    name = json["Name"];
  }
}

class CoupleList {
  int? id;
  int? num;
  String? desc;

  CoupleList({this.id, this.num, this.desc});

  CoupleList.fromJson(Map<String, dynamic> json) {
    id = json["Id"];
    num = json["Num"];
    desc = json["Description"];
  }
}

class CurrentGroupList {
  int? facultyId;
  String? facultyName;
  int? groupId;
  String? groupName;
  String? studyYear;
  int? semesterId;

  CurrentGroupList(
      {this.facultyId,
      this.facultyName,
      this.groupId,
      this.groupName,
      this.semesterId,
      this.studyYear});

  CurrentGroupList.fromJson(Map<String, dynamic> json) {
    facultyId = json["facultyId"];
    facultyName = json["facultyName"];
    groupId = json["groupId"];
    groupName = json["groupName"];
    studyYear = json["studyYear"];
    semesterId = json["semesterId"];
  }
}

class CoupleModel {
  String? discName;
  String? prepName;
  String? auditoryName;
  String? lessonType;
  int? loadDiscipId;
  String? periodTypeName;
  int? periodTypeId;
  int? maxWeekNum;
  int? minWeekNum;
  int? selectFlag;
  var periodTypePref;

  CoupleModel(
      {this.discName,
      this.prepName,
      this.auditoryName,
      this.lessonType,
      this.loadDiscipId,
      this.periodTypeName,
      this.periodTypeId,
      this.maxWeekNum,
      this.minWeekNum,
      this.selectFlag,
      this.periodTypePref});

  CoupleModel.fromJson(Map<String, dynamic> json) {
    discName = json["DiscName"];
    prepName = json["PrepName"];
    auditoryName = json["AuditoryName"];
    lessonType = json["lessonType"];
    loadDiscipId = json["loadDiscipId"];
    periodTypeName = json["periodTypeName"];
    periodTypeId = json["PeriodTypeId"];
    maxWeekNum = json["maxWeekNum"];
    minWeekNum = json["minWeekNum"];
    selectFlag = json["selectFlag"];
    periodTypePref = json["periodTypePref"];
  }
}
