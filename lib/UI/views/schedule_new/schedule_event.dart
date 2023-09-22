part of 'schedule_bloc.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object> get props => [];
}

class CurrentGroupLoadedEvent extends ScheduleEvent {
  const CurrentGroupLoadedEvent();
  @override
  List<Object> get props => [];
}
