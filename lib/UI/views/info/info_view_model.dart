import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';
import '../../../Configurations/config.dart';
import '../../../domain/dio_interceptor/dio_client.dart';
import '../info/info_model.dart';

class InfoOUProViewModel extends BaseViewModel {
  InfoOUProViewModel(BuildContext context);

  final DioClient dio = DioClient(Dio());
  final storage = const FlutterSecureStorage();

  List<CourseInfoOUPro> course = [];
  List<ReportInfoOUPro> report = [];
  List<TaskListInfoOUPro> task = [];

  int selectedIndex = 2;
  bool isChecked = false;

  List<CourseInfoOUPro> parseCourseList(List response) {
    return response.map<CourseInfoOUPro>((json) => CourseInfoOUPro.fromJson(json)).toList();
  }

  List<ReportInfoOUPro> parseReportList(List response) {
    return response.map<ReportInfoOUPro>((json) => ReportInfoOUPro.fromJson(json)).toList();
  }

  Future onReady() async {
    await getDiscs(0);
    appMetricaTest();
  }

  void appMetricaTest() {
    AppMetrica.activate(const AppMetricaConfig("21985624-7a51-4a70-8a98-83b918e490d8"));
    AppMetrica.reportEvent('InfoOUPro event');
  }

  Future<void> getDiscs(int allFlag) async {
    String? token = await storage.read(key: "tokenKey");
    final response = await dio.get(
      Config.studCourseList,
      queryParameters: {'allCourseFlag': allFlag},
      options: Options(headers: {'x-access-token': token!}),
    );

    course = parseCourseList(response.data['studentCourseList']);
    notifyListeners();
  }

  Future<void> getDiscReports(int? courseId) async {
    String? token = await storage.read(key: "tokenKey");
    final response = await dio.get(
      '${Config.studRepList}/$courseId',
      options: Options(headers: {'x-access-token': token!}),
    );

    report = parseReportList(response.data['studentReportList']);
    notifyListeners();
  }
}
