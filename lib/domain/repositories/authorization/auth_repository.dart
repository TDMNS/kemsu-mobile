import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/Configurations/lce.dart';
import 'package:kemsu_app/domain/models/authorization/auth_model.dart';
import 'package:kemsu_app/domain/models/profile/stud_card_model.dart';
import 'package:kemsu_app/domain/repositories/authorization/abstract_auth_repository.dart';

import '../../../Configurations/config.dart';

class AuthRepository implements AbstractAuthRepository {
  AuthRepository({required this.dio});

  final Dio dio;
  static const storage = FlutterSecureStorage();

  @override
  final ValueNotifier<Lce<AuthModel>> userData = ValueNotifier(const Lce.idle());

  @override
  final ValueNotifier<Lce<StudCardModel>> studCard = ValueNotifier(const Lce.idle());

  @override
  Future<AuthModel> postAuth({required String login, required String password}) async {
    final authResponse = await dio.post(Config.apiHost, data: {"login": login, "password": password});
    final authData = authResponse.data as Map<String, dynamic>;
    final authModel = AuthModel.fromJson(authData);
    userData.value = authModel.asContent;
    return authModel;
  }

  @override
  Future<StudCardModel> getStudCardData() async {
    String? token = await storage.read(key: "tokenKey");
    final response = await dio.get(Config.studCardHost, queryParameters: {
      "accessToken": token,
    });
    final studCardData = response.data[0];
    final studCardModel = StudCardModel.fromJson(studCardData);
    studCard.value = studCardModel.asContent;
    return studCardModel;
  }

  @override
  Future<String> getUserAvatar() async {
    String? token = await storage.read(key: "tokenKey");
    final response = await dio.get(Config.userInfo, queryParameters: {
      "accessToken": token,
    });
    final String imageUrl = response.data['userInfo']['PHOTO_URL'] ?? '';
    final String avatar = '$imageUrl?accessToken=$token';
    return imageUrl.isEmpty ? '' : avatar;
  }
}
