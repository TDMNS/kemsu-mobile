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