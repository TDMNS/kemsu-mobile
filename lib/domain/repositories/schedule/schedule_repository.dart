import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/domain/models/schedule/current_group_model.dart';
import 'package:kemsu_app/domain/models/schedule/faculty_list_model.dart';
import 'package:kemsu_app/domain/models/schedule/group_list_model.dart';
import 'package:kemsu_app/domain/models/schedule/schedule_model.dart';
import 'package:kemsu_app/domain/models/schedule/schedule_teacher_model.dart';
import 'package:kemsu_app/domain/models/schedule/semester_list_model.dart';
import 'package:kemsu_app/domain/models/schedule/week_list_model.dart';
import 'package:kemsu_app/domain/repositories/schedule/abstract_schedule_repository.dart';

import '../../../Configurations/config.dart';

class ScheduleRepository implements AbstractScheduleRepository {
  ScheduleRepository({required this.dio});

  final Dio dio;
  static const storage = FlutterSecureStorage();

  @override
  Future<CurrentGroupModel> getCurrentGroup() async {
    String? token = await storage.read(key: "tokenKey");
    final currentGroupResponse = await dio.get(Config.currentGroupList, queryParameters: {"accessToken": token});
    final currentGroupData = currentGroupResponse.data as Map<String, dynamic>;
    final currentGroup = CurrentGroupModel.fromJson(currentGroupData);

    return currentGroup;
  }

  @override
  Future<FacultyListModel> getFacultyList() async {
    // TODO: implement getFacultyList
    throw UnimplementedError();
  }

  @override
  Future<GroupListModel> getGroupList() async {
    // TODO: implement getGroupList
    throw UnimplementedError();
  }

  @override
  Future<ScheduleModel> getSchedule({required CurrentGroupModel currentGroup}) async {
    final weekListResponse = await dio.get(Config.weekList + '?semesterId=${currentGroup.currentGroupList[0].semesterId}');
    final weekListData = weekListResponse.data as Map<String, dynamic>;
    final weekList = WeekListModel.fromJson(weekListData);
    final scheduleTableResponse = await dio.get(Config.scheduleTable + '?groupId=${currentGroup.currentGroupList[0].groupId}&semesterWeekId=${weekList.result[0].id}');
    final scheduleTableData = scheduleTableResponse.data as Map<String, dynamic>;
    final scheduleTable = ScheduleModel.fromJson(scheduleTableData);
    return scheduleTable;
  }

  @override
  Future<SemesterListModel> getSemesterList() async {
    // TODO: implement getSemesterList
    throw UnimplementedError();
  }

  @override
  Future<WeekListModel> getWeekList() async {
    // TODO: implement getWeekList
    throw UnimplementedError();
  }

  @override
  Future<ScheduleTeacherModel> getTeacherList({required CurrentGroupModel currentGroup}) async {
    String? token = await storage.read(key: "tokenKey");
    final teacherListResponse = await dio.get(Config.teacherList + '?semesterId=${currentGroup.currentGroupList[0].semesterId}', queryParameters: {"accessToken": token});
    final teacherListData = teacherListResponse.data as Map<String, dynamic>;
    final teacherList = ScheduleTeacherModel.fromJson(teacherListData);
    return teacherList;
  }

  @override
  Future<TeacherScheduleModel> getTeacherSchedule({required CurrentGroupModel currentGroup, required int prepId}) async {
    String? token = await storage.read(key: "token");
    final teacherScheduleResponse = await dio.get(Config.prepSchedule, queryParameters: {
      "accessToken": token,
      "semesterId": currentGroup.currentGroupList[0].semesterId,
      "prepId": prepId,
    });
    final teacherScheduleDate = teacherScheduleResponse as Map<String, dynamic>;
    final teacherSchedule = TeacherScheduleModel.fromJson(teacherScheduleDate);
    return teacherSchedule;
  }
}
