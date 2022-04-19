import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';

import '../../../API/config.dart';
import '../iais/iais_view.dart';

class IaisViewModel extends BaseViewModel {
  IaisViewModel(BuildContext context);
  final storage = const FlutterSecureStorage();

  String DISC_NAME = '';
  String DISC_REP = '';
  String DISC_HOURS = '';
  String FIO = '';
  String DISC_FIRST_DATE = '';
  String DISC_LAST_DATE = '';
  String DISC_MARK = '';

  int selectedIndex = 2;

  Future onReady() async {
    String? token = await storage.read(key: "tokenKey");
    var dio = Dio();

    final response = await dio
        .get(Config.studCourceList, options: Options(
      headers: {
        "x-access-token": token,
      },
    ),);

    var courseList = response.data[0];
    DISC_NAME = courseList["DISC_NAME"];
    DISC_REP = courseList["DISC_REP"];
    DISC_HOURS = courseList["DISC_HOURS"];
    FIO = courseList["FIO"];
    DISC_FIRST_DATE = courseList["DISC_FIRST_DATE"];
    DISC_LAST_DATE = courseList["DISC_LAST_DATE"];
    DISC_MARK = courseList["DISC_MARK"];
    //print(response1.data);

    notifyListeners();
  }
}