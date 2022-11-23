import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  List<PeriodListModel> periodList = [];
  PeriodListModel? selectedPeriod;
  PeriodListModel lastParagraph = PeriodListModel();

  DateTime? startDate = DateTime(0, 0, 0);
  DateTime? endDate = DateTime(0, 0, 0);

  List<StudyCard> receivedStudyCard = [];
  StudyCard? studyCard;

  int selectedIndex = 2;
  bool isSelected = false;

  void onTapBottomBar(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Future onReady() async {
    await getStudCard();
    await getBasicList();
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
    notifyListeners();
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
    notifyListeners();
  }

  void sendReferences(countReferences) async {
    isNumeric(string) => num.tryParse(string) != null;

    String? token = await storage.read(key: "tokenKey");
    String? safeToken = token ?? "Error";

    int basicId = selectedBasic?.basicId ?? 0;
    String periodIdString = selectedPeriod?.period?[0] ?? "Error";
    if (!isNumeric(periodIdString)) {
      periodIdString = "-1";
    }
    int periodId = int.parse(periodIdString);
    if (countReferences == "") {
      countReferences = "1";
    }
    int numberReferences = int.parse(countReferences);

    final response = await http.post(Uri.parse(Config.addRequest + '?accessToken=' + safeToken),
        headers: <String, String> {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
            "basicId": basicId,
            "periodId": periodId,
            "cnt": numberReferences,
            "studentId": studyCard?.id
        }));

    // print("basicId = $basicId");
    // print("periodId = $periodId");
    // print("numberReferences = $numberReferences");
    // print("studyCard?.id = ${studyCard?.id}");
    // print("request = $response");
    // print("response.statusCode = ${response.statusCode}");

    if (response.statusCode == 200) {
      // print("References was created");
    } else {
      throw Exception('Failed to create references.');
    }

    notifyListeners();
  }
}
