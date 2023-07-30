class UserAchieveModel {
  String? activityName;
  String? fullActivityName;
  String? activityType;
  int? activityYear;
  String? activityMonth;
  String? activitySrc;
  int? userActivityId;
  int? activityBall;
  int? approveFlag;
  int? groupActivityFlag;
  String? comment;
  String? activityFile;

  UserAchieveModel({
  this.activityName,
  this.fullActivityName,
  this.activityType,
  this.activityYear,
  this.activityMonth,
  this.activitySrc,
  this.userActivityId,
  this.activityBall,
  this.approveFlag,
  this.groupActivityFlag,
  this.comment,
    this.activityFile
});

  UserAchieveModel.fromJson(Map<String, dynamic> json) {
    activityName = json["activityName"];
    fullActivityName = json["fullActivityName"];
    activityType = json["activityType"];
    activityYear = json["activityYear"];
    activityMonth = json["activityMonth"];
    activitySrc = json["activitySrc"];
    userActivityId = json["userActivityId"];
    activityBall = json["activityBall"];
    approveFlag = json["approveFlag"];
    groupActivityFlag = json["groupActivityFlag"];
    comment = json["comment"];
    activityFile = json["activityFile"];
  }
}