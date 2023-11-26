import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/domain/models/authorization/auth_model.dart';
import 'package:kemsu_app/domain/repositories/authorization/abstract_auth_repository.dart';

import '../../../Configurations/config.dart';

class AuthRepository implements AbstractAuthRepository {
  AuthRepository({required this.dio});

  final Dio dio;
  static const storage = FlutterSecureStorage();

  @override
  Future<AuthModel> postAuth() async {
    String? login = await storage.read(key: "login");
    String? password = await storage.read(key: "password");

    final authResponse = await dio.post(Config.apiHost, data: {"login": login, "password": password});
    final authData = authResponse.data as Map<String, dynamic>;
    final authModel = AuthModel.fromJson(authData);
    return authModel;
  }

}