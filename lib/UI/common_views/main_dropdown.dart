import 'package:flutter/material.dart';

mainDropdown(context, {required value, required items, required String textHint, required onChanged}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
    child: Container(
      decoration:
      BoxDecoration(border: Border.all(color: const Color(0xFF00C2FF)), borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
            dropdownColor: Theme.of(context).primaryColor,
            isExpanded: true,
            value: value,
            items: items,
            hint: Center(
                child: Text(
                  textHint,
                  style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14, fontStyle: FontStyle.normal),
                )),
            onChanged: onChanged),
      ),
    ),
  );
}