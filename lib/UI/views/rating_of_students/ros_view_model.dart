import 'dart:convert';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/UI/views/rating_of_students/ros_model.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import '../../../Configurations/config.dart';

class RosViewModel extends BaseViewModel {
  RosViewModel(BuildContext context);
  final storage = const FlutterSecureStorage();

  /// first request
  List<StudyCard> receivedStudyCard = [];
  StudyCard? studyCard;

  /// second request
  List<RosSemesterList> rosSemesterList = [];

  /// third request
  List<ReitList> reitList = [];

  /// four request
  List<ReitItemList> reitItemList = [];

  int selectedIndex = 2;

  void onTapBottomBar(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Future onReady() async {
    await getStudCard();
    appMetricaTest();
  }

  void appMetricaTest() {
    AppMetrica.activate(const AppMetricaConfig("21985624-7a51-4a70-8a98-83b918e490d8"));
    AppMetrica.reportEvent('rating_of_students event');
  }

  getStudCard() async {
    String? token = await storage.read(key: "tokenKey");
    var response = await http.get(Uri.parse('${Config.studCardHost}?accessToken=$token'));
    receivedStudyCard = parseCard(json.decode(response.body));
    notifyListeners();
  }

  List<StudyCard> parseCard(List response) {
    return response.map<StudyCard>((json) => StudyCard.fromJson(json)).toList();
  }

  List<RosSemesterList> parseRosSemesterList(List response) {
    return response.map<RosSemesterList>((json) => RosSemesterList.fromJson(json)).toList();
  }

  List<ReitList> parseReitList(List response) {
    return response.map<ReitList>((json) => ReitList.fromJson(json)).toList();
  }

  List<ReitItemList> parseReitItemList(List response) {
    return response.map<ReitItemList>((json) => ReitItemList.fromJson(json)).toList();
  }

  changeCard(value) async {
    studyCard = value;
    String? token = await storage.read(key: "tokenKey");
    var response = await http.get(Uri.parse('${Config.brsSemesterList}/${studyCard?.id}?accessToken=$token'));
    rosSemesterList = parseRosSemesterList(json.decode(response.body)["brsSemesterList"]);
    notifyListeners();
  }

  getReitList(startDate, endDate, semester) async {
    String? token = await storage.read(key: "tokenKey");
    var response = await http.get(Uri.parse(
        '${Config.reitList}?studentId=${studyCard?.id}&studYearStart=$startDate&studYearEnd=$endDate&semester=$semester&accessToken=$token'));
    reitList = parseReitList(json.decode(response.body)["reitList"]);
    notifyListeners();
  }

  getReitItemList(studyId) async {
    String? token = await storage.read(key: "tokenKey");
    var response = await http.get(Uri.parse('${Config.reitItemList}?studyId=$studyId&accessToken=$token'));
    reitItemList = parseReitItemList(json.decode(response.body)["brsActivityList"]);
    notifyListeners();
  }
}
