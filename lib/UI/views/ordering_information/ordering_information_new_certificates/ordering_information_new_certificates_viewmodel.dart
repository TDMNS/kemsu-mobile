import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:http/http.dart' as http;

import '../../../../Configurations/config.dart';
import '../ordering_information_main/ordering_information_main_viewmodel.dart';
import '../ordering_information_model.dart';

class OrderingInformationNewCertificatesViewModel extends BaseViewModel {
  OrderingInformationNewCertificatesViewModel(BuildContext context);
  TextEditingController companyName = TextEditingController();
  TextEditingController studentName = TextEditingController();
  final storage = const FlutterSecureStorage();

  Future onReady() async {}

  sendCallCertificates(context) async {
    String? groupTermId = await storage.read(key: 'groupTermId');
    Dio dio = Dio();
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    String? token = await storage.read(key: "tokenKey");
    // final response = await http.get(
    //     Uri.parse('${Config.refCallPDF}/$groupTermId?employer=${companyName.text}&employeeFio=${studentName.text}'),
    //     headers: {'x-access-token': token!});
    final downloadPDF = await dio.download(
      '${Config.refCallPDF}/$groupTermId?employer=${companyName.text}&employeeFio=${studentName.text}',
      '/storage/emulated/0/Download/help_call.pdf',
      options: Options(
        headers: {'x-access-token': token},
        method: 'GET',
      ),
    );
    print('${Config.refCallPDF}/$groupTermId?employer=${companyName.text}&employeeFio=${studentName.text}');
    // print(response.body);
    notifyListeners();
  }
}
