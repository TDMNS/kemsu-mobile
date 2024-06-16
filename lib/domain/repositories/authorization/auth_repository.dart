import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/Configurations/lce.dart';
import 'package:kemsu_app/domain/models/authorization/auth_model.dart';
import 'package:kemsu_app/domain/models/profile/emp_card_model.dart';
import 'package:kemsu_app/domain/models/profile/stud_card_model.dart';
import 'package:kemsu_app/domain/repositories/authorization/abstract_auth_repository.dart';
import '../../../Configurations/config.dart';
import '../../dio_wrapper/dio_client.dart';

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
        ? await dio.post(
            Config.apiHost,
            data: {
              "login": login,
              "password": password,
              "lifetime": "5m",
            },
          )
        : null;
    print('RESPONSE:: $authResponse');

    final authModel = testUser
        ? const AuthModel(success: true, userInfo: UserInfo.guest(), accessToken: 'accessToken', refreshToken: 'refreshToken')
        : AuthModel.fromJson(authResponse?.data as Map<String, dynamic>);
    userData.value = authModel.asContent;
    await storage.write(key: "tokenKey", value: authModel.accessToken);
    await storage.write(key: "refreshToken", value: authModel.refreshToken);
    return authModel;
  }

  @override
  Future<AuthModel> authByCode({required String login, required String code}) async {
    print('LOGIN:: $login, CODE:: $code');
    final response = await dio.post(
      Config.authByCode,
      data: {
        "login": login,
        "code": code,
        "lifetime": "5m",
      },
    );
    final authModel = AuthModel.fromJson(response.data as Map<String, dynamic>);
    userData.value = authModel.asContent;
    await storage.write(key: "tokenKey", value: authModel.accessToken);
    await storage.write(key: "refreshToken", value: authModel.refreshToken);
    return authModel;
  }

  @override
  Future<UserInfo> getUserInfo() async {
    String? token = await storage.read(key: "tokenKey");
    final userResponse = token != 'accessToken' ? await dio.get(Config.userInfoToken, options: Options(headers: {'x-access-token': token})) : null;
    final userModel = token == 'accessToken' ? const UserInfo.guest() : UserInfo.fromJson(userResponse!.data as Map<String, dynamic>);
    print('USER INFO:: $userResponse');
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
    var data = {
      "newPassword": newPassword,
      "oldPassword": oldPassword,
    };
    final response = await dio.post(Config.changePassword, data: data, options: Options(headers: {'x-access-token': token}));
    bool result = response.data['success'];
    return result;
  }

  @override
  Future<void> enableTwoFactorAuth() async {
    String? token = await storage.read(key: 'tokenKey');
    await dio.post(Config.enableTwoFactorAuth, options: Options(headers: {'x-access-token': token}));
  }

  @override
  Future<void> confirmTwoFactorAuth({required String code}) async {
    String? token = await storage.read(key: 'tokenKey');
    var data = {
      'code': code,
    };
    await dio.post(Config.confirmTwoFactorAuth, data: data, options: Options(headers: {'x-access-token': token}));
  }

  @override
  Future<void> disableTwoFactorAuth() async {
    String? token = await storage.read(key: 'tokenKey');
    await dio.post(Config.disableTwoFactorAuth, options: Options(headers: {'x-access-token': token}));
  }
}
