import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:kemsu_app/Configurations/lce.dart';
import 'package:kemsu_app/domain/models/authorization/auth_model.dart';
import 'package:kemsu_app/domain/models/profile/emp_card_model.dart';
import 'package:kemsu_app/domain/models/profile/stud_card_model.dart';

abstract class AbstractAuthRepository {
  Future<AuthModel> postAuth({required String login, required String password});

  Future<StudCardModel> getStudCardData();

  Future<EmpCardModel> getEmpCardData();

  Future<String> getUserAvatar();

  ValueListenable<Lce<AuthModel>> get userData;

  ValueListenable<Lce<StudCardModel>> get studCard;

  ValueListenable<Lce<EmpCardModel>> get empCard;
}
