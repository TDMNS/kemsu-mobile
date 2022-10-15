import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/UI/views/PRS/prs_model.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import '../../../API/config.dart';

class PRSViewModel extends BaseViewModel {
  PRSViewModel(BuildContext context);
  final storage = const FlutterSecureStorage();

  /// first request
  List<StudyCard> receivedStudyCard = [];
  StudyCard? studyCard;

  /// second request
  List<PrsSemesterList> prsSemesterList = [];

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
  }

  getStudCard() async {
    String? token = await storage.read(key: "tokenKey");
    var response =
        await http.get(Uri.parse('${Config.studCardHost}?accessToken=$token'));
    receivedStudyCard = parseCard(json.decode(response.body));
    notifyListeners();
  }

  List<StudyCard> parseCard(List response) {
    return response.map<StudyCard>((json) => StudyCard.fromJson(json)).toList();
  }

  List<PrsSemesterList> parsePrsSemesterList(List response) {
    return response
        .map<PrsSemesterList>((json) => PrsSemesterList.fromJson(json))
        .toList();
  }

  List<ReitList> parseReitList(List response) {
    return response.map<ReitList>((json) => ReitList.fromJson(json)).toList();
  }

  List<ReitItemList> parseReitItemList(List response) {
    return response
        .map<ReitItemList>((json) => ReitItemList.fromJson(json))
        .toList();
  }

  changeCard(value) async {
    studyCard = value;
    String? token = await storage.read(key: "tokenKey");
    var response = await http.get(Uri.parse(
        '${Config.brsSemesterList}/${studyCard?.id}?accessToken=$token'));
    prsSemesterList =
        parsePrsSemesterList(json.decode(response.body)["brsSemesterList"]);
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
    var response = await http.get(Uri.parse(
        '${Config.reitItemList}?studyId=$studyId&accessToken=$token'));
    reitItemList =
        parseReitItemList(json.decode(response.body)["brsActivityList"]);
    notifyListeners();
  }
}
