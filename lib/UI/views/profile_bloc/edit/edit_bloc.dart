import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kemsu_app/Configurations/lce.dart';
import 'package:kemsu_app/Configurations/localizable.dart';
import 'package:kemsu_app/Configurations/navigation.dart';
import 'package:kemsu_app/UI/splash_screen.dart';
import 'package:kemsu_app/domain/models/authorization/auth_model.dart';
import 'package:kemsu_app/domain/repositories/authorization/abstract_auth_repository.dart';

part 'edit_events.dart';
part 'edit_state.dart';

class EditBloc extends Bloc<EditEvent, EditState> {
  EditBloc(super.initialState, {required this.authRepository}) {
    on<OnInit>(_onInit);
    on<TwoFactorAuthSwitch>(_onTwoFactorSwitch);
    on<ChangePassword>(_onChangePassword);
    on<ChangeEmail>(_onChangeEmail);
    on<EnableTwoFactorAuth>(_enableTwoFactorAuth);
    on<ConfirmTwoFactorAuth>(_confirmTwoFactorAuth);
  }

  final AbstractAuthRepository authRepository;

  Future<void> _onInit(OnInit event, Emitter<EditState> emit) async {
    var userInfo = authRepository.userInfo.value;
    var userAvatar = authRepository.userAvatar.value;
    var twoFactorAuth = authRepository.userInfo.value.content?.twoFactorAuth;
    var twoFactorAuthConfirmed = authRepository.userInfo.value.content?.twoFactorAuthConfirmed;
    emit(state.copyWith(userInfo: userInfo, twoFactorAuth: twoFactorAuth, twoFactorAuthConfirmed: twoFactorAuthConfirmed, avatar: userAvatar));
  }

  Future<void> _onTwoFactorSwitch(TwoFactorAuthSwitch event, Emitter<EditState> emit) async {
    emit(state.copyWith(twoFactorAuth: event.twoFactorValue));
  }

  Future<void> _onChangePassword(ChangePassword event, Emitter<EditState> emit) async {
    if (event.oldPassword.isEmpty && event.newPassword.isEmpty && event.newRepPassword.isEmpty) {
      emit(state.copyWith(error: ErrorType.emptyFields));
    } else if (event.newPassword != event.newRepPassword) {
      emit(state.copyWith(error: ErrorType.comparePass));
    } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(event.newPassword) || event.newPassword.length < 8) {
      emit(state.copyWith(error: ErrorType.passRequirements));
    } else {
      try {
        var result = await authRepository.changePassword(oldPassword: event.oldPassword, newPassword: event.newPassword);
        emit(state.copyWith(isSuccess: result));
        Timer(const Duration(seconds: 1), () => AppRouting.back());
      } catch (e) {
        emit(state.copyWith(error: ErrorType.rejectOldPass));
      }
      emit(state.copyWith(error: ErrorType.noError));
    }
  }

  Future<void> _onChangeEmail(ChangeEmail event, Emitter<EditState> emit) async {
    try {
      var result = await authRepository.changeEmail(email: event.email, password: event.password);
      emit(state.copyWith(isSuccess: result));
      Timer(const Duration(seconds: 1), () => AppRouting.back());
    } on DioException catch (e) {
      emit(state.copyWith(error: ErrorType.noError));
    }
  }

  Future<void> _enableTwoFactorAuth(EnableTwoFactorAuth event, Emitter<EditState> emit) async {
    try {
      await authRepository.enableTwoFactorAuth();
    } on DioException catch (e) {
      print('Error:: ${e.response}');
    }
  }

  Future<void> _confirmTwoFactorAuth(ConfirmTwoFactorAuth event, Emitter<EditState> emit) async {
    try {
      await authRepository.confirmTwoFactorAuth(code: event.code);
      Timer(const Duration(seconds: 1), () => AppRouting.back());
      add(TwoFactorAuthSwitch(twoFactorValue: !state.twoFactorAuthConfirmed));
    } on DioException catch (e) {
      print('Error:: ${e.response}');
    }
  }
}
