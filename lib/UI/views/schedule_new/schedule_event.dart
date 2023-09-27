part of 'schedule_bloc.dart';

abstract class ScheduleEvent extends Equatable {}

class CurrentGroupLoadedEvent extends ScheduleEvent {
  CurrentGroupLoadedEvent();
  @override
  List<Object?> get props => [];
}

class ChangeWeekType extends ScheduleEvent {
  ChangeWeekType({required this.weekType});

  final WeekType weekType;

  @override
  List<Object> get props => [weekType];
}
