import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/UI/views/PRS/prs_model.dart';
import 'package:kemsu_app/UI/views/schedule/schedule_model.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import '../../../API/config.dart';
import '../auth/auth_view.dart';

class PRSViewModel extends BaseViewModel {
  PRSViewModel(BuildContext context);
  final storage = const FlutterSecureStorage();

  /// first request
  List<StudyCard> receivedStudyCard = [];
  StudyCard? studyCard;

  /// second request
  List<PrsSemesterList> prsSemesterList = [];

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

  changeCard(value) async {
    studyCard = value;
    String? token = await storage.read(key: "tokenKey");
    var response = await http.get(Uri.parse(
        '${Config.brsSemesterList}/${studyCard?.id}?accessToken=$token'));
    prsSemesterList =
        parsePrsSemesterList(json.decode(response.body)["brsSemesterList"]);
    print(prsSemesterList[0].semester);
    notifyListeners();
  }

  List<PrsSemesterList> parsePrsSemesterList(List response) {
    return response
        .map<PrsSemesterList>((json) => PrsSemesterList.fromJson(json))
        .toList();
  }
}
