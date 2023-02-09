import 'dart:async';
import 'dart:convert';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

import 'edit_pgas_request_screen.dart';
import 'model/pgas_detail.dart';

class PgasRequestInfoViewModel extends BaseViewModel {
  PgasRequestInfoViewModel(BuildContext context);

  FlutterSecureStorage storage = const FlutterSecureStorage();
  bool circle = true;
  PgasDetailModel? pgasRequest;

  Future onReady(context) async {
    await fetchDetailPgasRequest(context);
    circle = false;
    appMetricaTest();
    notifyListeners();
  }

  void appMetricaTest() {
    AppMetrica.activate(
        const AppMetricaConfig("21985624-7a51-4a70-8a98-83b918e490d8"));
    AppMetrica.reportEvent('Pgas request info event');
  }

  goToEditPgasRequestScreen(context) {
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const EditPgasRequestScreen()))
        .then((value) async {
      circle = true;
      notifyListeners();
      await onGoBack(context);
    });
  }

  FutureOr onGoBack(context) async {
    await fetchDetailPgasRequest(context);
    circle = false;
    notifyListeners();
  }

  fetchDetailPgasRequest(context) async {
    String? eiosAccessToken = await storage.read(key: "tokenKey");
    String? pgasRequestId = await storage.read(key: "pgas_id");
    Map<String, String> header = {"X-Access-Token": "$eiosAccessToken"};
    Map<String, dynamic> body = {"requestId": pgasRequestId};
    var response = await http.post(
        Uri.parse(
            "https://api-next.kemsu.ru/api/student-depatment/pgas-mobile/getRequestInfo"),
        headers: header,
        body: body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      pgasRequest =
          PgasDetailModel.fromJson(json.decode(response.body)["result"]);
      notifyListeners();
    }
  }

  deletePgasAction(context) async {
    String? eiosAccessToken = await storage.read(key: "tokenKey");
    String? pgasRequestId = await storage.read(key: "pgas_id");
    Map<String, String> header = {"X-Access-Token": "$eiosAccessToken"};
    Map<String, dynamic> body = {"requestId": pgasRequestId};
    var response = await http.post(
        Uri.parse(
            "https://api-next.kemsu.ru/api/student-depatment/pgas-mobile/deleteRequest"),
        headers: header,
        body: body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      Navigator.popUntil(context, ModalRoute.withName("PgasList"));
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Заявка успешно удалена.")));
      notifyListeners();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(json.decode(response.body)["message"])));
    }
  }
}
