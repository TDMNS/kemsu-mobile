class ShortPgasRequestModel {
  int? requestId;
  String? studyYear;
  int? courseNum;
  String? semesterType;
  String? semesterTypeShort;
  String? surname;
  String? name;
  String? patronymic;
  String? facultyName;
  String? shortFacultyName;
  String? groupName;
  String? phoneNum;
  int? approveFlag;
  int? facultyId;
  int? semesterTypeId;

  ShortPgasRequestModel({
    this.requestId,
    this.studyYear,
    this.courseNum,
    this.semesterType,
    this.semesterTypeShort,
    this.surname,
    this.name,
    this.patronymic,
    this.facultyName,
    this.shortFacultyName,
    this.groupName,
    this.phoneNum,
    this.approveFlag,
    this.facultyId,
    this.semesterTypeId
});

  ShortPgasRequestModel.fromJson(Map<String, dynamic> json) {
    requestId = json["requestId"];
    studyYear = json["studyYear"];
    courseNum = json["courseNum"];
    semesterType = json["semesterType"];
    semesterTypeShort = json["semesterTypeShort"];
    surname = json["surname"];
    name = json["name"];
    patronymic = json["patronymic"];
    facultyName = json["facultyName"];
    shortFacultyName = json["shortFacultyName"];
    groupName = json["groupName"];
    phoneNum = json["phoneNum"];
    approveFlag = json["approveFlag"];
    facultyId = json["facultyId"];
    facultyName = json["facultyName"];
  }
}