import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:kemsu_app/UI/views/PRS/prs_model.dart';
import 'package:kemsu_app/UI/views/ordering%20information/ordering_information_model.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import '../../../API/config.dart';

class OrderingInformationViewModel extends BaseViewModel {
  OrderingInformationViewModel(BuildContext context);

  final storage = const FlutterSecureStorage();

  List<BasisOfEducation> receivedBasicList = [];
  BasisOfEducation? selectedBasic;

  List<PeriodList> periodList = [];
  PeriodList? selectedPeriod;
  PeriodList lastParagraph = PeriodList();

  DateTime? startDate = DateTime(0, 0, 0);
  DateTime? endDate = DateTime(0, 0, 0);

  List<StudyCard> receivedStudyCard = [];
  StudyCard? studyCard;

  int selectedIndex = 2;
  bool isSelected = false;

  List<RequestReference> receivedReferences = [];
  RequestReference? references;

  void onTapBottomBar(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Future onReady() async {
    await getStudCard();
    await getBasicList();
    await getRequestList();
  }

  List<StudyCard> parseCard(List response) {
    return response.map<StudyCard>((json) => StudyCard.fromJson(json)).toList();
  }

  List<RequestReference> parseReferences(List response) {
    return response.map<RequestReference>((json) => RequestReference.fromJson(json)).toList();
  }

  List<BasisOfEducation> parseBasicList(List response) {
    return response
        .map<BasisOfEducation>((json) => BasisOfEducation.fromJson(json))
        .toList();
  }

  List<PeriodList> parsePeriodList(List response) {
    return response
        .map<PeriodList>((json) => PeriodList.fromJson(json))
        .toList();
  }

  getStudCard() async {
    String? token = await storage.read(key: "tokenKey");
    var response =
    await http.get(Uri.parse('${Config.studCardHost}?accessToken=$token'));
    receivedStudyCard = parseCard(json.decode(response.body));
    notifyListeners();
  }

  getBasicList() async {
    String? token = await storage.read(key: "tokenKey");
    var response =
    await http.get(Uri.parse('${Config.basicList}?accessToken=$token'));
    receivedBasicList = parseBasicList(json.decode(response.body)["basicList"]);
    notifyListeners();
  }

  getRequestList() async {
    String? token = await storage.read(key: "tokenKey");
    var response =
    await http.get(Uri.parse('${Config.requestListReferences}?accessToken=$token'));
    receivedReferences = parseReferences(json.decode(response.body)["requestList"]);
    notifyListeners();
  }

  changeCard(value) async {
    studyCard = value;
    notifyListeners();
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
    notifyListeners();
  }

  void sendReferences(countReferences) async {
    String? token = await storage.read(key: "tokenKey");
    String? safeToken = token ?? "Error";

    int basicId = selectedBasic?.basicId ?? 0;
    int periodId = selectedPeriod?.periodId ?? -1;

    if (countReferences == "") {
      countReferences = "1";
    }

    int numberReferences = int.parse(countReferences);
    DateTime safeStartDate = startDate ?? DateTime.now();
    DateTime safeEndDate = endDate ?? DateTime.now();
    String formattedStartDate = DateFormat('dd.MM.yyyy').format(safeStartDate);
    String formattedEndDate = DateFormat('dd.MM.yyyy').format(safeEndDate);
    int studentId = studyCard?.id ?? 0;

    final _ = await http.post(Uri.parse(Config.addRequest + '?accessToken=' + safeToken),
        headers: <String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
            "basicId": basicId,
            "periodId": periodId,
            "cnt": numberReferences,
            "startPeriodDate": periodId == -1 ? formattedStartDate : null,
            "endPeriodDate": periodId == -1 ? formattedEndDate : null,
            "studentId": studentId
        }));

    notifyListeners();
  }
}
