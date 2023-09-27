part of 'schedule_bloc.dart';

class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ScheduleInitial extends ScheduleState {
  @override
  List<Object?> get props => [];
}

class CurrentGroupLoaded extends ScheduleState {
  final ScheduleModel? currentGroup;
  final WeekType weekType;

  const CurrentGroupLoaded({
    this.currentGroup,
    this.weekType = WeekType.even,
  });

  @override
  List<Object?> get props => [currentGroup, weekType];
}

enum WeekType { even, odd }
