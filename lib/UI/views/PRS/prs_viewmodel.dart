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
  List<StudentCard> studentCard = [];
  int selectedIndex = 2;

  void onTapBottomBar(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  Future onReady() async {
    String? token = await storage.read(key: "tokenKey");
    var dio = Dio();

    final response = await dio.get(
      Config.studCardHost,
      options: Options(
        headers: {
          "x-access-token": token,
        },
      ),
    );

    studentCard = response.data;
    print(response.data);

    notifyListeners();
  }

  StudentCard? card;

  List<StudentCard> parseCard(List response) {
    return response
        .map<StudentCard>((json) => StudentCard.fromJson(json))
        .toList();
  }

  void changeCard(value) async {
    card = value;
    notifyListeners();
    var response = await http.get(Uri.parse('${Config.studCardHost}'));
    print(response);
    notifyListeners();
  }
}
