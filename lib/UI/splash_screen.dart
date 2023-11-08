import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/UI/menu.dart';
import 'package:kemsu_app/UI/views/auth/auth_view.dart';
import 'package:flutter/services.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LoadingView> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    getUserType(context);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarBrightness: Theme.of(context).brightness == Brightness.light ? Brightness.light : Brightness.dark));
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Image.asset(
        'images/splash_logo.png',
        scale: 2.5,
      ),
    );
  }
}

const storage = FlutterSecureStorage();

getUserType(context) async {
  String? token = await storage.read(key: "tokenKey");
  String? userTypeTemp = await storage.read(key: "userType");
  int? type;
  userTypeTemp == 'обучающийся' ? type = 0 : type = 1;
  token == null
      ? Timer(
          const Duration(milliseconds: 2800),
          () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AuthView()),
              ))
      : Timer(
          const Duration(milliseconds: 2800),
          () => Navigator.of(context).push(
                MaterialPageRoute(
                  settings: const RouteSettings(name: "/menu"),
                  builder: (context) => MainMenu(type: type!),
                ),
              ));
}
