import 'dart:ffi';

class StudentCard {
  String? speciality;
  Int? id;

  StudentCard({this.speciality, this.id});

  StudentCard.fromJson(Map<String, dynamic> json) {
    speciality = json["SPECIALITY"];
    id = json["ID"];
  }
}
