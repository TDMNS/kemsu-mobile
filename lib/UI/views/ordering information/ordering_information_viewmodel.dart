import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/UI/views/PRS/prs_model.dart';
import 'package:kemsu_app/UI/views/ordering%20information/ordering_information_model.dart';
import 'package:kemsu_app/UI/views/schedule/schedule_model.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import '../../../API/config.dart';
import '../auth/auth_view.dart';

class OrderingInformationViewModel extends BaseViewModel {
  OrderingInformationViewModel(BuildContext context);

  final storage = const FlutterSecureStorage();

  /// first request
  List<BasisOfEducation> receivedBasicList = [];
  BasisOfEducation? selectedBasic;

  /// second request
  List<PeriodListModel> periodList = [];
  PeriodListModel? selectedPeriod;
  PeriodListModel lastParagraph = PeriodListModel();
  DateTime? startDate = DateTime(0, 0, 0);
  DateTime? endDate = DateTime(0, 0, 0);

  /// third request
  List<ReitList> reitList = [];

  /// four request
  List<ReitItemList> reitItemList = [];

  int selectedIndex = 2;
  bool isSelected = false;

  void onTapBottomBar(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Future onReady() async {
    await getBasicList();
  }

  getBasicList() async {
    String? token = await storage.read(key: "tokenKey");
    var response =
        await http.get(Uri.parse('${Config.basicList}?accessToken=$token'));
    receivedBasicList = parseBasicList(json.decode(response.body)["basicList"]);
    notifyListeners();
  }

  List<BasisOfEducation> parseBasicList(List response) {
    return response
        .map<BasisOfEducation>((json) => BasisOfEducation.fromJson(json))
        .toList();
  }

  List<PeriodListModel> parsePeriodList(List response) {
    return response
        .map<PeriodListModel>((json) => PeriodListModel.fromJson(json))
        .toList();
  }

  changeBasic(value) async {
    selectedBasic = value;
    String? token = await storage.read(key: "tokenKey");
    var response =
        await http.get(Uri.parse('${Config.periodList}?accessToken=$token'));
    periodList = parsePeriodList(json.decode(response.body)["periodList"]);
    lastParagraph.period =
        "задать произвольный период, за который требуется справка";
    periodList.add(lastParagraph);
    notifyListeners();
  }

  changePeriod(value) async {
    selectedPeriod = value;
    isSelected = true;
    // String? token = await storage.read(key: "tokenKey");
    // var response =
    // await http.get(Uri.parse('${Config.periodList}?accessToken=$token'));
    // periodList = parsePeriodList(json.decode(response.body)["periodList"]);
    notifyListeners();
  }
  //
  // getReitList(startDate, endDate, semester) async {
  //   String? token = await storage.read(key: "tokenKey");
  //   var response = await http.get(Uri.parse(
  //       '${Config.reitList}?studentId=${studyCard
  //           ?.id}&studYearStart=$startDate&studYearEnd=$endDate&semester=$semester&accessToken=$token'));
  //   reitList = parseReitList(json.decode(response.body)["reitList"]);
  //   notifyListeners();
  // }
  //
  // getReitItemList(studyId) async {
  //   String? token = await storage.read(key: "tokenKey");
  //   var response = await http.get(Uri.parse(
  //       '${Config.reitItemList}?studyId=$studyId&accessToken=$token'));
  //   reitItemList =
  //       parseReitItemList(json.decode(response.body)["brsActivityList"]);
  //   notifyListeners();
  // }
}
