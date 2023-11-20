part of 'teacher_schedule_bloc.dart';

class TeacherScheduleState extends Equatable {
  final ScheduleTeacherModel? teacherList;
  final TeacherScheduleModel? teacherSchedule;
  final CurrentDayModel? currentDayData;

  final WeekType weekType;
  final bool isLoading;
  final String searchQuery;
  final TeacherList? selectedTeacher;
  final bool isSelected;

  ScheduleTeacherModel get requireTeacherList => teacherList!;

  List<TeacherList> get searchResult => requireTeacherList.teacherList.where((element) => element.fio.toLowerCase().contains(searchQuery.toLowerCase())).toList();

  const TeacherScheduleState({
    this.teacherList,
    this.teacherSchedule,
    this.currentDayData,
    this.weekType = WeekType.even,
    this.isLoading = true,
    this.searchQuery = '',
    this.selectedTeacher,
    this.isSelected = false,
  });

  TeacherScheduleState copyWith({
    ScheduleTeacherModel? teacherList,
    WeekType? weekType,
    CurrentDayModel? currentDayData,
    bool? isLoading,
    String? searchQuery,
    TeacherList? selectedTeacher,
    TeacherScheduleModel? teacherSchedule,
    bool? isSelected,
  }) {
    return TeacherScheduleState(
      teacherList: teacherList ?? this.teacherList,
      weekType: weekType ?? this.weekType,
      currentDayData: currentDayData ?? this.currentDayData,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedTeacher: selectedTeacher ?? this.selectedTeacher,
      teacherSchedule: teacherSchedule ?? this.teacherSchedule,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [
        teacherList,
        weekType,
        isLoading,
        searchQuery,
        selectedTeacher,
        teacherSchedule,
        isSelected,
        currentDayData,
      ];
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
