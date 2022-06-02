import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/UI/views/pgas/model/activity_tree.dart';
import 'package:kemsu_app/UI/views/pgas/model/year.dart';
import 'package:open_file/open_file.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

import 'model/achieve_category.dart';

class NewAchievePgasViewModel extends BaseViewModel {
  NewAchievePgasViewModel(BuildContext context);
  FlutterSecureStorage storage = const FlutterSecureStorage();
  List<AchieveCategoryModel> achieveCategories = [];
  AchieveCategoryModel? chosenCategory;
  List<ActivityTreeModel> activityList1 = [];
  List<ActivityTreeModel> activityList2 = [];
  List<ActivityTreeModel> activityList3 = [];
  List<ActivityTreeModel> activityList4 = [];

  ActivityTreeModel? chosenActivity1;
  ActivityTreeModel? chosenActivity2;
  ActivityTreeModel? chosenActivity3;
  ActivityTreeModel? chosenActivity4;
  ActivityTreeModel? resultActivity;
  int? chosenMonth;

  bool showAchieve1 = false;
  bool showAchieve2 = false;
  bool showAchieve3 = false;
  bool showAchieve4 = false;
  bool showOtherInputData = false;

  PlatformFile? chooseFile;
  String? eiosFileName;

  TextEditingController descController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController resourceController = TextEditingController();

  final months = ["январь", "февраль", "март", "апрель", "май", "июнь", "июль",
  "август", "сентябрь", "октябрь", "ноябрь", "декабрь"];

  List<YearModel> years = [];
  YearModel? chosenYear;

  Future onReady() async {
    await fetchAchieveCategories();
    await fetchYears();
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

  fetchYears() async {
    String? requestId = await storage.read(key: "pgas_id");
    String? eiosAccessToken = await storage.read(key: "tokenKey");
    Map<String, String> header = {
      "X-Access-Token": "$eiosAccessToken"
    };
    
    var response = await http.get(Uri.parse("https://api-next.kemsu.ru/api/student-depatment/pgas-mobile/activityYearList?requestId=$requestId"), headers: header);

    years = parseYears(json.decode(response.body)["result"]);
    notifyListeners();
  }

  Future<List<ActivityTreeModel>> fetchAchieves(int? parentId, int? activityId) async {
    String? eiosAccessToken = await storage.read(key: "tokenKey");
    Map<String, String> header = {
      "X-Access-Token": "$eiosAccessToken"
    };
    Map<String, dynamic> body = {
      "parentId": parentId.toString(),
      "activityTypeId": activityId.toString()
    };
    var response = await http.post(Uri.parse("https://api-next.kemsu.ru/api/student-depatment/pgas-mobile/getActivityList"), headers: header, body: body);
    print(json.decode(response.body)["result"]);
    return parseActivities(json.decode(response.body)["result"]);
  }

  sendButtonAction(context) async {
    String? eiosAccessToken = await storage.read(key: "tokenKey");
    String? requestId = await storage.read(key: "pgas_id");
    Map<String, String> header = {
      "X-Access-Token": "$eiosAccessToken"
    };

    if (chosenActivity4 != null) {
      resultActivity = chosenActivity4;
    } else if (chosenActivity3 != null) {
      resultActivity = chosenActivity3;
    } else if (chosenActivity2 != null) {
      resultActivity = chosenActivity2;
    } else if (chosenActivity1 != null) {
      resultActivity = chosenActivity1;
    }

    await loadFilePgas(context);

    Map<String, dynamic> body = {
      "activityId": resultActivity!.activityId.toString(),
      "requestId": int.parse(requestId!).toString(),
      "activityName": descController.text.isNotEmpty ? descController.text : "",
      "activityYear": chosenYear!.year.toString(),
      "activityMonthId": (chosenMonth! + 1).toString(),
      "activitySrc": resourceController.text,
      "activityFile": eiosFileName
    };

    print(body);

    var response = await http.post(Uri.parse("https://api-next.kemsu.ru/api/student-depatment/pgas-mobile/addUserActivity"), headers: header, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.of(context).pop();
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(json.decode(response.body)["message"])));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(json.decode(response.body)["message"])));
      print(response.body);
    }
  }

  pickFileBtnAction(context) async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    chooseFile = result.files.first;
    notifyListeners();
  }

  loadFilePgas(context) async {
    String? eiosAccessToken = await storage.read(key: "tokenKey");

    FormData fd = FormData.fromMap({
      chooseFile!.name: await MultipartFile.fromFile(chooseFile!.path.toString()),
      "uniqueNames": true,
      "overwrite": true,
      "totalSizeLimit": (10 * 1024 * 1024),
    });

    Dio dio = Dio();

    dio.options.headers["X-Access-Token"] = "$eiosAccessToken";

    var response = await dio.put("https://api-next.kemsu.ru/api/storage/pgas-mobile", data: fd);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.data["fileNames"]);
      eiosFileName = json.decode(json.encode(response.data["fileNames"].first));
      notifyListeners();
      print(response.data);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Файл загружен успешно.")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(json.decode(response.data)["message"])));
      print(response.data);
    }
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

  List<YearModel> parseYears(List response) {
    return response.map<YearModel>((json) => YearModel.fromJson(json)).toList();
  }

  openFile(PlatformFile file) {
    OpenFile.open(file.path);
  }
}