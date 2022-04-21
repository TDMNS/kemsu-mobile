import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/UI/views/auth/auth_view.dart';
import 'package:kemsu_app/UI/views/pgas/pgas_detail_screen.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

import 'model/short_pgas_request.dart';
import 'new_pgas_request_screen.dart';

class PgasViewModel extends BaseViewModel {
  PgasViewModel(BuildContext context);

  FlutterSecureStorage storage = const FlutterSecureStorage();
  List<ShortPgasRequestModel> pgasList = [];
  bool circle = true;

  Future onReady(context) async {
    await fetchPgasRequests(context);
  }

  void refreshData(context) async {
    await fetchPgasRequests(context);
  }

  FutureOr onGoBack(context) {
    refreshData(context);
  }

  goToNewPgasRequest(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const NewPgasRequestScreen())).then((value) => onGoBack(context));
  }

  goToPgasDetail(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const PgasDetailScreen())).then((value) => onGoBack(context));
  }

  fetchPgasRequests(context) async {
    String? eiosAccessToken = await storage.read(key: "tokenKey");
    Map<String, String> header = {
      "X-Access-Token": "$eiosAccessToken"
    };
    var response = await http.post(Uri.parse("https://api-next.kemsu.ru/api/student-depatment/pgas-mobile/getRequestList"), headers: header);
    if (response.statusCode == 200 || response.statusCode == 201) {
      pgasList = parsePgasRequests(json.decode(response.body)["result"]);
      circle = false;
      notifyListeners();
    } else if (response.statusCode == 401) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const AuthView()), (Route<dynamic> route) => false);
      await storage.delete(key: "tokenKey");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Сессия ЭИОС истекла. Пожалуйста, авторизуйтесь повторно")));
    }
  }

  List<ShortPgasRequestModel> parsePgasRequests(List response) {
    return response
        .map<ShortPgasRequestModel>((json) => ShortPgasRequestModel.fromJson(json))
        .toList();
  }
}