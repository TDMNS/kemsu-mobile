class UserNotifications {
  String? title;
  String? message;
  String? notificationDateTime;
  String? fileSrc;
  int? fileSize;
  int? newNotificationFlag;

  UserNotifications({this.title, this.message, this.notificationDateTime, this.fileSrc, this.fileSize, this.newNotificationFlag});

  UserNotifications.fromJson(Map<String, dynamic> json) {
    title = json["title"];
    message = json["message"];
    notificationDateTime = json["notificationDateTime"];
    fileSrc = json["fileSrc"]?.toString() ?? "";
    fileSize = json["fileSize"]?.toInt() ?? 0;
    newNotificationFlag = json["newNotificationFlag"];
  }
}