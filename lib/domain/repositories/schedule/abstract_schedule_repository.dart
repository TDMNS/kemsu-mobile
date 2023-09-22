import 'package:kemsu_app/domain/models/schedule/current_group_model.dart';
import 'package:kemsu_app/domain/models/schedule/faculty_list_model.dart';
import 'package:kemsu_app/domain/models/schedule/group_list_model.dart';
import 'package:kemsu_app/domain/models/schedule/schedule_model.dart';
import 'package:kemsu_app/domain/models/schedule/semester_list_model.dart';
import 'package:kemsu_app/domain/models/schedule/week_list_model.dart';

abstract class AbstractScheduleRepository {
  Future<ScheduleModel> getSchedule();

  Future<SemesterListModel> getSemesterList();
  Future<FacultyListModel> getFacultyList();
  Future<WeekListModel> getWeekList();
  Future<GroupListModel> getGroupList();
  Future<ScheduleModel> getCurrentGroup();
}
