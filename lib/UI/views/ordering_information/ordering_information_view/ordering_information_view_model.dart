import 'dart:convert';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:kemsu_app/UI/views/rating_of_students/ros_model.dart';
import 'package:kemsu_app/UI/views/ordering_information/ordering_information_model.dart';
import 'package:stacked/stacked.dart';
import '../../../../Configurations/config.dart';
import '../../../../domain/dio_wrapper/dio_client.dart';

class OrderingInformationViewModel extends BaseViewModel {
  OrderingInformationViewModel(BuildContext context);

  final DioClient dio = DioClient(Dio());
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
  TextEditingController count = TextEditingController();

  List<RequestReference> receivedReferences = [];
  RequestReference? references;

  int selectedIndex = 2;
  bool isSelected = false;

  void onTapBottomBar(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Future onReady() async {
    await getStudCard();
    await getBasicList();
    appMetricaTest();
  }

  void appMetricaTest() {
    AppMetrica.activate(const AppMetricaConfig("21985624-7a51-4a70-8a98-83b918e490d8"));
    AppMetrica.reportEvent('Ordering info event');
  }

  List<StudyCard> parseCard(List response) {
    return response.map<StudyCard>((json) => StudyCard.fromJson(json)).toList();
  }

  List<BasisOfEducation> parseBasicList(List response) {
    return response.map<BasisOfEducation>((json) => BasisOfEducation.fromJson(json)).toList();
  }

  List<PeriodList> parsePeriodList(List response) {
    return response.map<PeriodList>((json) => PeriodList.fromJson(json)).toList();
  }

  Future<void> getStudCard() async {
    String? token = await storage.read(key: "tokenKey");
    bool isTestUser = token == 'accessToken';

    if (isTestUser) {
      receivedStudyCard = [
        StudyCard(
          id: 1,
          speciality: 'Test Speciality'
        ),
      ];
    } else {
      final response = await dio.get(
        Config.studCardHost,
        options: Options(headers: {'x-access-token': token}),
      );
      receivedStudyCard = parseCard(response.data);
    }
    notifyListeners();
  }

  Future<void> getBasicList() async {
    String? token = await storage.read(key: "tokenKey");
    bool isTestUser = token == 'accessToken';

    if (isTestUser) {
      receivedBasicList = [
        BasisOfEducation(basic: 'Test Basic 1', basicId: 1, selectedBasic: 0),
        BasisOfEducation(basic: 'Test Basic 2', basicId: 2, selectedBasic: 1),
      ];
    } else {
      final response = await dio.get(
        Config.basicList,
        options: Options(headers: {'x-access-token': token}),
      );
      receivedBasicList = parseBasicList(response.data["basicList"]);
    }
    notifyListeners();
  }

  void changeCard(value) {
    studyCard = value;
    notifyListeners();
  }

  Future<void> changeBasic(value) async {
    selectedPeriod = null;
    selectedBasic = value;
    String? token = await storage.read(key: "tokenKey");
    bool isTestUser = token == 'accessToken';

    if (isTestUser) {
      periodList = [
        PeriodList(periodId: 1, period: "Test Period 1", selectedPeriod: 0),
        PeriodList(periodId: 2, period: "Test Period 2", selectedPeriod: 1),
      ];
    } else {
      final response = await dio.get(
        Config.periodList,
        options: Options(headers: {'x-access-token': token}),
      );
      periodList = parsePeriodList(response.data["periodList"]);
      lastParagraph.period = "задать произвольный период, за который требуется справка";
      periodList.add(lastParagraph);
    }
    notifyListeners();
  }

  void changePeriod(value) {
    selectedPeriod = value;
    isSelected = true;
    notifyListeners();
  }

  List<RequestReference> parseReferences(List response) {
    return response.map<RequestReference>((json) => RequestReference.fromJson(json)).toList();
  }

  Future<void> sendReferences() async {
    String? token = await storage.read(key: "tokenKey");
    String? safeToken = token ?? "Error";

    int basicId = selectedBasic?.basicId ?? 0;
    int periodId = selectedPeriod?.periodId ?? -1;

    if (count.text.isEmpty) {
      count.text = "1";
    }

    int numberReferences = int.parse(count.text);
    DateTime safeStartDate = startDate ?? DateTime.now();
    DateTime safeEndDate = endDate ?? DateTime.now();
    String formattedStartDate = DateFormat('dd.MM.yyyy').format(safeStartDate);
    String formattedEndDate = DateFormat('dd.MM.yyyy').format(safeEndDate);
    int studentId = studyCard?.id ?? 0;

    await dio.post(
      Config.addRequest,
      options: Options(
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-access-token': safeToken,
        },
      ),
      data: jsonEncode(<String, dynamic>{
        "basicId": basicId,
        "periodId": periodId,
        "cnt": numberReferences,
        "startPeriodDate": periodId == -1 ? formattedStartDate : null,
        "endPeriodDate": periodId == -1 ? formattedEndDate : null,
        "studentId": studentId
      }),
    );

    getRequestList();
    notifyListeners();
  }

  Future<void> getRequestList() async {
    String? token = await storage.read(key: "tokenKey");
    bool isTestUser = token == 'accessToken';

    if (isTestUser) {
      receivedReferences = [
        RequestReference(
          lastName: "Test",
          firstName: "User",
          patronymic: "Patronymic",
          instituteName: "Test Institute",
          courseNumber: 1,
          educationLevel: "Test Level",
          groupName: "Test Group",
          basic: "Test Basic",
          period: "Test Period",
          countReferences: 1,
          requestDate: "2024-06-15",
        ),
      ];
    } else {
      final response = await dio.get(
        Config.requestListReferences,
        options: Options(headers: {'x-access-token': token}),
      );
      receivedReferences = parseReferences(response.data["requestList"]);
    }
    notifyListeners();
  }
}
