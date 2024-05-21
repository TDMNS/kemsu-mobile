import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';
import '../../../Configurations/config.dart';
import '../../../domain/dio_interceptor/dio_client.dart';
import 'check_list_model.dart';

class CheckListViewModel extends BaseViewModel {
  CheckListViewModel(BuildContext context);

  final DioClient dio = DioClient(Dio());
  final storage = const FlutterSecureStorage();

  List<CheckList> checkList = [];
  int selectedIndex = 2;
  bool circle = true;

  List<CheckList> parseCheckList(List response) {
    return response.map<CheckList>((json) => CheckList.fromJson(json)).toList();
  }

  Future onReady() async {
    String? token = await storage.read(key: "tokenKey");
    final response = await dio.get(
      Config.studCheckList,
      options: Options(headers: {'x-access-token': token!}),
    );
    checkList = parseCheckList(response.data['checkList']);
    appMetricaTest();
    notifyListeners();
    circle = false;
  }

  void appMetricaTest() {
    AppMetrica.activate(
        const AppMetricaConfig("21985624-7a51-4a70-8a98-83b918e490d8"));
    AppMetrica.reportEvent('Workaround event');
  }
}
