part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final AuthModel? authData;
  final bool isAuthSuccess;
  final int userType;
  final bool isRememberMe;
  final String login;
  final String password;
  final bool isObscure;
  final bool isTwoFactorEnter;

  const AuthState({
    this.authData,
    this.isAuthSuccess = false,
    this.userType = 0,
    this.isRememberMe = false,
    this.login = '',
    this.password = '',
    this.isObscure = true,
    this.isTwoFactorEnter = false,
  });

  AuthState copyWith({
    AuthModel? authData,
    bool? isAuthSuccess,
    int? userType,
    bool? isRememberMe,
    String? login,
    String? password,
    bool? isObscure,
    bool? isTwoFactorEnter,
  }) {
    return AuthState(
      authData: authData ?? this.authData,
      isAuthSuccess: isAuthSuccess ?? this.isAuthSuccess,
      userType: userType ?? this.userType,
      isRememberMe: isRememberMe ?? this.isRememberMe,
      login: login ?? this.login,
      password: password ?? this.password,
      isObscure: isObscure ?? this.isObscure,
      isTwoFactorEnter: isTwoFactorEnter ?? this.isTwoFactorEnter,
    );
  }

  @override
  List<Object?> get props => [authData, isAuthSuccess, userType, isRememberMe, login, password, isObscure, isTwoFactorEnter];
}
