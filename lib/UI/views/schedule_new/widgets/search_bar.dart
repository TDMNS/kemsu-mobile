import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScheduleSearchBar extends StatelessWidget {
  const ScheduleSearchBar({
    super.key,
    required this.title,
    required this.onChanged,
    required this.onSubmitted,
  });

  final String title;
  final ValueSetter<String> onChanged;
  final ValueSetter<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: TextFormField(
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp("[0-9а-яА-Я -]")),
          ],
          onChanged: (value) => onChanged(value),
          onFieldSubmitted: (value) => onSubmitted(value),
          decoration: InputDecoration(
            hintText: title,
            contentPadding: const EdgeInsets.only(left: 12.0),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            ),
          ),
        ),
      ),
    );
  }
}
