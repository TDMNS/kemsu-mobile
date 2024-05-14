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
  }

  final AbstractAuthRepository authRepository;

  Future<void> _onInit(OnInit event, Emitter<EditState> emit) async {
    var userData = authRepository.userData.value;
    var twoFactorAuth = authRepository.userData.value.requiredContent.userInfo.twoFactorAuth;
    var twoFactorAuthConfirmed = authRepository.userData.value.requiredContent.userInfo.twoFactorAuthConfirmed;
    emit(state.copyWith(userData: userData, twoFactorAuth: twoFactorAuth, twoFactorAuthConfirmed: twoFactorAuthConfirmed));
  }

  Future<void> _onTwoFactorSwitch(TwoFactorAuthSwitch event, Emitter<EditState> emit) async {
    emit(state.copyWith(twoFactorAuth: event.twoFactorValue));
  }

  Future<void> _onChangePassword(ChangePassword event, Emitter<EditState> emit) async {
    print('TEST::');
    var password = await storage.read(key: "password");
    if (event.oldPassword.isEmpty && event.newPassword.isEmpty && event.newRepPassword.isEmpty) {
      emit(state.copyWith(error: 'Заполните все поля'));
    } else if (event.oldPassword != password) {
      emit(state.copyWith(error: 'Старый пароль введен неверно!'));
    } else if (event.newPassword != event.newRepPassword) {
      emit(state.copyWith(error: 'Пароли не совпадают!'));
    } else {
      emit(state.copyWith(error: ''));
    }
  }
}
