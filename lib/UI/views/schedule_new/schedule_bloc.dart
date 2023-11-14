import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/UI/views/profile/profile_view_model.dart';
import 'package:kemsu_app/UI/views/schedule_new/widgets/schedule_list_pages.dart';
import 'package:kemsu_app/domain/models/schedule/current_group_model.dart';
import 'package:kemsu_app/domain/models/schedule/schedule_teacher_model.dart';
import 'package:kemsu_app/domain/repositories/schedule/abstract_schedule_repository.dart';

import '../../../domain/models/schedule/schedule_model.dart';

part 'schedule_events.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc(super.initialState, {required this.scheduleRepository}) {
    on<GetCurrentSchedule>(_getCurrentSchedule);
    on<ChangeWeekType>(_changeWeekType);
  }

  final AbstractScheduleRepository scheduleRepository;
  static const storage = FlutterSecureStorage();

  Future<void> _getCurrentSchedule(GetCurrentSchedule event, Emitter<ScheduleState> emit) async {
    String? userType = await storage.read(key: "userType");
    String? userFio = await storage.read(key: "FIO");
    final currentGroup = await scheduleRepository.getCurrentGroup();
    if (userType == EnumUserType.employee) {
      final teacherList = await scheduleRepository.getTeacherList();
      final teacherId = teacherList.teacherList.where((element) => element.fio == userFio);
      final teacherSchedule = await scheduleRepository.getTeacherSchedule(prepId: teacherId.first.prepId);
      emit(state.copyWith(teacherSchedule: teacherSchedule, userType: EnumUserType.employee, isLoading: false));
    }

    if (userType == EnumUserType.student) {
      try {
        final scheduleTable = await scheduleRepository.getSchedule(groupId: currentGroup.currentGroupList[0].groupId);
        emit(state.copyWith(scheduleTable: scheduleTable, userType: EnumUserType.student, currentGroupData: currentGroup, isLoading: false));
      } catch (e) {}
    }
  }

  Future<void> _changeWeekType(ChangeWeekType event, Emitter<ScheduleState> emit) async {
    try {
      emit(state.copyWith(weekType: event.weekType));
    } catch (e) {}
  }
}
