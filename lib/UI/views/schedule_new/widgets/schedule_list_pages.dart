import 'package:flutter/material.dart';
import 'package:kemsu_app/UI/views/schedule_new/widgets/week_day_card.dart';
import 'package:kemsu_app/domain/models/schedule/auditor_schedule_model.dart';
import 'package:kemsu_app/domain/models/schedule/schedule_model.dart';
import 'package:kemsu_app/domain/models/schedule/schedule_teacher_model.dart';

enum ScheduleType { current, teacher, auditor }

enum WeekType { even, odd }

class ScheduleListPages extends StatelessWidget {
  const ScheduleListPages({
    super.key,
    this.weekDays,
    this.times,
    required this.weekType,
    this.teacherSchedule,
    required this.scheduleType,
    this.auditorSchedule,
  });

  final List<ScheduleWeekDay>? weekDays;
  final List<ScheduleCoupleList>? times;
  final WeekType weekType;
  final ScheduleType scheduleType;
  final List<PrepScheduleTable>? teacherSchedule;
  final AuditorSchedule? auditorSchedule;

  @override
  Widget build(BuildContext context) {
    final controller = PageController(initialPage: DateTime.now().weekday == 7 ? 0 : DateTime.now().weekday - 1);

    return PageView.builder(
      controller: controller,
      itemCount: 6,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            const SizedBox(height: 12.0),
            Text(
              weekDayTitle(index),
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12.0),
            Expanded(
              child: ListView.builder(
                itemCount: 7,
                itemBuilder: (context, ceilIndex) {
                  switch (scheduleType) {
                    case ScheduleType.current:
                      return WeekDayCard(
                        title: weekType == WeekType.odd ? weekDays![index].oddCouple[ceilIndex] : weekDays![index].evenCouple[ceilIndex],
                        time: times![ceilIndex].description,
                        scheduleType: ScheduleType.current,
                      );
                    case ScheduleType.teacher:
                      return WeekDayCard(
                        title: weekType == WeekType.odd ? teacherSchedule![index].ceilList[ceilIndex].ceil.unevenCeil : teacherSchedule![index].ceilList[ceilIndex].ceil.evenCeil,
                        time: teacherSchedule![index].ceilList[ceilIndex].couple.description,
                        scheduleType: ScheduleType.teacher,
                      );
                    case ScheduleType.auditor:
                      return WeekDayCard(
                        title: weekType == WeekType.odd ? auditorSchedule?.table![ceilIndex][index].oddAllCouple : auditorSchedule?.table![ceilIndex][index].evenAllCouple,
                        time: auditorSchedule?.coupleList![ceilIndex].description,
                        scheduleType: ScheduleType.auditor,
                      );
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
