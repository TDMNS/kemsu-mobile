import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'generated/group_list_model.g.dart';

@JsonSerializable()
class GroupListModel extends Equatable {
  final bool success;
  final List<GroupResult> result;

  const GroupListModel({required this.success, required this.result});

  factory GroupListModel.fromJson(Map<String, dynamic> json) => _$GroupListModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupListModelToJson(this);

  @override
  List<Object?> get props => [success, result];
}

@JsonSerializable()
class GroupResult extends Equatable {
  @JsonKey(name: 'Id')
  final int id;
  @JsonKey(name: 'GroupName')
  final String groupName;
  final String specName;
  final String learnForm;

  const GroupResult({required this.id, required this.groupName, required this.specName, required this.learnForm});

  factory GroupResult.fromJson(Map<String, dynamic> json) => _$GroupResultFromJson(json);
  Map<String, dynamic> toJson() => _$GroupResultToJson(this);

  @override
  List<Object?> get props => [id, groupName, specName, learnForm];
}
