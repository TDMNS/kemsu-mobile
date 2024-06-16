import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';
import '../../../Configurations/config.dart';
import '../../../domain/dio_wrapper/dio_client.dart';
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
    bool isTestUser = token == 'accessToken';

    if (isTestUser) {
      course = [
        CourseInfoOUPro(
          courseId: 1,
          discName: "Test Course 1",
          discRep: "Test Report 1",
          discHours: "30",
          fio: "Test Teacher 1",
          discFirstDate: "2024-01-01",
          discLastDate: "2024-06-01",
          discMark: 5,
        ),
        CourseInfoOUPro(
          courseId: 2,
          discName: "Test Course 2",
          discRep: "Test Report 2",
          discHours: "40",
          fio: "Test Teacher 2",
          discFirstDate: "2024-02-01",
          discLastDate: "2024-07-01",
          discMark: 4,
        ),
      ];
    } else {
      final response = await dio.get(
        Config.studCourseList,
        queryParameters: {'allCourseFlag': allFlag},
        options: Options(headers: {'x-access-token': token!}),
      );
      course = parseCourseList(response.data['studentCourseList']);
    }
    notifyListeners();
  }

  Future<void> getDiscReports(int? courseId) async {
    String? token = await storage.read(key: "tokenKey");
    bool isTestUser = token == 'accessToken';

    if (isTestUser) {
      report = [
        ReportInfoOUPro(
          repId: 1,
          name: "Test Report 1",
          solveFlag: 1,
          comments: "Good work",
          repControlDate: "2024-05-01",
          maxBall: 100,
          sumBall: "95",
          studentTaskList: [
            TaskListInfoOUPro(
              taskId: 1,
              taskName: "Test Task 1",
              solveFlag: "Да",
              comments: "Well done",
              taskControlDate: "2024-04-01",
              maxBall: 50,
              sumBall: "48",
              solutionStatus: "Completed",
              solutionStatusShort: "C",
              optionId: 0,
              optionName: "",
              optionComments: "",
              optionSolutionStatus: "",
            ),
          ],
        ),
        ReportInfoOUPro(
          repId: 2,
          name: "Test Report 2",
          solveFlag: 0,
          comments: "Needs improvement",
          repControlDate: "2024-06-01",
          maxBall: 100,
          sumBall: "70",
          studentTaskList: [
            TaskListInfoOUPro(
              taskId: 2,
              taskName: "Test Task 2",
              solveFlag: "Нет",
              comments: "Incomplete",
              taskControlDate: "2024-05-01",
              maxBall: 50,
              sumBall: "35",
              solutionStatus: "Incomplete",
              solutionStatusShort: "I",
              optionId: 0,
              optionName: "",
              optionComments: "",
              optionSolutionStatus: "",
            ),
          ],
        ),
      ];
    } else {
      final response = await dio.get(
        '${Config.studRepList}/$courseId',
        options: Options(headers: {'x-access-token': token!}),
      );
      report = parseReportList(response.data['studentReportList']);
    }
    notifyListeners();
  }
}
