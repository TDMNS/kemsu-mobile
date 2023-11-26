import 'package:kemsu_app/domain/models/authorization/auth_model.dart';

abstract class AbstractAuthRepository {
  Future<AuthModel> postAuth();
}