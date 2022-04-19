class StudentCard {
  String? speciality;
  int? id;

  StudentCard({this.speciality, this.id});

  StudentCard.fromJson(Map<String, dynamic> json) {
    speciality = json["SPECIALITY"];
    id = json["ID"];
  }
}
