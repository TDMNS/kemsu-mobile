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

class ChangePhone extends EditEvent {
  ChangePhone({required this.phone});
  final String phone;

  @override
  List<Object> get props => [phone];
}

class OnInit extends EditEvent {
  OnInit();

  @override
  List<Object> get props => [];
}
