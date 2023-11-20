import 'package:flutter/material.dart';

class WeekNum extends StatelessWidget {
  const WeekNum({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Неделя ',
          style: TextStyle(color: Theme.of(context).primaryColorDark, fontWeight: FontWeight.bold),
        ),
        Container(
          decoration: BoxDecoration(color: Theme.of(context).primaryColorDark, borderRadius: BorderRadius.circular(12.0)),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              title,
              style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          ),
        )
      ],
    );
  }
}
