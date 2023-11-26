part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final AuthModel? authData;
  final bool isLoading;

  const AuthState({
    this.authData,
    this.isLoading = true
  });

  AuthState copyWith({
    AuthModel? authData,
    bool? isLoading,
    TextEditingController? loginController,
    TextEditingController? passwordController,
    FocusNode? loginFocus,
    FocusNode? passwordFocus,
  }) {
    return AuthState(
      authData: authData ?? this.authData,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [authData, isLoading];
}