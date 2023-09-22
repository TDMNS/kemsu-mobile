import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kemsu_app/domain/models/schedule/current_group_model.dart';
import 'package:kemsu_app/domain/repositories/schedule/abstract_schedule_repository.dart';

import '../../../domain/models/schedule/schedule_model.dart';

part 'schedule_event.dart';
part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  ScheduleBloc(this.scheduleRepository) : super(const ScheduleInitial()) {
    on<CurrentGroupLoadedEvent>(_currentGroupLoad);
  }

  final AbstractScheduleRepository scheduleRepository;

  Future<void> _currentGroupLoad(CurrentGroupLoadedEvent event, Emitter<ScheduleState> emit) async {
    try {
      final currentGroup = await scheduleRepository.getCurrentGroup();
      emit(CurrentGroupLoaded(currentGroup));
    } catch (e) {}
  }
}
