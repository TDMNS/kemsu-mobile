part of 'auth_bloc.dart';

abstract class AuthEvents extends Equatable {}

class PostAuthEvents extends AuthEvents {
  PostAuthEvents(this.login, this.password, this.context);

  final String login;
  final String password;
  final BuildContext context;

  @override
  List<Object?> get props => [login, password, context];
}

class ChangeRememberMeEvent extends AuthEvents {
  ChangeRememberMeEvent({required this.isRememberMe});

  final bool? isRememberMe;

  @override
  List<Object?> get props => [isRememberMe];
}

class ChangePasswordObscureEvent extends AuthEvents {
  ChangePasswordObscureEvent({required this.isObscure});

  final bool? isObscure;

  @override
  List<Object?> get props => [isObscure];
}

class UpdateLoginTextFieldEvent extends AuthEvents {
  UpdateLoginTextFieldEvent({required this.login});

  final String? login;

  @override
  List<Object?> get props => [login];
}

class UpdatePasswordTextFieldEvent extends AuthEvents {
  UpdatePasswordTextFieldEvent({required this.password});

  final String? password;

  @override
  List<Object?> get props => [password];
}

class AuthByCode extends AuthEvents {
  AuthByCode({required this.code, required this.login});

  final String login;
  final String code;

  @override
  List<Object?> get props => [code, login];
}

class ProblemsEvent extends AuthEvents {
  ProblemsEvent();

  @override
  List<Object?> get props => [];
}
