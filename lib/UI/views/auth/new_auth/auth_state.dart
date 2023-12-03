part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final AuthModel? authData;
  final bool isLoading;
  final bool isAuthSuccess;
  final int userType;
  final bool isRememberMe;

  const AuthState({
    this.authData,
    this.isLoading = true,
    this.isAuthSuccess = false,
    this.userType = 0,
    this.isRememberMe = false,
  });

  AuthState copyWith({
    AuthModel? authData,
    bool? isLoading,
    bool? isAuthSuccess,
    int? userType,
    bool? isRememberMe,
  }) {
    return AuthState(
      authData: authData ?? this.authData,
      isLoading: isLoading ?? this.isLoading,
      isAuthSuccess: isAuthSuccess ?? this.isAuthSuccess,
      userType: userType ?? this.userType,
      isRememberMe: isRememberMe ?? this.isRememberMe,
    );
  }

  @override
  List<Object?> get props => [authData, isLoading, isAuthSuccess, userType, isRememberMe];
}