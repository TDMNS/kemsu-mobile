import 'package:flutter/foundation.dart';
import 'package:kemsu_app/domain/models/schedule/auditor_list_model.dart';
import 'package:kemsu_app/domain/models/schedule/auditor_schedule_model.dart';
import 'package:kemsu_app/domain/models/schedule/current_group_model.dart';
import 'package:kemsu_app/domain/models/schedule/faculty_list_model.dart';
import 'package:kemsu_app/domain/models/schedule/group_list_model.dart';
import 'package:kemsu_app/domain/models/schedule/schedule_model.dart';
import 'package:kemsu_app/domain/models/schedule/schedule_teacher_model.dart';
import 'package:kemsu_app/domain/models/schedule/semester_list_model.dart';
import 'package:kemsu_app/domain/models/schedule/week_list_model.dart';

abstract class AbstractScheduleRepository {
  Future<ScheduleModel> getSchedule({required int groupId});
  ValueListenable<CurrentGroupModel> get currentGroupData;
  Future<SemesterListModel> getSemesterList();
  Future<FacultyListModel> getFacultyList();
  Future<WeekListModel> getWeekList();
  Future<GroupListModel> getGroupList({required int facultyId});
  Future<CurrentGroupModel> getCurrentGroup();
  Future<ScheduleTeacherModel> getTeacherList({required CurrentGroupModel currentGroup});
  Future<TeacherScheduleModel> getTeacherSchedule({required CurrentGroupModel currentGroup, required int prepId});
  Future<AuditorList> getAuditorList();
  Future<AuditorSchedule> getAuditorSchedule({required int auditoryId});
}
