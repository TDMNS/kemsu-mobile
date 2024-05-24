import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/Configurations/lce.dart';
import 'package:kemsu_app/domain/dio_interceptor/dio_client.dart';
import 'package:kemsu_app/domain/models/authorization/auth_model.dart';
import 'package:kemsu_app/domain/models/profile/emp_card_model.dart';
import 'package:kemsu_app/domain/models/profile/stud_card_model.dart';
import 'package:kemsu_app/domain/repositories/authorization/abstract_auth_repository.dart';

import '../../../Configurations/config.dart';

class AuthRepository implements AbstractAuthRepository {
  AuthRepository({required this.dio});

  final DioClient dio;
  static const storage = FlutterSecureStorage();

  @override
  final ValueNotifier<Lce<AuthModel>> userData = ValueNotifier(const Lce.idle());

  @override
  final ValueNotifier<Lce<UserInfo>> userInfo = ValueNotifier(const Lce.idle());

  @override
  final ValueNotifier<Lce<StudCardModel>> studCard = ValueNotifier(const Lce.idle());

  @override
  final ValueNotifier<Lce<EmpCardModel>> empCard = ValueNotifier(const Lce.idle());

  @override
  final ValueNotifier<String> userAvatar = ValueNotifier('');

  @override
  Future<AuthModel> postAuth({required String login, required String password}) async {
    bool testUser = login == 'stud00001' && password == 'cherrypie';
    final authResponse = !testUser
        ? await dio.post(Config.apiHost, data: {
            "login": login,
            "password": password,
            "lifetime": "5m",
          })
        : null;
    final authModel = testUser
        ? const AuthModel(success: true, userInfo: UserInfo.guest(), accessToken: 'accessToken', refreshToken: 'refreshToken')
        : AuthModel.fromJson(authResponse?.data as Map<String, dynamic>);
    userData.value = authModel.asContent;
    await storage.write(key: "tokenKey", value: authModel.accessToken);
    await storage.write(key: "refreshToken", value: authModel.refreshToken);
    return authModel;
  }

  @override
  Future<UserInfo> getUserInfo() async {
    String? token = await storage.read(key: "tokenKey");
    final userResponse = token != 'accessToken' ? await dio.get(Config.userInfoToken, options: Options(headers: {'x-access-token': token})) : null;
    print('USER RESPONSE:: $userResponse');
    final userModel = token == 'accessToken' ? const UserInfo.guest() : UserInfo.fromJson(userResponse!.data as Map<String, dynamic>);
    userInfo.value = userModel.asContent;
    return userModel;
  }

  @override
  Future<StudCardModel> getStudCardData() async {
    String? token = await storage.read(key: "tokenKey");
    final response = await dio.get(Config.studCardHost, options: Options(headers: {'x-access-token': token}));
    final studCardData = response.data[0];
    final studCardModel = StudCardModel.fromJson(studCardData);
    studCard.value = studCardModel.asContent;
    return studCardModel;
  }

  @override
  Future<EmpCardModel> getEmpCardData() async {
    String? token = await storage.read(key: "tokenKey");
    final response = await dio.get(Config.empCardHost, options: Options(headers: {'x-access-token': token}));
    final empCardData = response.data;
    final empCardModel = EmpCardModel.fromJson(empCardData);
    empCard.value = empCardModel.asContent;
    return empCardModel;
  }

  @override
  Future<String> getUserAvatar() async {
    String? token = await storage.read(key: "tokenKey");
    final response = await dio.get(Config.userInfo, options: Options(headers: {'x-access-token': token}));
    final String imageUrl = response.data['userInfo']['PHOTO_URL'] ?? '';
    final String avatar = '$imageUrl?accessToken=$token';
    userAvatar.value = avatar;
    return imageUrl.isEmpty ? '' : avatar;
  }

  @override
  Future<int> checkUpdate({required String version}) async {
    String? token = await storage.read(key: 'tokenKey');
    final response = await dio.post(Config.checkMobileAppVersion, data: {"clientVersion": version}, options: Options(headers: {'x-access-token': token}));
    var result = response.data['versionEqualFlag'];
    return result;
  }

  @override
  Future<bool> changeEmail({required String email, required String password}) async {
    String? token = await storage.read(key: 'tokenKey');
    var data = {
      "email": email,
      "pwd": password,
    };
    final response = await dio.post(Config.updateEmail, data: data, options: Options(headers: {'x-access-token': token}));
    bool result = response.data['success'];
    return result;
  }

  @override
  Future<bool> changePassword({required String oldPassword, required String newPassword}) async {
    String? token = await storage.read(key: 'tokenKey');
    print('FUNC CHANGE:');
    var data = {
      "newPassword": newPassword,
      "oldPassword": oldPassword,
    };
    final response = await dio.post(Config.changePassword, data: data, options: Options(headers: {'x-access-token': token}));
    print('RESPONSE:: $response');
    bool result = response.data['success'];
    print('RESULT:: $result');
    return result;
  }

  @override
  Future<bool> changePhone({required String phone}) async {
    String? token = await storage.read(key: 'tokenKey');
    final response = await dio.post(Config.updatePhone, data: {"phone": phone}, options: Options(headers: {'x-access-token': token}));
    bool result = response.data['success'];
    return result;
  }
}
