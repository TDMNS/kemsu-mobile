class PgasDetailModel {
  String? studyYear;
  int? courseNum;
  String? semesterType;
  String? surname;
  String? name;
  String? patronymic;
  String? facultyName;
  String? group;
  String? phone;
  int? facultyId;
  int? semesterTypeId;

  PgasDetailModel({
    this.studyYear,
    this.courseNum,
    this.semesterType,
    this.surname,
    this.name,
    this.patronymic,
    this.facultyName,
    this.group,
    this.phone,
    this.facultyId,
    this.semesterTypeId
  });

  PgasDetailModel.fromJson(Map<String, dynamic> json) {
    studyYear = json["studyYear"];
    courseNum = json["courseNum"];
    semesterType = json["semesterType"];
    surname = json["surname"];
    name = json["name"];
    patronymic = json["patronymic"];
    facultyName = json["facultyName"];
    group = json["group"];
    phone = json["phone"];
    facultyId = json["facultyId"];
    semesterTypeId = json["semesterTypeId"];
  }
}