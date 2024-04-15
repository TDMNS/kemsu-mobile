part of 'schedule_bloc.dart';

class ScheduleState extends Equatable {
  final ScheduleModel? scheduleTable;
  final CurrentGroupModel? currentGroupData;
  final TeacherScheduleModel? teacherSchedule;
  final CurrentDayModel? currentDayData;
  final String userType;
  final WeekType weekType;
  final bool isLoading;
  final bool isClassAvailable;

  const ScheduleState({
    this.scheduleTable,
    this.currentGroupData,
    this.teacherSchedule,
    this.currentDayData,
    this.userType = '',
    this.weekType = WeekType.even,
    this.isLoading = true,
    this.isClassAvailable = true,
  });

  ScheduleModel get scheduleTableData => scheduleTable!;

  ScheduleState copyWith({
    ScheduleModel? scheduleTable,
    CurrentGroupModel? currentGroupData,
    TeacherScheduleModel? teacherSchedule,
    CurrentDayModel? currentDayData,
    String? userType,
    WeekType? weekType,
    bool? isLoading,
    bool? isClassAvailable,
  }) {
    return ScheduleState(
      scheduleTable: scheduleTable ?? this.scheduleTable,
      currentGroupData: currentGroupData ?? this.currentGroupData,
      teacherSchedule: teacherSchedule ?? this.teacherSchedule,
      currentDayData: currentDayData ?? this.currentDayData,
      userType: userType ?? this.userType,
      weekType: weekType ?? this.weekType,
      isLoading: isLoading ?? this.isLoading,
      isClassAvailable: isClassAvailable ?? this.isClassAvailable,
    );
  }

  @override
  List<Object?> get props => [scheduleTable, currentGroupData, weekType, isLoading, isClassAvailable, teacherSchedule, userType, currentDayData];
}
