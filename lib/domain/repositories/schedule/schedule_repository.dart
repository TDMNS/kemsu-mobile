import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/domain/models/schedule/auditor_list_model.dart';
import 'package:kemsu_app/domain/models/schedule/auditor_schedule_model.dart';
import 'package:kemsu_app/domain/models/schedule/current_day_model.dart';
import 'package:kemsu_app/domain/models/schedule/current_group_model.dart';
import 'package:kemsu_app/domain/models/schedule/faculty_list_model.dart';
import 'package:kemsu_app/domain/models/schedule/group_list_model.dart';
import 'package:kemsu_app/domain/models/schedule/schedule_model.dart';
import 'package:kemsu_app/domain/models/schedule/schedule_teacher_model.dart';
import 'package:kemsu_app/domain/models/schedule/week_list_model.dart';
import 'package:kemsu_app/domain/repositories/schedule/abstract_schedule_repository.dart';

import '../../../Configurations/config.dart';

class ScheduleRepository implements AbstractScheduleRepository {
  ScheduleRepository({required this.dio});

  final Dio dio;
  static const storage = FlutterSecureStorage();
  final ValueNotifier<CurrentGroupModel> _currentGroupData = ValueNotifier(const CurrentGroupModel(success: true, currentGroupList: []));
  @override
  ValueListenable<CurrentGroupModel> get currentGroupData => _currentGroupData;

  final ValueNotifier<CurrentDayModel> _currentDayData = ValueNotifier(const CurrentDayModel());
  @override
  ValueListenable<CurrentDayModel> get currentDayData => _currentDayData;

  @override
  Future<CurrentGroupModel> getCurrentGroup() async {
    String? token = await storage.read(key: "tokenKey");
    final currentGroupResponse = await dio.get(
      Config.currentGroupList,
      options: Options(headers: {'x-access-token': token}),
    );
    final currentGroupMap = currentGroupResponse.data as Map<String, dynamic>;
    final currentGroup = CurrentGroupModel.fromJson(currentGroupMap);
    _currentGroupData.value = currentGroup;
    return currentGroup;
  }

  @override
  Future<FacultyListModel> getFacultyList() async {
    String? token = await storage.read(key: "tokenKey");
    final facultyListResponse = await dio.get(
      Config.facultyList,
      options: Options(headers: {'x-access-token': token}),
    );
    final facultyListMap = facultyListResponse.data as Map<String, dynamic>;
    final facultyList = FacultyListModel.fromJson(facultyListMap);
    return facultyList;
  }

  @override
  Future<GroupListModel> getGroupList({required int facultyId}) async {
    String? token = await storage.read(key: "tokenKey");

    final groupListResponse = await dio.get(
      Config.groupList,
      queryParameters: {
        "facultyId": facultyId,
      },
      options: Options(headers: {'x-access-token': token}),
    );
    final groupListMap = groupListResponse.data as Map<String, dynamic>;
    final groupList = GroupListModel.fromJson(groupListMap);
    return groupList;
  }

  @override
  Future<ScheduleModel> getSchedule({required int groupId}) async {
    String? token = await storage.read(key: "tokenKey");

    final weekListResponse = await dio.get(
      Config.weekList,
      options: Options(headers: {'x-access-token': token}),
    );
    final weekListData = weekListResponse.data as Map<String, dynamic>;
    final weekList = WeekListModel.fromJson(weekListData);
    final scheduleTableResponse = await dio.get(
      Config.scheduleTable,
      queryParameters: {
        'groupId': groupId,
        'semesterWeekId': weekList.result[0].id,
      },
      options: Options(headers: {'x-access-token': token}),
    );
    final scheduleTableData = scheduleTableResponse.data as Map<String, dynamic>;
    final scheduleTable = ScheduleModel.fromJson(scheduleTableData);
    return scheduleTable;
  }

  @override
  Future<ScheduleTeacherModel> getTeacherList() async {
    String? token = await storage.read(key: "tokenKey");
    final teacherListResponse = await dio.get(
      Config.teacherList,
      options: Options(headers: {'x-access-token': token}),
    );
    final teacherListData = teacherListResponse.data as Map<String, dynamic>;
    final teacherList = ScheduleTeacherModel.fromJson(teacherListData);
    return teacherList;
  }

  @override
  Future<TeacherScheduleModel> getTeacherSchedule({required int prepId}) async {
    String? token = await storage.read(key: "tokenKey");
    final teacherScheduleResponse = await dio.get(Config.prepSchedule, queryParameters: {
      "prepId": prepId,
    }, options: Options(headers: {'x-access-token': token}));
    final teacherScheduleDate = teacherScheduleResponse.data as Map<String, dynamic>;
    final teacherSchedule = TeacherScheduleModel.fromJson(teacherScheduleDate);
    return teacherSchedule;
  }

  @override
  Future<AuditorList> getAuditorList() async {
    String? token = await storage.read(key: "tokenKey");
    final auditorListResponse = await dio.get(
      Config.auditorList,
      options: Options(headers: {'x-access-token': token}),
    );
    final auditorListDate = auditorListResponse.data as Map<String, dynamic>;
    final auditorList = AuditorList.fromJson(auditorListDate);
    return auditorList;
  }

  @override
  Future<AuditorSchedule> getAuditorSchedule({required int auditoryId}) async {
    String? token = await storage.read(key: "tokenKey");
    final auditorScheduleResponse = await dio.get(
      Config.auditorSchedule,
      queryParameters: {
        "auditoryId": auditoryId,
      },
      options: Options(headers: {'x-access-token': token}),
    );
    final auditorScheduleData = auditorScheduleResponse.data as Map<String, dynamic>;
    final auditorSchedule = AuditorSchedule.fromJson(auditorScheduleData);
    return auditorSchedule;
  }

  @override
  Future<CurrentDayModel> getCurrentDayInfo() async {
    String? token = await storage.read(key: "tokenKey");
    final currentDayInfoResponse = await dio.get(Config.getWeekNum, options: Options(headers: {'x-access-token': token}));
    final currentDayInfoData = currentDayInfoResponse.data as Map<String, dynamic>;
    final currentDayInfo = CurrentDayModel.fromJson(currentDayInfoData);
    _currentDayData.value = currentDayInfo;

    return currentDayInfo;
  }
}
