import 'dart:convert';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/UI/views/ordering_information/ordering_information_model.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import '../../../../Configurations/config.dart';

class OrderingInformationMainViewModel extends BaseViewModel {
  OrderingInformationMainViewModel(BuildContext context);

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

  getRequestList() async {
    String? token = await storage.read(key: "tokenKey");
    var response = await http.get(Uri.parse('${Config.requestListReferences}?accessToken=$token'));
    receivedReferences = parseReferences(json.decode(response.body)["requestList"]);
    notifyListeners();
  }

  getCallCertificates() async {
    String? token = await storage.read(key: "tokenKey");
    var response = await http.get(Uri.parse('${Config.callCertificate}?accessToken=$token'));
    receivedCallCertificate = parseCertificates(json.decode(response.body)["groupTermList"]);
    await storage.write(key: 'groupTermId', value: "${receivedCallCertificate[0].groupTermId}");
    notifyListeners();
  }
}
