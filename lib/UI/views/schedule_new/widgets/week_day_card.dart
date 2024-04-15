import 'package:flutter/material.dart';
import 'package:kemsu_app/Configurations/localizable.dart';
import 'package:kemsu_app/UI/views/schedule_new/widgets/schedule_list_pages.dart';

class WeekDayCard extends StatelessWidget {
  const WeekDayCard({
    super.key,
    required this.title,
    required this.time,
    required this.scheduleType,
  });

  final String? title;
  final String? time;
  final ScheduleType? scheduleType;

  @override
  Widget build(BuildContext context) {
    final nonOptionalTitle = title ?? '';
    return Container(
      margin: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            scheduleType == ScheduleType.auditor && nonOptionalTitle.isEmpty
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          Localizable.auditorSchedulePlaceholder,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                : Expanded(
                    child: Text(
                      '$title',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
            Text(
              '$time',
              style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

String weekDayTitle(weekDayIndex) {
  String weekDayTitle = '';
  switch (weekDayIndex) {
    case 0:
      weekDayTitle = Localizable.monday;
      break;
    case 1:
      weekDayTitle = Localizable.tuesday;
      break;
    case 2:
      weekDayTitle = Localizable.wednesday;
      break;
    case 3:
      weekDayTitle = Localizable.thursday;
      break;
    case 4:
      weekDayTitle = Localizable.friday;
      break;
    case 5:
      weekDayTitle = Localizable.saturday;
      break;
  }
  return weekDayTitle;
}
