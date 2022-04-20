class ActivityTreeModel {
  int? activityId;
  String? activityTitle;
  int? activityBall;
  int? nodeCnt;
  int? nodeFlag;
  int? ballFlag;

  ActivityTreeModel({this.activityId, this.activityTitle, this.activityBall,
    this.nodeCnt, this.nodeFlag, this.ballFlag});

  ActivityTreeModel.fromJson(Map<String, dynamic> json) {
    activityId = json["activityId"];
    activityTitle = json["activityTitle"];
    activityBall = json["activityBall"];
    nodeCnt = json["nodeCnt"];
    nodeFlag = json["nodeFlag"];
    ballFlag = json["ballFlag"];
  }
}