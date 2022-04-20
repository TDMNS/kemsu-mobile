class StudyCard {
  String? speciality;
  int? id;

  StudyCard({this.speciality, this.id});

  StudyCard.fromJson(Map<String, dynamic> json) {
    speciality = json["SPECIALITY"];
    id = json["ID"];
  }
}
