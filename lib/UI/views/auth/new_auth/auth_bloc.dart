import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kemsu_app/domain/repositories/authorization/abstract_auth_repository.dart';

import '../../../../domain/models/authorization/auth_model.dart';

part 'auth_events.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvents, AuthState> {
  AuthBloc(super.initialState, {required this.authRepository}) {
    on<PostAuthEvents>(_postAuth);
  }

  final AbstractAuthRepository authRepository;

  Future<void> _postAuth(PostAuthEvents event, Emitter<AuthState> emit) async {
    try {
      final authData = await authRepository.postAuth(event.login, event.password);
      emit(state.copyWith(authData: authData, isLoading: false));
    } catch (e) {}
  }
}