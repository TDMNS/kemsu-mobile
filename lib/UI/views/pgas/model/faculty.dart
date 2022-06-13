class FacultyModel {
  int? id;
  String? facultyTitle;
  String? facultyShortTitle;

  FacultyModel({this.id, this.facultyTitle});

  FacultyModel.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    facultyTitle = json["facultyTitle"];
    facultyShortTitle = json['facultyShortTitle'];
  }
}