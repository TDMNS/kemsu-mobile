import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/UI/views/rating_of_students/ros_model.dart';
import 'package:stacked/stacked.dart';
import '../../../Configurations/config.dart';
import '../../../domain/dio_interceptor/dio_client.dart';

class RosViewModel extends BaseViewModel {
  RosViewModel(BuildContext context);

  final DioClient dio = DioClient(Dio());
  final storage = const FlutterSecureStorage();

  bool circle = true;

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
    circle = false;
    appMetricaTest();
  }

  void appMetricaTest() {
    AppMetrica.activate(const AppMetricaConfig("21985624-7a51-4a70-8a98-83b918e490d8"));
    AppMetrica.reportEvent('rating_of_students event');
  }

  Future<void> getStudCard() async {
    print('PRS TEST 1');
    String? token = await storage.read(key: "tokenKey");
    final response = await dio.get(
      Config.studCardHost,
      options: Options(headers: {'x-access-token': token}),
    );
    print('PRS TEST 2:  ${response.data}');
    receivedStudyCard = parseCard(response.data);
    print('PRS TEST 3');
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

  Future<void> changeCard(value) async {
    studyCard = value;
    String? token = await storage.read(key: "tokenKey");
    final response = await dio.get(
      '${Config.brsSemesterList}/${studyCard?.id}',
      options: Options(headers: {'x-access-token': token}),
    );
    rosSemesterList = parseRosSemesterList(response.data["brsSemesterList"]);
    circle = false;
    notifyListeners();
  }

  Future<void> getReitList(startDate, endDate, semester) async {
    String? token = await storage.read(key: "tokenKey");
    final response = await dio.get(
      Config.reitList,
      queryParameters: {
        'studentId': studyCard?.id,
        'studYearStart': startDate,
        'studYearEnd': endDate,
        'semester': semester,
      },
      options: Options(headers: {'x-access-token': token}),
    );
    reitList = parseReitList(response.data["reitList"]);
    notifyListeners();
  }

  Future<void> getReitItemList(studyId) async {
    String? token = await storage.read(key: "tokenKey");
    final response = await dio.get(
      Config.reitItemList,
      queryParameters: {
        'studyId': studyId,
      },
      options: Options(headers: {'x-access-token': token}),
    );
    reitItemList = parseReitItemList(response.data["brsActivityList"]);
    notifyListeners();
  }
}
