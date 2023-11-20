part of 'group_select_schedule_bloc.dart';

abstract class GroupSelectScheduleEvent extends Equatable {}

class GetFacultyList extends GroupSelectScheduleEvent {
  GetFacultyList();

  @override
  List<Object> get props => [];
}

class GroupSearchQuery extends GroupSelectScheduleEvent {
  GroupSearchQuery({required this.searchQuery});

  final String searchQuery;

  @override
  List<Object> get props => [searchQuery];
}

class FacultyChoice extends GroupSelectScheduleEvent {
  FacultyChoice({required this.faculty});

  final FacultyResult faculty;

  @override
  List<Object> get props => [faculty];
}

class GroupChoice extends GroupSelectScheduleEvent {
  GroupChoice({required this.group});

  final GroupResult group;

  @override
  List<Object> get props => [group];
}

// class GroupChoice extends CurrentGroupLoadedEvent {
//   GroupChoice({required this.group});
//
//   final AuditorListElement group;
//
//   @override
//   List<Object> get props => [group];
// }

class ChangeWeekType extends GroupSelectScheduleEvent {
  ChangeWeekType({required this.weekType});

  final WeekType weekType;

  @override
  List<Object> get props => [weekType];
}

class FacultyUnselect extends GroupSelectScheduleEvent {
  FacultyUnselect();

  @override
  List<Object> get props => [];
}
