part of 'edit_bloc.dart';

class EditState extends Equatable {
  final Lce<AuthModel> userData;
  final bool twoFactorAuth;
  final bool twoFactorAuthConfirmed;
  final String? error;

  const EditState({
    this.userData = const Lce.loading(),
    this.twoFactorAuth = false,
    this.twoFactorAuthConfirmed = false,
    this.error,
  });

  EditState copyWith({
    Lce<AuthModel>? userData,
    bool? twoFactorAuth,
    bool? twoFactorAuthConfirmed,
    String? error,
  }) {
    return EditState(
      userData: userData ?? this.userData,
      twoFactorAuth: twoFactorAuth ?? this.twoFactorAuth,
      twoFactorAuthConfirmed: twoFactorAuthConfirmed ?? this.twoFactorAuthConfirmed,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [userData, twoFactorAuth, twoFactorAuthConfirmed, error];
}
