import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kemsu_app/Configurations/navigation.dart';
import 'package:kemsu_app/domain/repositories/authorization/abstract_auth_repository.dart';

import '../../../../Configurations/localizable.dart';
import '../../../../domain/models/authorization/auth_model.dart';
import '../../../splash_screen.dart';
import '../../profile/profile_view_model.dart';

part 'auth_events.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvents, AuthState> {
  AuthBloc(super.initialState, {required this.authRepository}) {
    on<PostAuthEvents>(_postAuth);
    on<ChangeRememberMeEvent>(_changeRememberMe);
    on<GetUserDataEvent>(_getUserData);
    on<ChangePasswordObscureEvent>(_changePasswordObscure);
    on<UpdateLoginTextFieldEvent>(_updateLoginTextField);
    on<UpdatePasswordTextFieldEvent>(_updatePasswordTextField);
  }

  final AbstractAuthRepository authRepository;

  Future<void> _postAuth(PostAuthEvents event, Emitter<AuthState> emit) async {
    try {
      final authData = await authRepository.postAuth(login: event.login, password: event.password);

      await storage.write(key: "tokenKey", value: authData.accessToken);
      await storage.write(key: "login", value: event.login);
      await storage.write(key: "password", value: event.password);
      await storage.write(key: "userType", value: authData.userInfo.userType);
      await storage.write(key: "FIO", value: "${authData.userInfo.lastName} ${authData.userInfo.firstName} ${authData.userInfo.middleName}");

      emit(state.copyWith(authData: authData, isAuthSuccess: true, userType: authData.userInfo.userType == EnumUserType.employee ? 1 : 0, isLoading: false));

      if (state.isAuthSuccess) {
        AppRouting.toMenu();
      }
    } catch (error) {
      _navigateToAuthAlert(error);
    }
  }

  void _navigateToAuthAlert(Object error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      switch (statusCode) {
        case 400:
          AppRouting.toAlert(Localizable.authError400);
          break;
        case 401:
          AppRouting.toAlert(Localizable.authError401);
          break;
        case 500:
          AppRouting.toAlert(Localizable.authError500);
          break;
        default:
          AppRouting.toAlert(Localizable.authErrorDefault);
          break;
      }
    }
  }

  Future<void> _changeRememberMe(ChangeRememberMeEvent event, Emitter<AuthState> emit) async {
    try {
      final isRememberMe = event.isRememberMe ?? false;
      await storage.write(key: "isRememberMe", value: "$isRememberMe");

      emit(state.copyWith(isRememberMe: isRememberMe));
    } catch (e) {}
  }

  Future<void> _changePasswordObscure(ChangePasswordObscureEvent event, Emitter<AuthState> emit) async {
    try {
      final isObscure = event.isObscure ?? true;
      emit(state.copyWith(isObscure: !isObscure));
    } catch (e) {}
  }

  Future<void> _updateLoginTextField(UpdateLoginTextFieldEvent event, Emitter<AuthState> emit) async {
    try {
      await storage.write(key: "login", value: event.login);
      emit(state.copyWith(login: event.login));
    } catch (e) {}
  }

  Future<void> _updatePasswordTextField(UpdatePasswordTextFieldEvent event, Emitter<AuthState> emit) async {
    try {
      await storage.write(key: "password", value: event.password);
      emit(state.copyWith(password: event.password));
    } catch (e) {}
  }

  Future<void> _getUserData(GetUserDataEvent event, Emitter<AuthState> emit) async {
    try {
      var login = await storage.read(key: "login");
      var password = await storage.read(key: "password");
      final isRememberMe = await storage.read(key: "isRememberMe") == true.toString();

      isRememberMe ? login : login = '';
      isRememberMe ? password : password = '';

      emit(state.copyWith(isRememberMe: isRememberMe, login: login, password: password, isLoading: false));
    } catch (e) {}
  }
}
