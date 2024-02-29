part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {}

class ShowAddInfo extends ProfileEvent {
  ShowAddInfo({required this.isShow});

  final bool isShow;

  @override
  List<Object> get props => [isShow];
}

class Logout extends ProfileEvent {
  Logout();

  @override
  List<Object> get props => [];
}

class LoadStudData extends ProfileEvent {
  LoadStudData();

  @override
  List<Object> get props => [];
}
