part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {}

class ShowAddInfo extends ProfileEvent {
  ShowAddInfo({required this.isShow});

  final bool isShow;

  @override
  List<Object> get props => [isShow];
}

class LoadStudData extends ProfileEvent {
  LoadStudData();

  @override
  List<Object> get props => [];
}

class LoadEmpData extends ProfileEvent {
  LoadEmpData();

  @override
  List<Object> get props => [];
}

class CheckUpdate extends ProfileEvent {
  CheckUpdate();

  @override
  List<Object> get props => [];
}

class OnInit extends ProfileEvent {
  OnInit();

  @override
  List<Object> get props => [];
}
