import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/UI/views/ordering_information/ordering_information_model.dart';
import 'package:kemsu_app/domain/dio_interceptor/dio_client.dart';
import 'package:stacked/stacked.dart';
import '../../../../Configurations/config.dart';

class OrderingInformationMainViewModel extends BaseViewModel {
  OrderingInformationMainViewModel(BuildContext context);

  final DioClient dio = DioClient(Dio());
  bool circle = true;

  final storage = const FlutterSecureStorage();

  int? type;

  List<RequestReference> receivedReferences = [];
  List<CallCertificate> receivedCallCertificate = [];

  List<String> trainingCertificates = [TrainingCertificate.callCertificate, TrainingCertificate.trainingCertificate];
  String? trainingCertificate;

  Future onReady() async {
    String? userTypeTemp = await storage.read(key: "userType");
    userTypeTemp == 'обучающийся' ? type = 0 : type = 1;
    await getRequestList();
    await getCallCertificates();
    circle = false;
    notifyListeners();
    appMetricaTest();
  }

  List<RequestReference> parseReferences(List response) {
    return response.map<RequestReference>((json) => RequestReference.fromJson(json)).toList();
  }

  List<CallCertificate> parseCertificates(List response) {
    return response.map<CallCertificate>((json) => CallCertificate.fromJson(json)).toList();
  }

  void appMetricaTest() {
    AppMetrica.activate(const AppMetricaConfig("21985624-7a51-4a70-8a98-83b918e490d8"));
    AppMetrica.reportEvent('Ordering info main event');
  }

  Future<void> getRequestList() async {
    String? token = await storage.read(key: "tokenKey");
    final response = await dio.get(
      Config.requestListReferences,
      options: Options(headers: {'x-access-token': token}),
    );
    receivedReferences = parseReferences(response.data["requestList"]);
    notifyListeners();
  }

  Future<void> getCallCertificates() async {
    String? token = await storage.read(key: "tokenKey");
    final response = await dio.get(
      Config.callCertificate,
      options: Options(headers: {'x-access-token': token}),
    );
    receivedCallCertificate = parseCertificates(response.data["groupTermList"]);
    if (receivedCallCertificate.isNotEmpty) {
      await storage.write(key: 'groupTermId', value: "${receivedCallCertificate.first.groupTermId}");
    }
    notifyListeners();
  }
}
