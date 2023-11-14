part of 'schedule_bloc.dart';

class ScheduleState extends Equatable {
  final ScheduleModel? scheduleTable;
  final CurrentGroupModel? currentGroupData;
  final TeacherScheduleModel? teacherSchedule;
  final String userType;
  final WeekType weekType;
  final bool isLoading;

  const ScheduleState({
    this.scheduleTable,
    this.currentGroupData,
    this.teacherSchedule,
    this.userType = '',
    this.weekType = WeekType.even,
    this.isLoading = true,
  });

  ScheduleModel get scheduleTableData => scheduleTable!;

  ScheduleState copyWith({
    ScheduleModel? scheduleTable,
    CurrentGroupModel? currentGroupData,
    TeacherScheduleModel? teacherSchedule,
    String? userType,
    WeekType? weekType,
    bool? isLoading,
  }) {
    return ScheduleState(
      scheduleTable: scheduleTable ?? this.scheduleTable,
      currentGroupData: currentGroupData ?? this.currentGroupData,
      teacherSchedule: teacherSchedule ?? this.teacherSchedule,
      userType: userType ?? this.userType,
      weekType: weekType ?? this.weekType,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [scheduleTable, currentGroupData, weekType, isLoading, teacherSchedule, userType];
}
