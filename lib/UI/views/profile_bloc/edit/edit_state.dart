part of 'edit_bloc.dart';

enum ErrorType {
  emptyFields('Заполните все поля'),
  rejectOldPass('Старый пароль введен неверно!'),
  comparePass('Пароли не совпадают!'),
  passRequirements(
      'Пароль должен быть содержать 8 символов, включать только цифры и буквы английского алфавита, и обязательно содержать хотя бы одну цифру, одну строчную и одну заглавную букву.'),
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
  final bool isSuccess;
  final String twoFactorError;

  const EditState({
    this.userInfo = const Lce.loading(),
    this.avatar = '',
    this.twoFactorAuth = false,
    this.twoFactorAuthConfirmed = false,
    this.error = ErrorType.noError,
    this.isSuccess = false,
    this.twoFactorError = '',
  });

  EditState copyWith({
    Lce<UserInfo>? userInfo,
    String? avatar,
    bool? twoFactorAuth,
    bool? twoFactorAuthConfirmed,
    ErrorType? error,
    bool? isSuccess,
    String? twoFactorError,
  }) {
    return EditState(
      userInfo: userInfo ?? this.userInfo,
      avatar: avatar ?? this.avatar,
      twoFactorAuth: twoFactorAuth ?? this.twoFactorAuth,
      twoFactorAuthConfirmed: twoFactorAuthConfirmed ?? this.twoFactorAuthConfirmed,
      error: error ?? this.error,
      isSuccess: isSuccess ?? this.isSuccess,
      twoFactorError: twoFactorError ?? this.twoFactorError,
    );
  }

  @override
  List<Object?> get props => [userInfo, twoFactorAuth, twoFactorAuthConfirmed, error, avatar, isSuccess, twoFactorError];
}
