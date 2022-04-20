import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/UI/views/pgas/model/activity_tree.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

import 'model/achieve_category.dart';

class NewAchievePgasViewModel extends BaseViewModel {
  NewAchievePgasViewModel(BuildContext context);
  FlutterSecureStorage storage = const FlutterSecureStorage();
  List<AchieveCategoryModel> achieveCategories = [];
  AchieveCategoryModel? chosenCategory;
  bool isCategoryChosen = false;
  List<ActivityTreeModel> activityList = [];
  ActivityTreeModel? chosenActivity;
  List<Widget> dropdownsList = [];

  Future onReady() async {
    await fetchAchieveCategories();
  }

  fetchAchieveCategories() async {
    String? eiosAccessToken = await storage.read(key: "tokenKey");
    Map<String, String> header = {
      "X-Access-Token": "$eiosAccessToken"
    };
    var response = await http.post(Uri.parse("https://api-next.kemsu.ru/api/student-depatment/pgas-mobile/getActivityTypeList"), headers: header);
    achieveCategories = parseAchieveCategories(json.decode(response.body)["result"]);
    notifyListeners();
  }

  fetchAchieves(int? parentId, int? activityId) async {
    String? eiosAccessToken = await storage.read(key: "tokenKey");
    Map<String, String> header = {
      "X-Access-Token": "$eiosAccessToken"
    };
    Map<String, dynamic> body = {
      "parentId": parentId,
      "activityTypeId": activityId
    };
    var response = await http.post(Uri.parse("https://api-next.kemsu.ru/api/student-depatment/pgas-mobile/getActivityList"), headers: header, body: body);
    activityList = parseActivities(json.decode(response.body)["result"]);
    notifyListeners();
  }

  List<AchieveCategoryModel> parseAchieveCategories(List response) {
    return response
        .map<AchieveCategoryModel>((json) => AchieveCategoryModel.fromJson(json))
        .toList();
  }

  List<ActivityTreeModel> parseActivities(List response) {
    return response
        .map<ActivityTreeModel>((json) => ActivityTreeModel.fromJson(json))
        .toList();
  }

  addDropDownWidget(Container dropdownButton) {
    dropdownsList.add(dropdownButton);
    notifyListeners();
  }
}