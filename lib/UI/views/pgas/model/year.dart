class YearModel {
  int? year;

  YearModel({this.year});

  YearModel.fromJson(Map<String, dynamic> json) {
    year = json["year"];
  }
}