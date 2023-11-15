import 'package:flutter/material.dart';
import 'package:kemsu_app/UI/views/schedule_new/widgets/schedule_list_pages.dart';

class WeekTypeRadio extends StatelessWidget {
  const WeekTypeRadio({super.key, required this.title, required this.weekType, required this.currentWeekType, required this.onTap});

  final VoidCallback onTap;
  final String title;
  final WeekType weekType;
  final WeekType currentWeekType;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        decoration: BoxDecoration(
          color: currentWeekType == weekType ? Theme.of(context).primaryColorDark : Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          title,
          style: TextStyle(color: currentWeekType == weekType ? Theme.of(context).primaryColor : Theme.of(context).primaryColorDark , fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
