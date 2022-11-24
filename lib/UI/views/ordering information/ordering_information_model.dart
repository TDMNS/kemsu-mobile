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
  int? periodId;
  String? period;
  int? selectedPeriod;

  PeriodListModel({
    this.periodId,
    this.period,
    this.selectedPeriod});

  PeriodListModel.fromJson(Map<String, dynamic> json) {
    periodId = json["GL_PERIOD_ID"];
    period = json["PERIOD"];
    selectedPeriod = json["DEF_SELECT"];
  }
}
