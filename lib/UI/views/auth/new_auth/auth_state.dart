part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final AuthModel? authData;
  final bool isLoading;

  final bool isAuthSuccess;
  final int userType;

  const AuthState({
    this.authData,
    this.isLoading = true,
    this.isAuthSuccess = false,
    this.userType = 0,
  });

  AuthState copyWith({
    AuthModel? authData,
    bool? isLoading,
    bool? isAuthSuccess,
    int? userType,
  }) {
    return AuthState(
      authData: authData ?? this.authData,
      isLoading: isLoading ?? this.isLoading,
      isAuthSuccess: isAuthSuccess ?? this.isAuthSuccess,
      userType: userType ?? this.userType,
    );
  }

  @override
  List<Object?> get props => [authData, isLoading, isAuthSuccess, userType];
}