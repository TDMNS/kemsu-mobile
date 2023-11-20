import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kemsu_app/UI/views/schedule_new/widgets/schedule_list_pages.dart';
import 'package:kemsu_app/domain/models/schedule/current_day_model.dart';
import 'package:kemsu_app/domain/models/schedule/schedule_teacher_model.dart';
import 'package:kemsu_app/domain/repositories/schedule/abstract_schedule_repository.dart';

part 'teacher_schedule_state.dart';
part 'teacher_schedule_events.dart';

class TeacherScheduleBloc extends Bloc<TeacherScheduleEvent, TeacherScheduleState> {
  TeacherScheduleBloc(super.initialState, {required this.scheduleRepository}) {
    on<ChangeTypeWeek>(_changeWeekType);
    on<GetTeacherList>(_getTeacherList);
    on<TeacherSearchQuery>(_filterTeacherList);
    on<TeacherChoice>(_teacherChoice);
    on<TeacherUnselect>(_teacherUnselect);
  }

  final AbstractScheduleRepository scheduleRepository;

  Future<void> _changeWeekType(ChangeTypeWeek event, Emitter<TeacherScheduleState> emit) async {
    try {
      emit(state.copyWith(weekType: event.weekType));
    } catch (e) {}
  }

  Future<void> _getTeacherList(GetTeacherList event, Emitter<TeacherScheduleState> emit) async {
    final teacherList = await scheduleRepository.getTeacherList();
    emit(state.copyWith(teacherList: teacherList, isLoading: false));
  }

  Future<void> _filterTeacherList(TeacherSearchQuery event, Emitter<TeacherScheduleState> emit) async {
    emit(state.copyWith(searchQuery: event.searchQuery));
  }

  Future<void> _teacherChoice(TeacherChoice event, Emitter<TeacherScheduleState> emit) async {
    emit(state.copyWith(isLoading: true));
    emit(state.copyWith(selectedTeacher: event.teacher));
    final selectedTeacherSchedule = await scheduleRepository.getTeacherSchedule(prepId: event.teacher.prepId);
    final currentDay = scheduleRepository.currentDayData;

    emit(state.copyWith(
      teacherSchedule: selectedTeacherSchedule,
      currentDayData: currentDay.value,
      weekType: currentDay.value.currentDay?.weekType == 'нечетная' ? WeekType.odd : WeekType.even,
      isLoading: false,
      isSelected: true,
    ));
  }

  Future<void> _teacherUnselect(TeacherUnselect event, Emitter<TeacherScheduleState> emit) async {
    emit(state.copyWith(isSelected: false, searchQuery: ''));
  }
}
