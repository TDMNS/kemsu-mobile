class ReportModel {
  int? reportId;
  String? message;
  String? messageDate;

  ReportModel({
    this.reportId, this.message, this.messageDate
  });

  ReportModel.fromJson(Map<String, dynamic> json) {
    reportId = json["reportId"];
    message = json["message"];
    messageDate = json["messageDate"];
  }
}