class BasisOfEducation {
  String? basic;
  int? basicId;
  int? selectedBasic;

  BasisOfEducation({this.basic, this.basicId, this.selectedBasic});

  BasisOfEducation.fromJson(Map<String, dynamic> json) {
    basic = json["BASIC"];
    basicId = json["DIC_ED_BASIC_ID"];
    selectedBasic = json["DEF_SELECT"];
  }
}

class PeriodListModel {
  String? period;

  PeriodListModel({this.period});

  PeriodListModel.fromJson(Map<String, dynamic> json) {
    period = json["PERIOD"];
  }
}
