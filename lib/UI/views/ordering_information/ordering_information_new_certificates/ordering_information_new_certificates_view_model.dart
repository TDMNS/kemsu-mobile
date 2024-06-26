import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import '../../../../Configurations/config.dart';
import '../../../../domain/dio_wrapper/dio_client.dart';

class OrderingInformationNewCertificatesViewModel extends BaseViewModel {
  OrderingInformationNewCertificatesViewModel(BuildContext context);

  final DioClient dio = DioClient(Dio());
  TextEditingController companyName = TextEditingController();
  TextEditingController studentName = TextEditingController();
  final storage = const FlutterSecureStorage();

  Future onReady() async {}

  Future<File?> sendCallCertificates(BuildContext context) async {
    try {
      String? groupTermId = await storage.read(key: 'groupTermId');
      String? token = await storage.read(key: "tokenKey") ?? '';
      bool isTestUser = token == 'accessToken';
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

      if (isTestUser) {
        await file.writeAsString('This is a mock PDF content for testing purposes.');
        return file;
      } else {
        String url = '${Config.refCallPDF}/$groupTermId?employer=${companyName.text}&employeeFio=${studentName.text}';

        final response = await dio.get(
          url,
          options: Options(
            headers: {
              "x-access-token": token,
            },
            responseType: ResponseType.bytes,
          ),
        );

        if (response.statusCode == 200) {
          await file.writeAsBytes(response.data);
          return file;
        } else {
          return null;
        }
      }
    } catch (err) {
      return null;
    } finally {
      notifyListeners();
    }
  }
}
