part of 'auditor_schedule_bloc.dart';

abstract class AuditorScheduleEvent extends Equatable {}

class ChangeTypeWeek extends AuditorScheduleEvent {
  ChangeTypeWeek({required this.weekType});

  final WeekType weekType;

  @override
  List<Object> get props => [weekType];
}

class GetAuditorList extends AuditorScheduleEvent {
  GetAuditorList();

  @override
  List<Object> get props => [];
}

class AuditorSearchQuery extends AuditorScheduleEvent {
  AuditorSearchQuery({required this.searchQuery});

  final String searchQuery;

  @override
  List<Object> get props => [searchQuery];
}

class AuditorChoice extends AuditorScheduleEvent {
  AuditorChoice({required this.auditor});

  final AuditorListElement auditor;

  @override
  List<Object> get props => [auditor];
}

class AuditorUnselect extends AuditorScheduleEvent {
  AuditorUnselect();

  @override
  List<Object> get props => [];
}
