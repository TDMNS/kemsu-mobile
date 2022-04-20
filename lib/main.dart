import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kemsu_app/UI/views/profile/profile_view.dart';

import 'UI/views/auth/auth_view.dart';
import 'UI/views/news/news_view.dart';
import 'UI/views/schedule/schedule_view.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/first': (context) => const NewsView(),
        '/second': (context) => const ScheduleView(),
        '/third': (context) => const ProfileView(),
      },
      debugShowCheckedModeBanner: false,
      home: const AuthView(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
