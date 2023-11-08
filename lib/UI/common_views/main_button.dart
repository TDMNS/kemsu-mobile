import 'package:flutter/material.dart';
import 'package:kemsu_app/Configurations/hex.dart';

mainButton(context, {required VoidCallback onPressed, required String title, required bool isPrimary}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
    child: Container(
        width: double.maxFinite,
        height: 46,
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Theme.of(context).primaryColorLight, offset: const Offset(0, 6), spreadRadius: -1, blurRadius: 5)],
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isPrimary ? [const Color(0xFF00C2FF), Colors.blueAccent] : [HexColor("#fc3f7b"), HexColor("#DC1554")],
          ),
        ),
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            title,
            style: const TextStyle(
              fontStyle: FontStyle.normal,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        )),
  );
}
