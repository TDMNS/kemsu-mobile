import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String content) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.hideCurrentSnackBar();
  scaffold.showSnackBar(
    SnackBar(
      content: Text(content),
      duration: const Duration(seconds: 5),
      showCloseIcon: true,
      closeIconColor: Colors.white
    ),
  );
}