import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kemsu_app/UI/views/schedule_new/widgets/schedule_list_pages.dart';
import 'package:kemsu_app/domain/models/schedule/faculty_list_model.dart';
import 'package:kemsu_app/domain/models/schedule/group_list_model.dart';
import 'package:kemsu_app/domain/models/schedule/schedule_model.dart';
import 'package:kemsu_app/domain/repositories/schedule/abstract_schedule_repository.dart';

part 'group_select_schedule_events.dart';
part 'group_select_schedule_state.dart';

class GroupSelectScheduleBloc extends Bloc<GroupSelectScheduleEvent, GroupSelectScheduleState> {
  GroupSelectScheduleBloc(super.initialState, {required this.scheduleRepository}) {
    on<GetFacultyList>(_getFacultyList);
    on<ChangeWeekType>(_changeWeekType);
    on<FacultyUnselect>(_facultyUnselect);
    on<GroupSearchQuery>(_filterFaculty);
    on<FacultyChoice>(_facultyChoice);
    on<GroupChoice>(_groupChoice);
  }

  final AbstractScheduleRepository scheduleRepository;

  Future<void> _getFacultyList(GetFacultyList event, Emitter<GroupSelectScheduleState> emit) async {
    final facultyList = await scheduleRepository.getFacultyList();
    emit(state.copyWith(facultyList: facultyList, isLoading: false));
  }

  Future<void> _changeWeekType(ChangeWeekType event, Emitter<GroupSelectScheduleState> emit) async {
    try {
      emit(state.copyWith(weekType: event.weekType));
    } catch (e) {}
  }

  Future<void> _filterFaculty(GroupSearchQuery event, Emitter<GroupSelectScheduleState> emit) async {
    emit(state.copyWith(searchQuery: event.searchQuery));
  }

  Future<void> _facultyChoice(FacultyChoice event, Emitter<GroupSelectScheduleState> emit) async {
    emit(state.copyWith(selectedFaculty: event.faculty, isLoading: true, isFacultySelected: true));
    final groupList = await scheduleRepository.getGroupList(facultyId: event.faculty.id);
    print('TEST:: $groupList');
    emit(state.copyWith(groupList: groupList, isLoading: false));
  }

  Future<void> _groupChoice(GroupChoice event, Emitter<GroupSelectScheduleState> emit) async {
    emit(state.copyWith(selectedGroup: event.group, isLoading: true, isGroupSelected: true));
    final scheduleTable = await scheduleRepository.getSchedule(groupId: event.group.id);
    emit(state.copyWith(scheduleTable: scheduleTable, isLoading: false));
  }

  Future<void> _facultyUnselect(FacultyUnselect event, Emitter<GroupSelectScheduleState> emit) async {
    emit(state.copyWith(isFacultySelected: false, isGroupSelected: false, searchQuery: ''));
  }
}
