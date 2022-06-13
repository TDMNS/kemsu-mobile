class BasisOfEducation {
  String? basic;

  BasisOfEducation({this.basic});

  BasisOfEducation.fromJson(Map<String, dynamic> json) {
    basic = json["BASIC"];
  }
}

class PeriodListModel {
  String? period;

  PeriodListModel({this.period});

  PeriodListModel.fromJson(Map<String, dynamic> json) {
    period = json["PERIOD"];
  }
}
