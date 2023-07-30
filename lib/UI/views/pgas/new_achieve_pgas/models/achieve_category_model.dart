class AchieveCategoryModel {
  int? activityTypeId;
  String? activityTypeTitle;

  AchieveCategoryModel({this.activityTypeId, this.activityTypeTitle});

  AchieveCategoryModel.fromJson(Map<String, dynamic> json) {
    activityTypeId = json["activityTypeId"];
    activityTypeTitle = json["activityTypeTitle"];
  }
}