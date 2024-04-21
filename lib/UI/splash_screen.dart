import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kemsu_app/Configurations/navigation.dart';
import 'package:flutter/services.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LoadingView> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    getUserType();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarBrightness: Theme.of(context).brightness == Brightness.light ? Brightness.light : Brightness.dark));
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Image.asset('images/splash_logo.png'),
        ),
      ),
    );
  }
}

const storage = FlutterSecureStorage();

Future<void> getUserType() async {
  String? token = await storage.read(key: "tokenKey");
  Timer(
    const Duration(milliseconds: 2800),
    () {
      if (token == null) {
        AppRouting.toNotAuthMenu();
      } else {
        AppRouting.toMenu();
      }
    },
  );
}
