import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import '../../../../Configurations/config.dart';
import 'package:http/http.dart' as http;

class OrderingInformationNewCertificatesViewModel extends BaseViewModel {
  OrderingInformationNewCertificatesViewModel(BuildContext context);

  TextEditingController companyName = TextEditingController();
  TextEditingController studentName = TextEditingController();
  final storage = const FlutterSecureStorage();

  Future onReady() async {}

  Future<File?> sendCallCertificates(context) async {
    try {
      String? groupTermId = await storage.read(key: 'groupTermId');
      String? token = await storage.read(key: "tokenKey") ?? '';
      String dir = '';

      if (Platform.isAndroid) {
        dir = '/storage/emulated/0/Download';
      } else if (Platform.isIOS) {
        dir = (await getApplicationDocumentsDirectory()).path;
      }

      int callNumber = 1;
      String filename = 'Call #$callNumber.pdf';
      File file;

      while (true) {
        file = File('$dir/$filename');
        if (await file.exists()) {
          callNumber++;
          filename = 'Call #$callNumber.pdf';
        } else {
          break;
        }
      }

      String url = '${Config.refCallPDF}/$groupTermId?employer=${companyName.text}&employeeFio=${studentName.text}';

      var response = await http.get(
        Uri.parse(url),
        headers: {
          "x-access-token": token,
        },
      );

      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        return null;
      }
    } catch (err) {
      return null;
    } finally {
      notifyListeners();
    }
  }
}
