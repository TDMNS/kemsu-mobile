import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'generated/week_list_model.g.dart';

@JsonSerializable()
class WeekListModel extends Equatable {
  final bool success;
  final List<WeekResult> result;

  const WeekListModel({required this.success, required this.result});

  factory WeekListModel.fromJson(Map<String, dynamic> json) => _$WeekListModelFromJson(json);
  Map<String, dynamic> toJson() => _$WeekListModelToJson(this);

  @override
  List<Object?> get props => [success, result];
}

@JsonSerializable()
class WeekResult extends Equatable {
  @JsonKey(name: 'Id')
  final int id;
  @JsonKey(name: 'Num')
  final int num;

  const WeekResult({required this.id, required this.num});

  factory WeekResult.fromJson(Map<String, dynamic> json) => _$WeekResultFromJson(json);
  Map<String, dynamic> toJson() => _$WeekResultToJson(this);

  @override
  List<Object?> get props => [id, num];
}
