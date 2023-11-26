part of 'auth_bloc.dart';

abstract class AuthEvents extends Equatable {}

class PostAuthEvents extends AuthEvents {
  PostAuthEvents(this.login, this.password);

  final String login;
  final String password;

  @override
  List<Object?> get props => [];
}