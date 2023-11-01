import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/views/profile/profile_view.dart';
import 'package:kemsu_app/domain/di_initial.dart';
import 'UI/custom_themes.dart';
import 'UI/splash_screen.dart';
import 'UI/views/news/news_view.dart';
import 'UI/views/schedule/schedule_view.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  diRegister();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: CustomThemes.lightTheme,
      darkTheme: CustomThemes.darkTheme,
      routes: {
        '/first': (context) => const NewsView(),
        '/second': (context) => const ProfileView(),
        '/third': (context) => const NewScheduleView(),
      },
      debugShowCheckedModeBanner: false,
      home: const LoadingView(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
