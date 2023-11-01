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

class GetTeacherList extends ScheduleEvent {
  GetTeacherList();

  @override
  List<Object> get props => [];
}

class TeacherSearch extends ScheduleEvent {
  TeacherSearch({required this.isTeacherSearching});

  final bool isTeacherSearching;

  @override
  List<Object> get props => [isTeacherSearching];
}

class TeacherChoice extends ScheduleEvent {
  TeacherChoice({required this.teacherID});

  final int teacherID;

  @override
  List<Object> get props => [teacherID];
}
