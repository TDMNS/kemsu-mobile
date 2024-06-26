import 'dart:developer';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kemsu_app/Configurations/lce.dart';
import 'package:kemsu_app/Configurations/localizable.dart';
import 'package:kemsu_app/Configurations/navigation.dart';
import 'package:kemsu_app/UI/splash_screen.dart';
import 'package:kemsu_app/domain/models/authorization/auth_model.dart';
import 'package:kemsu_app/domain/models/profile/emp_card_model.dart';
import 'package:kemsu_app/domain/models/profile/stud_card_model.dart';
import 'package:kemsu_app/domain/repositories/authorization/abstract_auth_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../local_notification_service.dart';
part 'profile_events.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(super.initialState, {required this.authRepository}) {
    on<ShowAddInfo>(_showAddInfo);
    on<LoadStudData>(_loadStudData);
    on<LoadEmpData>(_loadEmpData);
    on<CheckUpdate>(_checkUpdate);
    on<OnInit>(_onInit);
  }

  final AbstractAuthRepository authRepository;

  Future<void> _showAddInfo(ShowAddInfo event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(showAddInfo: event.isShow));
  }

  Future<void> _checkUpdate(CheckUpdate event, Emitter<ProfileState> emit) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var needUpdate = await authRepository.checkUpdate(version: packageInfo.version);
    if (needUpdate == 0) {
      emit(state.copyWith(needUpdate: true));
    }
  }

  Future<void> _onInit(OnInit event, Emitter<ProfileState> emit) async {
    add(CheckUpdate());
    AppMetrica.activate(const AppMetricaConfig("21985624-7a51-4a70-8a98-83b918e490d8"));
    AppMetrica.reportEvent('Main screen (profile) event');

    try {
      await authRepository.getUserInfo();
    } catch (e) {
      log('error: $e');
      storage.delete(key: "tokenKey");
      AppRouting.toNotAuthMenu();
    }
    var userType = authRepository.userInfo.value.requiredContent.userType;
    UserType currentType = UserType.values.firstWhere((element) => element.typeName == userType);
    currentType == UserType.student ? add(LoadStudData()) : add(LoadEmpData());
    await localNotificationService.setup();
  }

  Future<void> _loadStudData(LoadStudData event, Emitter<ProfileState> emit) async {
    var token = await storage.read(key: "tokenKey");
    bool isTestUser = token == 'accessToken';

    if (isTestUser) {
      final userInfo = await authRepository.getUserInfo();
      emit(state.copyWith(userData: userInfo.asContent, studCard: const Lce(isLoading: false), isTestUser: true));
    } else {
      final avatar = await authRepository.getUserAvatar();
      final studCard = await authRepository.getStudCardData();
      final userInfo = await authRepository.getUserInfo();
      emit(state.copyWith(studCard: studCard.asContent, userData: userInfo.asContent, avatar: avatar, isTestUser: false));
    }
  }

  Future<void> _loadEmpData(LoadEmpData event, Emitter<ProfileState> emit) async {
    final avatar = await authRepository.getUserAvatar();
    final empData = await authRepository.getEmpCardData();
    final userInfo = await authRepository.getUserInfo();
    emit(state.copyWith(empCard: empData.asContent, userData: userInfo.asContent, avatar: avatar));
  }
}
