import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/Configurations/navigation.dart';
import 'package:kemsu_app/domain/di_initial.dart';
import 'package:provider/provider.dart';
import 'UI/custom_themes.dart';
import 'UI/views/profile/profile_provider.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  diRegister();
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProfileProvider(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp.router(
      themeMode: ThemeMode.system,
      theme: CustomThemes.lightTheme,
      darkTheme: CustomThemes.darkTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
