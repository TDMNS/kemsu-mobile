import 'package:flutter/material.dart';

import '../../../../domain/models/schedule/schedule_teacher_model.dart';

class TeacherScheduleScreen extends StatefulWidget {
  final Result teacherSchedule;
  const TeacherScheduleScreen({super.key, required this.teacherSchedule});

  @override
  State<TeacherScheduleScreen> createState() => _TeacherScheduleScreenState();
}

class _TeacherScheduleScreenState extends State<TeacherScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) {
        final schedule = widget.teacherSchedule.prepScheduleTable[index];
        return Text(schedule.ceilList[0].ceil.even[0].groupName);
      },
      separatorBuilder: (context, index) => SizedBox(),
      itemCount: widget.teacherSchedule.prepScheduleTable.length,
    );
  }
}
