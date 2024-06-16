import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';
import '../../../Configurations/config.dart';
import '../../../domain/dio_wrapper/dio_client.dart';
import 'check_list_model.dart';

class CheckListViewModel extends BaseViewModel {
  CheckListViewModel(BuildContext context);

  final DioClient dio = DioClient(Dio());
  final storage = const FlutterSecureStorage();

  List<CheckList> checkList = [];
  int selectedIndex = 2;
  bool circle = true;

  dynamic _errorMessage;

  List<CheckList> parseCheckList(List response) {
    return response.map<CheckList>((json) => CheckList.fromJson(json)).toList();
  }

  Future onReady() async {
    String? accessToken = await storage.read(key: "tokenKey");
    bool isTestUser = accessToken == 'accessToken';

    if (isTestUser) {
      checkList = [
        CheckList(
          groupName: "Test Group 1",
          departmentTitle: "Test Department",
          debt: "Нет",
          commentary: "Test Commentary",
          address: "Test Address",
        ),
        CheckList(
          groupName: "Test Group 2",
          departmentTitle: "Test Department 2",
          debt: "Есть",
          commentary: "Test Commentary 2",
          address: "Test Address 2",
        ),
      ];
      appMetricaTest();
      circle = false;
      notifyListeners();
    } else {
      try {
        final response = await dio.get(
          Config.studCheckList,
          options: Options(headers: {'x-access-token': accessToken!}),
        );
        checkList = parseCheckList(response.data['checkList']);
        appMetricaTest();
        circle = false;
        notifyListeners();
      } catch (e) {
        setError("Произошла ошибка при получении списка проверки.");
        circle = false;
        notifyListeners();
      }
    }
  }

  void appMetricaTest() {
    AppMetrica.activate(const AppMetricaConfig("21985624-7a51-4a70-8a98-83b918e490d8"));
    AppMetrica.reportEvent('Workaround event');
  }

  @override
  void setError(dynamic error) {
    _errorMessage = error;
  }

  void showError(BuildContext context) {
    if (_errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_errorMessage.toString())));
      _errorMessage = null;
    }
  }
}
