import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:uuid/uuid.dart';
import '../../../Configurations/config.dart';

class EditViewModel extends BaseViewModel {
  EditViewModel(BuildContext context);
  final storage = const FlutterSecureStorage();
  TextEditingController? emailController = TextEditingController();
  TextEditingController? phoneController = TextEditingController();

  bool circle = true;
  String password = '';
  String avatarUrl = '';
  File? file;

  Future onReady() async {
    await _getUserImage();
    await _getUserData();
    circle = false;
    notifyListeners();
  }

  Future<void> _getUserImage() async {
    final Dio dio = Dio();
    String? token = await storage.read(key: "tokenKey");
    final imageResponse = await dio.get(Config.userInfo, queryParameters: {"accessToken": token});
    if (imageResponse.data['success'] == true) {
      var imageUrl = imageResponse.data['userInfo']['PHOTO_URL'];
      final String fileName = '${const Uuid().v1()}.jpg';
      try {
        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String appDocPath = appDocDir.path;
        if (imageUrl != null) {
          final Response response = await dio.get(imageUrl, queryParameters: {"accessToken": token}, options: Options(responseType: ResponseType.bytes));
          file = File('$appDocPath/$fileName');
          await file?.writeAsBytes(response.data);
        } else {
          file = null;
        }
        notifyListeners();
      } catch (e) {
        rethrow;
      }
    }
  }

  Future<dynamic> _getUserData() async {
    final Dio dio = Dio();
    final responseAuth = await dio.post(Config.apiHost, data: {"login": await storage.read(key: "login") ?? '', "password": await storage.read(key: "password") ?? ''});
    var userData = responseAuth.data['userInfo'];
    emailController?.text = userData["email"] ?? '';
    phoneController?.text = userData["phone"] ?? '';
  }

  Future<void> updateEmail(newEmail) async {
    final Dio dio = Dio();
    String? token = await storage.read(key: "tokenKey");
    await dio.post(Config.updateEmail, queryParameters: {"accessToken": token}, data: {"email": emailController?.text});
  }

  Future<void> updatePhoneNumber(newPhoneNumber) async {
    final Dio dio = Dio();
    String? token = await storage.read(key: "tokenKey");
    await dio.post(Config.updatePhone, queryParameters: {"accessToken": token}, data: {"phone": phoneController?.text});
  }
}
