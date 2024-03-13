import 'dart:async';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/UI/menu.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/views/auth/auth_screen.dart';
import 'package:kemsu_app/UI/not_auth_menu.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LoadingView> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarBrightness: Theme.of(context).brightness == Brightness.light ? Brightness.light : Brightness.dark));
    return AnimatedSplashScreen.withScreenRouteFunction(
      screenRouteFunction: () async {
        return getUserType(context);
      },
      splash: Transform.scale(
        scale: 4,
        child: Image.asset('images/splash_logo.png'),
      ),
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}

const storage = FlutterSecureStorage();

getUserType(context) async {
  String? token = await storage.read(key: "tokenKey");
  token == null
      ? Timer(
          const Duration(milliseconds: 2800),
          () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotAuthMenu()),
              ))
      : Timer(
          const Duration(milliseconds: 2800),
          () => Navigator.of(context).push(
                MaterialPageRoute(
                  settings: const RouteSettings(name: "/menu"),
                  builder: (context) => const MainMenu(),
                ),
              ));
}
