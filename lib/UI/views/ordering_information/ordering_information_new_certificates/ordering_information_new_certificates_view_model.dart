import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';

import '../../../../Configurations/config.dart';

class OrderingInformationNewCertificatesViewModel extends BaseViewModel {
  OrderingInformationNewCertificatesViewModel(BuildContext context);
  TextEditingController companyName = TextEditingController();
  TextEditingController studentName = TextEditingController();
  final storage = const FlutterSecureStorage();

  Future onReady() async {}

  sendCallCertificates(context) async {
    String? groupTermId = await storage.read(key: 'groupTermId');
    Dio dio = Dio();
    await getApplicationDocumentsDirectory();
    String? token = await storage.read(key: "tokenKey");
    await dio.download(
      '${Config.refCallPDF}/$groupTermId?employer=${companyName.text}&employeeFio=${studentName.text}',
      '/storage/emulated/0/Download/help_call.pdf',
      options: Options(
        headers: {'x-access-token': token},
        method: 'GET',
      ),
    );
    notifyListeners();
  }
}
