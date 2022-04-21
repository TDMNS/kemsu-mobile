class SemesterTypeModel {
  int? semesterTypeId;
  String? semesterTypeTitle;

  SemesterTypeModel({this.semesterTypeId, this.semesterTypeTitle});

  SemesterTypeModel.fromJson(Map<String, dynamic> json) {
    semesterTypeId = json["semesterTypeId"];
    semesterTypeTitle = json["semesterTypeTitle"];
  }
}