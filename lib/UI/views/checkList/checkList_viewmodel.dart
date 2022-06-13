import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked.dart';

import 'package:http/http.dart' as http;
import '../../../API/config.dart';
import '../checkList/checkList_model.dart';
import 'dart:convert';

class CheckListViewModel extends BaseViewModel {
  CheckListViewModel(BuildContext context);
  final storage = const FlutterSecureStorage();

  List<CheckList> checkList = [];

  int selectedIndex = 2;

  List<CheckList> parseCheckList(List response) {
    return response
        .map<CheckList>((json) => CheckList.fromJson(json))
        .toList();
  }

  Future onReady() async {
    String? token = await storage.read(key: "tokenKey");
    var response = await http.get(Uri.parse(
        '${Config.studCheckList}'), headers: {"x-access-token": token!,},);
    print(json.decode(response.body)['checkList']);
    checkList =
        parseCheckList(json.decode(response.body)['checkList']);
    //print(checkList);

    notifyListeners();
  }
}