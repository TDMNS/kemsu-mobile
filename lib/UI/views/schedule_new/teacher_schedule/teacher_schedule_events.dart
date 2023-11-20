part of 'teacher_schedule_bloc.dart';

abstract class TeacherScheduleEvent extends Equatable {}

class ChangeTypeWeek extends TeacherScheduleEvent {
  ChangeTypeWeek({required this.weekType});

  final WeekType weekType;

  @override
  List<Object> get props => [weekType];
}

class GetTeacherList extends TeacherScheduleEvent {
  GetTeacherList();

  @override
  List<Object> get props => [];
}

class TeacherSearchQuery extends TeacherScheduleEvent {
  TeacherSearchQuery({required this.searchQuery});

  final String searchQuery;

  @override
  List<Object> get props => [searchQuery];
}

class TeacherChoice extends TeacherScheduleEvent {
  TeacherChoice({required this.teacher});

  final TeacherList teacher;

  @override
  List<Object> get props => [teacher];
}

class TeacherUnselect extends TeacherScheduleEvent {
  TeacherUnselect();

  @override
  List<Object> get props => [];
}
