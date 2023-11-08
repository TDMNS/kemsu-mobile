import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/domain/models/schedule/auditor_list_model.dart';
import 'package:kemsu_app/domain/models/schedule/auditor_schedule_model.dart';
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
  final ValueNotifier<CurrentGroupModel> _currentGroupData = ValueNotifier(const CurrentGroupModel(success: true, currentGroupList: []));
  @override
  ValueListenable<CurrentGroupModel> get currentGroupData => _currentGroupData;

  @override
  Future<CurrentGroupModel> getCurrentGroup() async {
    String? token = await storage.read(key: "tokenKey");
    final currentGroupResponse = await dio.get(
      Config.currentGroupList,
      queryParameters: {
        "accessToken": token,
      },
    );
    final currentGroupMap = currentGroupResponse.data as Map<String, dynamic>;
    final currentGroup = CurrentGroupModel.fromJson(currentGroupMap);
    _currentGroupData.value = currentGroup;
    log('CURRENT GROUP:: $currentGroupMap');
    return currentGroup;
  }

  @override
  Future<FacultyListModel> getFacultyList() async {
    int semesterId = currentGroupData.value.currentGroupList[0].semesterId;
    final facultyListResponse = await dio.get(
      Config.facultyList,
      queryParameters: {
        "semesterId": semesterId,
      },
    );
    final facultyListMap = facultyListResponse.data as Map<String, dynamic>;
    final facultyList = FacultyListModel.fromJson(facultyListMap);
    return facultyList;
  }

  @override
  Future<GroupListModel> getGroupList({required int facultyId}) async {
    int semesterId = currentGroupData.value.currentGroupList[0].semesterId;
    final groupListResponse = await dio.get(
      Config.groupList,
      queryParameters: {
        "semesterId": semesterId,
        "facultyId": facultyId,
      },
    );
    final groupListMap = groupListResponse.data as Map<String, dynamic>;
    final groupList = GroupListModel.fromJson(groupListMap);
    return groupList;
  }

  @override
  Future<ScheduleModel> getSchedule({required int groupId}) async {
    int semesterId = currentGroupData.value.currentGroupList[0].semesterId;

    final weekListResponse = await dio.get(
      Config.weekList,
      queryParameters: {
        'semesterId': semesterId,
      },
    );
    final weekListData = weekListResponse.data as Map<String, dynamic>;
    final weekList = WeekListModel.fromJson(weekListData);
    final scheduleTableResponse = await dio.get(
      Config.scheduleTable,
      queryParameters: {
        'groupId': groupId,
        'semesterWeekId': weekList.result[0].id,
      },
    );
    final scheduleTableData = scheduleTableResponse.data as Map<String, dynamic>;
    final scheduleTable = ScheduleModel.fromJson(scheduleTableData);
    log("TEST:: ${scheduleTableResponse.data}");
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
    final teacherListResponse = await dio.get(
      Config.teacherList,
      queryParameters: {
        "accessToken": token,
        "semesterId": currentGroup.currentGroupList[0].semesterId,
      },
    );
    final teacherListData = teacherListResponse.data as Map<String, dynamic>;
    final teacherList = ScheduleTeacherModel.fromJson(teacherListData);
    return teacherList;
  }

  @override
  Future<TeacherScheduleModel> getTeacherSchedule({required CurrentGroupModel currentGroup, required int prepId}) async {
    String? token = await storage.read(key: "tokenKey");
    final teacherScheduleResponse = await dio.get(Config.prepSchedule, queryParameters: {
      "accessToken": token,
      "semesterId": currentGroup.currentGroupList[0].semesterId,
      "prepId": prepId,
    });
    final teacherScheduleDate = teacherScheduleResponse.data as Map<String, dynamic>;
    final teacherSchedule = TeacherScheduleModel.fromJson(teacherScheduleDate);
    return teacherSchedule;
  }

  @override
  Future<AuditorList> getAuditorList() async {
    String? token = await storage.read(key: "tokenKey");
    final auditorListResponse = await dio.get(
      Config.auditorList,
      queryParameters: {
        "accessToken": token,
      },
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
        "accessToken": token,
        "auditoryId": auditoryId,
      },
    );
    final auditorScheduleDate = auditorScheduleResponse.data as Map<String, dynamic>;
    final auditorSchedule = AuditorSchedule.fromJson(auditorScheduleDate);
    return auditorSchedule;
  }
}
