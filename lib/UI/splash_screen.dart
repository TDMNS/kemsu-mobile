import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kemsu_app/UI/views/auth/auth_view.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LoadingView>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    Timer(
        const Duration(milliseconds: 2800),
        () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AuthView()),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(239, 239, 239, 1),
      child: Image.asset(
        'images/1.gif',
        scale: 2.5,
      ),
    );
  }
}
