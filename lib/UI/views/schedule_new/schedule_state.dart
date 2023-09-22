part of 'schedule_bloc.dart';

abstract class ScheduleState extends Equatable {
  const ScheduleState();
}

class ScheduleInitial extends ScheduleState {
  final ScheduleModel? currentGroup;

  const ScheduleInitial({this.currentGroup});

  ScheduleInitial copyWith({
    ScheduleModel? currentGroup,
  }) {
    return ScheduleInitial(
      currentGroup: currentGroup ?? this.currentGroup,
    );
  }

  @override
  List<Object?> get props => [currentGroup];
}

class CurrentGroupLoaded extends ScheduleState {
  const CurrentGroupLoaded(this.currentGroup);
  final ScheduleModel currentGroup;
  @override
  List<Object> get props => [currentGroup];
}
