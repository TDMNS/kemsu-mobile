class FacultyModel {
  int? id;
  String? facultyTitle;

  FacultyModel({this.id, this.facultyTitle});

  FacultyModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    facultyTitle = json["facultyTitle"];
  }
}