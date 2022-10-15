import 'dart:async';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _controller!.forward();
    super.initState();

    Timer(const Duration(seconds: 3), () => Navigator.of(context).pop());
  }

  AnimationController? _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 20),
              )
            ]),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Ожидайте.',
                      style: TextStyle(
                          color: Color.fromRGBO(91, 91, 126, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 50, right: 50, bottom: 40),
                    child: Text(
                      'Ваши данные находятся на проверке.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromRGBO(91, 91, 126, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                  ),
                  Image.asset('images/icons/loader.gif', height: 50, width: 50),
                  const SizedBox(height: 20)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
