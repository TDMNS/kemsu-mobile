class ReportModel {
  int? reportId;
  String? message;
  String? messageDate;
  String? reportStatus;

  ReportModel({this.reportId, this.message, this.messageDate, this.reportStatus});

  ReportModel.fromJson(Map<String, dynamic> json) {
    reportId = json["reportId"];
    message = json["message"];
    messageDate = json["messageDate"];
    reportStatus = json["reportStatus"];
  }
}
