import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kemsu_app/UI/views/schedule_new/widgets/schedule_list_pages.dart';
import 'package:kemsu_app/domain/models/schedule/auditor_list_model.dart';
import 'package:kemsu_app/domain/models/schedule/auditor_schedule_model.dart';
import 'package:kemsu_app/domain/models/schedule/current_day_model.dart';
import 'package:kemsu_app/domain/repositories/schedule/abstract_schedule_repository.dart';

part 'auditor_schedule_state.dart';
part 'auditor_schedule_events.dart';

class AuditorScheduleBloc extends Bloc<AuditorScheduleEvent, AuditorScheduleState> {
  AuditorScheduleBloc(super.initialState, {required this.scheduleRepository}) {
    on<ChangeTypeWeek>(_changeWeekType);
    on<GetAuditorList>(_getAuditorList);
    on<AuditorSearchQuery>(_filterTeacherList);
    on<AuditorChoice>(_auditorChoice);
    on<AuditorUnselect>(_teacherUnselect);
  }

  final AbstractScheduleRepository scheduleRepository;

  Future<void> _changeWeekType(ChangeTypeWeek event, Emitter<AuditorScheduleState> emit) async {
    try {
      emit(state.copyWith(weekType: event.weekType));
    } catch (e) {}
  }

  Future<void> _getAuditorList(GetAuditorList event, Emitter<AuditorScheduleState> emit) async {
    final auditorList = await scheduleRepository.getAuditorList();
    emit(state.copyWith(auditorList: auditorList, isLoading: false));
  }

  Future<void> _filterTeacherList(AuditorSearchQuery event, Emitter<AuditorScheduleState> emit) async {
    emit(state.copyWith(searchQuery: event.searchQuery));
  }

  Future<void> _auditorChoice(AuditorChoice event, Emitter<AuditorScheduleState> emit) async {
    emit(state.copyWith(isLoading: true, selectedAuditor: event.auditor));
    final auditorSchedule = await scheduleRepository.getAuditorSchedule(auditoryId: event.auditor.auditoryId);
    final currentDay = scheduleRepository.currentDayData;
    emit(state.copyWith(
        auditorSchedule: auditorSchedule,
        currentDayData: currentDay.value,
        weekType: currentDay.value.currentDay?.weekType == 'нечетная' ? WeekType.odd : WeekType.even,
        isLoading: false,
        isSelected: true));
  }

  Future<void> _teacherUnselect(AuditorUnselect event, Emitter<AuditorScheduleState> emit) async {
    emit(state.copyWith(isSelected: false, searchQuery: ''));
  }
}
