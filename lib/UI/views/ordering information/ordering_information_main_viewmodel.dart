import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:kemsu_app/UI/views/PRS/prs_model.dart';
import 'package:kemsu_app/UI/views/ordering%20information/ordering_information_model.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;
import '../../../API/config.dart';

class OrderingInformationMainViewModel extends BaseViewModel {
  OrderingInformationMainViewModel(BuildContext context);

  final storage = const FlutterSecureStorage();

  List<RequestReference> receivedReferences = [];
  RequestReference? references;

  Future onReady() async {
    await getRequestList();
  }

  List<RequestReference> parseReferences(List response) {
    return response.map<RequestReference>((json) =>
        RequestReference.fromJson(json)).toList();
  }

  getRequestList() async {
    String? token = await storage.read(key: "tokenKey");
    var response =
    await http.get(Uri.parse('${Config.requestListReferences}?accessToken=$token'));
    receivedReferences = parseReferences(json.decode(response.body)["requestList"]);
    notifyListeners();
  }
}
