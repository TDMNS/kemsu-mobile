part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final AuthModel? authData;
  // final bool isLoading;
  final bool isAuthSuccess;
  final int userType;
  final bool isRememberMe;
  final String login;
  final String password;
  final bool isObscure;

  const AuthState({
    this.authData,
    // this.isLoading = true,
    this.isAuthSuccess = false,
    this.userType = 0,
    this.isRememberMe = false,
    this.login = '',
    this.password = '',
    this.isObscure = true,
  });

  AuthState copyWith({
    AuthModel? authData,
    // bool? isLoading,
    bool? isAuthSuccess,
    int? userType,
    bool? isRememberMe,
    String? login,
    String? password,
    bool? isObscure,
  }) {
    return AuthState(
      authData: authData ?? this.authData,
      // isLoading: isLoading ?? this.isLoading,
      isAuthSuccess: isAuthSuccess ?? this.isAuthSuccess,
      userType: userType ?? this.userType,
      isRememberMe: isRememberMe ?? this.isRememberMe,
      login: login ?? this.login,
      password: password ?? this.password,
      isObscure: isObscure ?? this.isObscure,
    );
  }

  @override
  List<Object?> get props => [authData, isAuthSuccess, userType, isRememberMe, login, password, isObscure];
}