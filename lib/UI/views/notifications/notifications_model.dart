class UserNotifications {
  List<LinkList>? linkList;
  String? title;
  String? message;
  String? notificationDateTime;
  String? fileSrc;
  int? fileSize;
  int? newNotificationFlag;

  UserNotifications({this.linkList, this.title, this.message, this.notificationDateTime, this.fileSrc, this.fileSize, this.newNotificationFlag});

  UserNotifications.fromJson(Map<String, dynamic> json) {
    linkList = (json['linkList'] as List<dynamic>?)
        ?.map((dynamic item) => LinkList.fromJson(item))
        .toList();
    title = json["title"];
    message = json["message"];
    notificationDateTime = json["notificationDateTime"];
    fileSrc = json["fileSrc"]?.toString() ?? "";
    fileSize = json["fileSize"]?.toInt() ?? 0;
    newNotificationFlag = json["newNotificationFlag"];
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