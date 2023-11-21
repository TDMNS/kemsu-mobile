part of 'auditor_schedule_bloc.dart';

class AuditorScheduleState extends Equatable {
  final AuditorList? auditorList;
  final AuditorSchedule? auditorSchedule;
  final CurrentDayModel? currentDayData;
  final WeekType weekType;
  final UserType userType;
  final bool isLoading;
  final String searchQuery;
  final AuditorListElement? selectedAuditor;
  final bool isSelected;

  AuditorList get requireAuditorList => auditorList!;

  List<AuditorListElement> get searchResult => requireAuditorList.auditorList.where((element) => element.auditoryName.toLowerCase().contains(searchQuery.toLowerCase())).toList();

  const AuditorScheduleState({
    this.auditorList,
    this.auditorSchedule,
    this.currentDayData,
    this.weekType = WeekType.even,
    this.isLoading = true,
    this.searchQuery = '',
    this.selectedAuditor,
    this.isSelected = false,
    this.userType = UserType.student,
  });

  AuditorScheduleState copyWith({
    AuditorList? auditorList,
    WeekType? weekType,
    CurrentDayModel? currentDayData,
    bool? isLoading,
    String? searchQuery,
    AuditorListElement? selectedAuditor,
    AuditorSchedule? auditorSchedule,
    bool? isSelected,
    UserType? userType,
  }) {
    return AuditorScheduleState(
      auditorList: auditorList ?? this.auditorList,
      weekType: weekType ?? this.weekType,
      currentDayData: currentDayData ?? this.currentDayData,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedAuditor: selectedAuditor ?? this.selectedAuditor,
      auditorSchedule: auditorSchedule ?? this.auditorSchedule,
      isSelected: isSelected ?? this.isSelected,
      userType: userType ?? this.userType,
    );
  }

  @override
  List<Object?> get props => [auditorList, weekType, isLoading, searchQuery, selectedAuditor, auditorSchedule, isSelected, currentDayData, userType];
}
