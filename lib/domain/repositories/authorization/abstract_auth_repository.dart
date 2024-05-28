import 'package:flutter/foundation.dart';
import 'package:kemsu_app/Configurations/lce.dart';
import 'package:kemsu_app/domain/models/authorization/auth_model.dart';
import 'package:kemsu_app/domain/models/profile/emp_card_model.dart';
import 'package:kemsu_app/domain/models/profile/stud_card_model.dart';

abstract class AbstractAuthRepository {
  Future<AuthModel> postAuth({required String login, required String password});

  Future<AuthModel> authByCode({required String login, required String code});

  Future<UserInfo> getUserInfo();

  Future<StudCardModel> getStudCardData();

  Future<EmpCardModel> getEmpCardData();

  Future<String> getUserAvatar();

  Future<int> checkUpdate({required String version});

  Future<bool> changeEmail({required String email, required String password});

  Future<bool> changePassword({required String oldPassword, required String newPassword});

  Future<void> enableTwoFactorAuth();

  Future<void> confirmTwoFactorAuth({required String code});

  ValueListenable<Lce<AuthModel>> get userData;

  ValueListenable<Lce<UserInfo>> get userInfo;

  ValueListenable<Lce<StudCardModel>> get studCard;

  ValueListenable<Lce<EmpCardModel>> get empCard;

  ValueListenable<String> get userAvatar;
}
