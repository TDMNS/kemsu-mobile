import 'dart:convert';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

import '../../../../Configurations/config.dart';
import '../../../../domain/dio_interceptor/dio_client.dart';
import 'models/achieve_category_model.dart';
import 'models/activity_tree_model.dart';
import 'year_model.dart';

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
  String? fileName;

  TextEditingController descController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController resourceController = TextEditingController();

  bool circle = false;

  final months = [
    "январь",
    "февраль",
    "март",
    "апрель",
    "май",
    "июнь",
    "июль",
    "август",
    "сентябрь",
    "октябрь",
    "ноябрь",
    "декабрь"
  ];

  List<YearModel> years = [];
  YearModel? chosenYear;

  Future onReady() async {
    await fetchAchieveCategories();
    await fetchYears();
    appMetricaTest();
  }

  void appMetricaTest() {
    AppMetrica.activate(
        const AppMetricaConfig("21985624-7a51-4a70-8a98-83b918e490d8"));
    AppMetrica.reportEvent('New achieve pgas event');
  }

  fetchAchieveCategories() async {
    String? accessToken = await storage.read(key: "tokenKey");
    Map<String, String> header = {"X-Access-Token": "$accessToken"};
    var response = await http.post(
        Uri.parse(Config.pgasGetActivityTypeList),
        headers: header);
    achieveCategories =
        parseAchieveCategories(json.decode(response.body)["result"]);
    notifyListeners();
  }

  fetchYears() async {
    String? requestId = await storage.read(key: "pgas_id");
    String? accessToken = await storage.read(key: "tokenKey");
    Map<String, String> header = {"X-Access-Token": "$accessToken"};

    var response = await http.get(
        Uri.parse("${Config.pgas}/activityYearList?requestId=$requestId"),
        headers: header);

    years = parseYears(json.decode(response.body)["result"]);
    notifyListeners();
  }

  Future<List<ActivityTreeModel>> fetchAchieves(
      int? parentId, int? activityId) async {
    String? accessToken = await storage.read(key: "tokenKey");
    Map<String, String> header = {"X-Access-Token": "$accessToken"};
    Map<String, dynamic> body = {
      "parentId": parentId.toString(),
      "activityTypeId": activityId.toString()
    };
    var response = await http.post(
        Uri.parse(Config.pgasGetActivityList),
        headers: header,
        body: body);
    return parseActivities(json.decode(response.body)["result"]);
  }

  sendButtonAction(context) async {
    circle = true;
    notifyListeners();
    String? accessToken = await storage.read(key: "tokenKey");
    String? requestId = await storage.read(key: "pgas_id");
    Map<String, String> header = {"X-Access-Token": "$accessToken"};

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
      "activityFile": fileName
    };

    var response = await http.post(
        Uri.parse(Config.pgasAddUserActivity),
        headers: header,
        body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      circle = false;
      notifyListeners();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(json.decode(response.body)["message"])));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(json.decode(response.body)["message"])));
    }
  }

  pickFileBtnAction(context) async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    chooseFile = result.files.first;
    notifyListeners();
  }

  loadFilePgas(context) async {
    String? accessToken = await storage.read(key: "tokenKey");

    FormData fd = FormData.fromMap({
      "file.${chooseFile!.extension}":
          await MultipartFile.fromFile(chooseFile!.path.toString()),
      "uniqueNames": true,
      "overwrite": true,
      "totalSizeLimit": (10 * 1024 * 1024),
    });

    final dio = DioClient(Dio());

    var response = await dio
        .put(Config.pgas, options: Options(headers: {'x-access-token': accessToken}), data: fd);

    if (response.statusCode == 200 || response.statusCode == 201) {
      fileName = json.decode(json.encode(response.data["fileNames"].first));
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Файл загружен успешно.")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(json.decode(response.data)["message"])));
    }
  }

  List<AchieveCategoryModel> parseAchieveCategories(List response) {
    return response
        .map<AchieveCategoryModel>(
            (json) => AchieveCategoryModel.fromJson(json))
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
