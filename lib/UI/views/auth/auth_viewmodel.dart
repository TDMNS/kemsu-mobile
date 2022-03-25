import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:stacked/stacked.dart';

import '../../../API/api_provider.dart';
import '../../../API/config.dart';
import '../../../API/network_response.dart';
import '../../../API/routes/auth_route.dart';
import '../../widgets.dart';
import '../profile/profile_view.dart';
import 'auth_view.dart';

class AuthViewModel extends BaseViewModel {
  AuthViewModel(BuildContext context);
  bool isObscure = true;
  final storage = const FlutterSecureStorage();
  final ApiProvider _apiProvider = ApiProvider();

  Future onReady() async {}

  void authButton(context) async {
    print("Auth ready");
    AuthRoute route = AuthRoute(
        login: loginController.text, password: passwordController.text);
    NetworkResponse response = await _apiProvider.request(route);
    await storage.write(key: "tokenKey", value: response.data['accessToken']);
    print(response.data);
    print(response.statusCode);

    if (response.statusCode == 400) {
      errorDialog1(context);
    } else if (response.statusCode == 401) {
      errorDialog2(context);
    } else if (response.statusCode == 200) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ProfileView()));
    }

    notifyListeners();
  }

  void isVisiblePassword() {
    if (isObscure) {
      isObscure = false;
    } else {
      isObscure = true;
    }
    notifyListeners();
  }
}
