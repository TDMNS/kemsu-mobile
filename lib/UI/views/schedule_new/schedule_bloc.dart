import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kemsu_app/domain/models/schedule/current_group_model.dart';
import 'package:kemsu_app/domain/models/schedule/schedule_teacher_model.dart';
import 'package:kemsu_app/domain/repositories/schedule/abstract_schedule_repository.dart';

import '../../../domain/models/schedule/schedule_model.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc(super.initialState, {required this.scheduleRepository}) {
    on<CurrentGroupLoadedEvent>(_currentGroupLoad);
    on<ChangeWeekType>(_changeWeekType);
    on<GetTeacherList>(_getTeacherList);
    on<TeacherSearch>(_onTeacherSearch);
  }

  final AbstractScheduleRepository scheduleRepository;

  Future<void> _currentGroupLoad(CurrentGroupLoadedEvent event, Emitter<ScheduleState> emit) async {
    try {
      final currentGroup = await scheduleRepository.getCurrentGroup();
      final scheduleTable = await scheduleRepository.getSchedule(currentGroup: currentGroup);
      emit(state.copyWith(scheduleTable: scheduleTable, currentGroupData: currentGroup, isLoading: false));
    } catch (e) {}
  }

  Future<void> _changeWeekType(ChangeWeekType event, Emitter<ScheduleState> emit) async {
    try {
      emit(state.copyWith(weekType: event.weekType));
    } catch (e) {}
  }

  Future<void> _onTeacherSearch(TeacherSearch event, Emitter<ScheduleState> emit) async {
    emit(state.copyWith(isTeacherSearching: event.isTeacherSearching, isLoading: true));
  }

  Future<void> _getTeacherList(GetTeacherList event, Emitter<ScheduleState> emit) async {
    final teacherList = await scheduleRepository.getTeacherList(currentGroup: state.currentGroupData!);
    emit(state.copyWith(teacherList: teacherList, isLoading: false));
  }

  Future<void> _teacherChoice(TeacherChoice event, Emitter<ScheduleState> emit) async {}
}
