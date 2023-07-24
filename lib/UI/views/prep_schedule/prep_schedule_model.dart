import 'dart:convert';

class TeacherList {
  final int prepId;
  final String fio;

  TeacherList({required this.fio, required this.prepId});

  static TeacherList fromJson(Map<String, dynamic> json) =>
      TeacherList(fio: json['fio'], prepId: json['prepId']);
}

PrepScheduleApi prepScheduleApiFromJson(String str) =>
    PrepScheduleApi.fromJson(json.decode(str));

String prepScheduleApiToJson(PrepScheduleApi data) =>
    json.encode(data.toJson());

class PrepScheduleApi {
  PrepScheduleApi({
    this.success,
    this.result,
  });

  bool? success;
  Result? result;

  factory PrepScheduleApi.fromJson(Map<String, dynamic> json) =>
      PrepScheduleApi(
        success: json["success"],
        result: Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "result": result?.toJson(),
      };
}

class Result {
  Result({
    this.weekList,
    this.coupleList,
    this.prepScheduleTable,
  });

  List<Week>? weekList;
  List<Couple>? coupleList;
  List<PrepScheduleTable>? prepScheduleTable;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        weekList:
            List<Week>.from(json["weekList"].map((x) => Week.fromJson(x))),
        coupleList: List<Couple>.from(
            json["coupleList"].map((x) => Couple.fromJson(x))),
        prepScheduleTable: List<PrepScheduleTable>.from(
            json["prepScheduleTable"]
                .map((x) => PrepScheduleTable.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "weekList": List<dynamic>.from(weekList!.map((x) => x.toJson())),
        "coupleList": List<dynamic>.from(coupleList!.map((x) => x.toJson())),
        "prepScheduleTable":
            List<dynamic>.from(prepScheduleTable!.map((x) => x.toJson())),
      };
}

class Couple {
  Couple({
    this.id,
    this.num,
    this.description,
  });

  int? id;
  int? num;
  String? description;

  factory Couple.fromJson(Map<String, dynamic> json) => Couple(
        id: json["Id"],
        num: json["Num"],
        description: json["Description"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Num": num,
        "Description": description,
      };
}

class PrepScheduleTable {
  PrepScheduleTable({
    this.weekDay,
    this.ceilList,
  });

  Week? weekDay;
  List<CeilList>? ceilList;

  factory PrepScheduleTable.fromJson(Map<String, dynamic> json) =>
      PrepScheduleTable(
        weekDay: Week.fromJson(json["weekDay"]),
        ceilList: List<CeilList>.from(
            json["ceilList"].map((x) => CeilList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "weekDay": weekDay!.toJson(),
        "ceilList": List<dynamic>.from(ceilList!.map((x) => x.toJson())),
      };
}

class CeilList {
  CeilList({
    this.couple,
    this.ceil,
  });

  Couple? couple;
  Ceil? ceil;

  factory CeilList.fromJson(Map<String, dynamic> json) => CeilList(
        couple: Couple.fromJson(json["couple"]),
        ceil: Ceil.fromJson(json["ceil"]),
      );

  Map<String, dynamic> toJson() => {
        "couple": couple!.toJson(),
        "ceil": ceil!.toJson(),
      };
}

class Ceil {
  Ceil({
    this.uneven,
    this.even,
  });

  List<Even>? uneven;
  List<Even>? even;

  factory Ceil.fromJson(Map<String, dynamic> json) => Ceil(
        uneven: List<Even>.from(json["uneven"].map((x) => Even.fromJson(x))),
        even: List<Even>.from(json["even"].map((x) => Even.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "uneven": List<dynamic>.from(uneven!.map((x) => x.toJson())),
        "even": List<dynamic>.from(even!.map((x) => x.toJson())),
      };
}

class Even {
  Even({
    this.discName,
    this.auditoryName,
    this.lessonType,
    this.loadDiscipId,
    this.groupName,
    this.startWeekNum,
    this.endWeekNum,
    this.selectFlag,
  });

  String? discName;
  String? auditoryName;
  String? lessonType;
  int? loadDiscipId;
  String? groupName;
  int? startWeekNum;
  int? endWeekNum;
  int? selectFlag;

  factory Even.fromJson(Map<String, dynamic> json) => Even(
        discName: json["discName"],
        auditoryName: json["auditoryName"],
        lessonType: json["lessonType"],
        loadDiscipId: json["loadDiscipId"],
        groupName: json["groupName"],
        startWeekNum: json["startWeekNum"],
        endWeekNum: json["endWeekNum"],
        selectFlag: json["selectFlag"],
      );

  Map<String, dynamic> toJson() => {
        "discName": discName,
        "auditoryName": auditoryName,
        "lessonType": lessonType,
        "loadDiscipId": loadDiscipId,
        "groupName": groupName,
        "startWeekNum": startWeekNum,
        "endWeekNum": endWeekNum,
        "selectFlag": selectFlag,
      };
}

class Week {
  Week({
    this.id,
    this.dayNum,
    this.dayName,
    this.dayNameShort,
  });

  int? id;
  int? dayNum;
  String? dayName;
  String? dayNameShort;

  factory Week.fromJson(Map<String, dynamic> json) => Week(
        id: json["Id"],
        dayNum: json["DayNum"],
        dayName: json["DayName"],
        dayNameShort: json["DayNameShort"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "DayNum": dayNum,
        "DayName": dayName,
        "DayNameShort": dayNameShort,
      };
}

class EnumValues<T> {
  final Map<String, T> map;
  late final Map<T, String> reverseMap;

  EnumValues(this.map) {
    reverseMap = Map<T, String>.fromEntries(map.entries.map((e) => MapEntry(e.value, e.key)));
  }

  Map<T, String> get reverse => reverseMap;
}

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
