part of 'edit_bloc.dart';

enum ErrorType {
  emptyFields('Заполните все поля'),
  rejectOldPass('Старый пароль введен неверно!'),
  comparePass('Пароли не совпадают!'),
  noError('');

  final String errorText;

  const ErrorType(this.errorText);
}

class EditState extends Equatable {
  final Lce<UserInfo> userInfo;
  final String avatar;
  final bool twoFactorAuth;
  final bool twoFactorAuthConfirmed;
  final ErrorType error;

  const EditState({
    this.userInfo = const Lce.loading(),
    this.avatar = '',
    this.twoFactorAuth = false,
    this.twoFactorAuthConfirmed = false,
    this.error = ErrorType.noError,
  });

  EditState copyWith({
    Lce<UserInfo>? userInfo,
    String? avatar,
    bool? twoFactorAuth,
    bool? twoFactorAuthConfirmed,
    ErrorType? error,
  }) {
    return EditState(
      userInfo: userInfo ?? this.userInfo,
      avatar: avatar ?? this.avatar,
      twoFactorAuth: twoFactorAuth ?? this.twoFactorAuth,
      twoFactorAuthConfirmed: twoFactorAuthConfirmed ?? this.twoFactorAuthConfirmed,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [userInfo, twoFactorAuth, twoFactorAuthConfirmed, error, avatar];
}
