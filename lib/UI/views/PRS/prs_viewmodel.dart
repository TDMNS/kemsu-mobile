import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/UI/views/PRS/prs_model.dart';
import 'package:kemsu_app/UI/views/schedule/schedule_model.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import '../../../API/config.dart';
import '../auth/auth_view.dart';

class PRSViewModel extends BaseViewModel {
  PRSViewModel(BuildContext context);
  final storage = const FlutterSecureStorage();
  List<StudentCard> studentCardGet = [];
  int selectedIndex = 2;
  StudentCard? studentCard;

  void onTapBottomBar(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Future onReady() async {
    await getStudCard();
  }

  getStudCard() async {
    String? token = await storage.read(key: "tokenKey");
    var response =
        await http.get(Uri.parse('${Config.studCardHost}?accessToken=$token'));
    studentCardGet = parseCard(json.decode(response.body));
    notifyListeners();
  }

  List<StudentCard> parseCard(List response) {
    return response
        .map<StudentCard>((json) => StudentCard.fromJson(json))
        .toList();
  }

  void changeCard(value) {
    studentCard = value;
    notifyListeners();
  }
}
