class UserNotifications {
  List<LinkList>? linkList;
  List<VoteList>? voteList;
  int? notificationId;
  String? title;
  String? message;
  String? notificationDateTime;
  String? fileSrc;
  String? voteTitle;
  int? fileSize;
  int? newNotificationFlag;
  int? selectedVoteId;

  UserNotifications(
      {this.linkList,
      this.voteList,
      this.notificationId,
      this.title,
      this.message,
      this.notificationDateTime,
      this.fileSrc,
      this.voteTitle,
      this.fileSize,
      this.newNotificationFlag,
      this.selectedVoteId});

  UserNotifications.fromJson(Map<String, dynamic> json) {
    linkList = (json['linkList'] as List<dynamic>?)?.map((dynamic item) => LinkList.fromJson(item)).toList();
    voteList = (json['voteList'] as List<dynamic>?)?.map((dynamic item) => VoteList.fromJson(item)).toList();
    notificationId = json["notificationId"];
    title = json["title"];
    message = json["message"];
    notificationDateTime = json["notificationDateTime"];
    fileSrc = json["fileSrc"]?.toString() ?? "";
    voteTitle = json["voteTitle"];
    fileSize = json["fileSize"]?.toInt() ?? 0;
    newNotificationFlag = json["newNotificationFlag"];
    selectedVoteId = json["selectedVoteId"];
  }
}

class LinkList {
  int? linkId;
  String? linkText;
  String? linkTitle;

  LinkList.fromJson(Map<String, dynamic> json) {
    linkId = json["linkId"];
    linkText = json["linkText"];
    linkTitle = json["linkTitle"];
  }
}

class VoteList {
  int? voteId;
  int? voteCnt;
  String? optionText;

  VoteList.fromJson(Map<String, dynamic> json) {
    voteId = json["voteId"];
    voteCnt = json["voteCnt"];
    optionText = json["optionText"];
  }
}
