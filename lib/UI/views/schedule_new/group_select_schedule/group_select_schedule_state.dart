part of 'group_select_schedule_bloc.dart';

class GroupSelectScheduleState extends Equatable {
  final ScheduleModel? scheduleTable;

  final FacultyListModel? facultyList;
  final GroupListModel? groupList;
  final FacultyResult? selectedFaculty;
  final GroupResult? selectedGroup;
  final String searchQuery;
  final WeekType weekType;
  final bool isLoading;
  final bool isFacultySelected;
  final bool isGroupSelected;

  FacultyListModel get requireFacultyList => facultyList!;
  GroupListModel get requireGroupList => groupList!;

  List<FacultyResult> get searchFacultyResult => requireFacultyList.result.where((element) => element.facultyName.toLowerCase().contains(searchQuery.toLowerCase())).toList();
  List<GroupResult> get searchGroupResult => requireGroupList.result.where((element) => element.groupName.toLowerCase().contains(searchQuery.toLowerCase())).toList();

  ScheduleModel get scheduleTableData => scheduleTable!;

  const GroupSelectScheduleState({
    this.scheduleTable,
    this.facultyList,
    this.searchQuery = '',
    this.selectedFaculty,
    this.groupList,
    this.selectedGroup,
    this.weekType = WeekType.even,
    this.isLoading = true,
    this.isFacultySelected = false,
    this.isGroupSelected = false,
  });

  GroupSelectScheduleState copyWith({
    ScheduleModel? scheduleTable,
    FacultyListModel? facultyList,
    WeekType? weekType,
    String? searchQuery,
    FacultyResult? selectedFaculty,
    bool? isLoading,
    bool? isFacultySelected,
    GroupListModel? groupList,
    GroupResult? selectedGroup,
    bool? isGroupSelected,
  }) {
    return GroupSelectScheduleState(
      scheduleTable: scheduleTable ?? this.scheduleTable,
      facultyList: facultyList ?? this.facultyList,
      weekType: weekType ?? this.weekType,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFaculty: selectedFaculty ?? this.selectedFaculty,
      isLoading: isLoading ?? this.isLoading,
      isFacultySelected: isFacultySelected ?? this.isFacultySelected,
      groupList: groupList ?? this.groupList,
      selectedGroup: selectedGroup ?? this.selectedGroup,
      isGroupSelected: isGroupSelected ?? this.isGroupSelected,
    );
  }

  @override
  List<Object?> get props => [scheduleTable, weekType, isLoading, isFacultySelected, facultyList, searchQuery, selectedFaculty, groupList, selectedGroup, isGroupSelected];
}
