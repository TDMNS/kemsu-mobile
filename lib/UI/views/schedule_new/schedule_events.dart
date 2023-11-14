part of 'schedule_bloc.dart';

abstract class ScheduleEvent extends Equatable {}

class GetCurrentSchedule extends ScheduleEvent {
  GetCurrentSchedule();
  @override
  List<Object?> get props => [];
}

class ChangeWeekType extends ScheduleEvent {
  ChangeWeekType({required this.weekType});

  final WeekType weekType;

  @override
  List<Object> get props => [weekType];
}
