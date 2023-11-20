import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'current_day_model.g.dart';

@JsonSerializable()
class CurrentDayModel extends Equatable {
  @JsonKey(name: "success")
  final bool? success;
  @JsonKey(name: "currentDay")
  final CurrentDay? currentDay;

  const CurrentDayModel({
    this.success,
    this.currentDay,
  });

  factory CurrentDayModel.fromJson(Map<String, dynamic> json) => _$CurrentDayModelFromJson(json);
  Map<String, dynamic> toJson() => _$CurrentDayModelToJson(this);

  @override
  List<Object?> get props => [
        success,
        currentDay,
      ];
}

@JsonSerializable()
class CurrentDay extends Equatable {
  @JsonKey(name: "weekNum")
  final int? weekNum;
  @JsonKey(name: "weekType")
  final String? weekType;
  @JsonKey(name: "currentDate")
  final String? currentDate;
  @JsonKey(name: "currentDay")
  final String? currentDay;

  const CurrentDay({
    this.weekNum,
    this.weekType,
    this.currentDate,
    this.currentDay,
  });

  factory CurrentDay.fromJson(Map<String, dynamic> json) => _$CurrentDayFromJson(json);
  Map<String, dynamic> toJson() => _$CurrentDayToJson(this);

  @override
  List<Object?> get props => [
        weekNum,
        weekType,
        currentDate,
        currentDay,
      ];
}
