import 'dart:io' show Platform;
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/UI/views/auth/auth_screen.dart';
import 'package:kemsu_app/UI/views/bug_report/bug_report_model.dart';
import 'package:stacked/stacked.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../../../Configurations/config.dart';
import '../../../domain/dio_wrapper/dio_client.dart';

class BugReportViewModel extends BaseViewModel {
  BugReportViewModel(BuildContext context);

  final DioClient dio = DioClient(Dio());
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  bool circle = true;
  String deviceInfoParam = "";
  List<ReportModel> reportList = [];
  TextEditingController errorMsgController = TextEditingController();

  Future onReady(context) async {
    await fetchReports(context);
    getDeviceInfo();
    appMetricaTest();
    notifyListeners();
    circle = false;
  }

  void appMetricaTest() {
    AppMetrica.activate(const AppMetricaConfig("21985624-7a51-4a70-8a98-83b918e490d8"));
    AppMetrica.reportEvent('BugReport event');
  }

  Future<void> getDeviceInfo() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      var release = androidInfo.version.release;
      var sdkInt = androidInfo.version.sdkInt;
      var model = androidInfo.model;
      deviceInfoParam = "Android $release (SDK $sdkInt), $model";
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      var systemName = iosInfo.systemName;
      var version = iosInfo.systemVersion;
      var name = iosInfo.name;
      var model = iosInfo.model;
      deviceInfoParam = '$systemName $version, $name $model';
    }
  }

  Future<void> sendAction(context) async {
    String? accessToken = await storage.read(key: "tokenKey");
    if (errorMsgController.text.isNotEmpty) {
      notifyListeners();
      Map<String, dynamic> body = {
        "message": errorMsgController.text,
        "deviceInfo": deviceInfoParam
      };

      try {
        final response = await dio.post(
          Config.addReport,
          options: Options(headers: {'x-access-token': accessToken}),
          data: body,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          await fetchReports(context);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Ваше обращение успешно отправлено.")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.data["message"])));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Произошла ошибка при отправке обращения.")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Заполните все поля обращения!")));
    }

    errorMsgController.clear();

    AppMetrica.activate(const AppMetricaConfig("21985624-7a51-4a70-8a98-83b918e490d8"));
    AppMetrica.reportEvent('Send bugreport event');
  }

  Future<void> fetchReports(context) async {
    String? accessToken = await storage.read(key: "tokenKey");

    try {
      final response = await dio.get(
        Config.bugReport,
        options: Options(headers: {'x-access-token': accessToken}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        reportList = parseReports(response.data["result"]);
        notifyListeners();
      } else if (response.statusCode == 401) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthScreen()),
              (Route<dynamic> route) => false,
        );
        await storage.delete(key: "tokenKey");
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Сессия ЭИОС истекла. Пожалуйста, авторизуйтесь повторно")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Произошла ошибка при получении обращений.")));
    }
  }

  List<ReportModel> parseReports(List response) {
    return response.map<ReportModel>((json) => ReportModel.fromJson(json)).toList();
  }
}