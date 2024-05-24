import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kemsu_app/Configurations/lce.dart';
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
    on<ChangePhone>(_onChangePhone);
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
    print('TEST::');
    // else if (event.oldPassword != password) {
    // emit(state.copyWith(error: ErrorType.rejectOldPass));
    // }
    if (event.oldPassword.isEmpty && event.newPassword.isEmpty && event.newRepPassword.isEmpty) {
      emit(state.copyWith(error: ErrorType.emptyFields));
    } else if (event.newPassword != event.newRepPassword) {
      emit(state.copyWith(error: ErrorType.comparePass));
    } else {
      try {
        print('WORK?');
        await authRepository.changePassword(oldPassword: event.oldPassword, newPassword: event.newPassword);
      } catch (e) {
        emit(state.copyWith(error: ErrorType.rejectOldPass));
      }
      emit(state.copyWith(error: ErrorType.noError));
    }
  }

  Future<void> _onChangeEmail(ChangeEmail event, Emitter<EditState> emit) async {
    print('TEST EMAIL::');
  }

  Future<void> _onChangePhone(ChangePhone event, Emitter<EditState> emit) async {
    print('TEST PHONE::');
  }
}
