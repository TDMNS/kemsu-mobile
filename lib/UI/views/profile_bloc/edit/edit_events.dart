part of 'edit_bloc.dart';

abstract class EditEvent extends Equatable {}

class TwoFactorAuthSwitch extends EditEvent {
  TwoFactorAuthSwitch({required this.twoFactorValue});

  final bool twoFactorValue;

  @override
  List<Object> get props => [twoFactorValue];
}

class ChangePassword extends EditEvent {
  ChangePassword({required this.oldPassword, required this.newPassword, required this.newRepPassword});
  final String oldPassword;
  final String newPassword;
  final String newRepPassword;

  @override
  List<Object> get props => [oldPassword, newPassword, newRepPassword];
}

class ChangeEmail extends EditEvent {
  ChangeEmail({required this.email, required this.password});
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

class OnInit extends EditEvent {
  OnInit();

  @override
  List<Object> get props => [];
}

class EnableTwoFactorAuth extends EditEvent {
  EnableTwoFactorAuth();

  @override
  List<Object> get props => [];
}

class ConfirmTwoFactorAuth extends EditEvent {
  ConfirmTwoFactorAuth({required this.code});
  final String code;

  @override
  List<Object> get props => [code];
}
