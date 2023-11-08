part of 'schedule_bloc.dart';

class ScheduleState extends Equatable {
  final ScheduleModel? scheduleTable;
  final CurrentGroupModel? currentGroupData;
  final ScheduleTeacherModel? teacherList;
  final WeekType weekType;
  final bool isLoading;
  final bool isTeacherSearching;

  const ScheduleState({
    this.scheduleTable,
    this.currentGroupData,
    this.teacherList,
    this.weekType = WeekType.even,
    this.isLoading = true,
    this.isTeacherSearching = false,
  });

  ScheduleModel get scheduleTableData => scheduleTable!;

  ScheduleState copyWith({
    ScheduleModel? scheduleTable,
    CurrentGroupModel? currentGroupData,
    ScheduleTeacherModel? teacherList,
    WeekType? weekType,
    bool? isLoading,
    bool? isTeacherSearching,
  }) {
    return ScheduleState(
      scheduleTable: scheduleTable ?? this.scheduleTable,
      currentGroupData: currentGroupData ?? this.currentGroupData,
      teacherList: teacherList ?? this.teacherList,
      weekType: weekType ?? this.weekType,
      isLoading: isLoading ?? this.isLoading,
      isTeacherSearching: isTeacherSearching ?? this.isTeacherSearching,
    );
  }

  @override
  List<Object?> get props => [scheduleTable, currentGroupData, teacherList, weekType, isLoading, isTeacherSearching];
}

// class ScheduleInitial extends ScheduleState {
//   @override
//   List<Object?> get props => [];
// }
//
// class CurrentGroupLoaded extends ScheduleState {
//   final ScheduleModel? currentGroup;
//   final WeekType weekType;
//
//   const CurrentGroupLoaded({
//     this.currentGroup,
//     this.weekType = WeekType.even,
//   });
//
//   @override
//   List<Object?> get props => [currentGroup, weekType];
// }
