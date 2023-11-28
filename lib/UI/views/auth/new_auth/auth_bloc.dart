import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kemsu_app/domain/repositories/authorization/abstract_auth_repository.dart';

import '../../../../domain/models/authorization/auth_model.dart';
import '../../../menu.dart';
import '../../../splash_screen.dart';
import '../../profile/profile_view_model.dart';

part 'auth_events.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvents, AuthState> {
  AuthBloc(super.initialState, {required this.authRepository}) {
    on<PostAuthEvents>(_postAuth);
  }

  final AbstractAuthRepository authRepository;

  Future<void> _postAuth(PostAuthEvents event, Emitter<AuthState> emit) async {
    print('Test');
    try {
      final authData = await authRepository.postAuth(login: event.login, password: event.password);

      await storage.write(key: "tokenKey", value: authData.accessToken);
      await storage.write(key: "login", value: event.login);
      await storage.write(key: "password", value: event.password);
      await storage.write(key: "userType", value: authData.userInfo.userType);
      await storage.write(key: "FIO", value: "${authData.userInfo.lastName} ${authData.userInfo.firstName} ${authData.userInfo.middleName}");

      emit(state.copyWith(authData: authData, isLoading: false, isAuthSuccess: true, userType: authData.userInfo.userType == EnumUserType.employee ? 1 : 0));
    } catch (e) {}
  }
}
