import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; // Импорт для Material App, если нужен
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'dart:convert';

import 'UI/splash_screen.dart';
import 'UI/views/notifications/notifications_view_model.dart';
import 'firebase_options.dart';
import 'package:kemsu_app/domain/dio_interceptor/dio_client.dart'; // Импортируйте DioClient

final localNotificationService = LocalNotificationService();

class LocalNotificationService {
  static ValueNotifier<int> unreadMessages = ValueNotifier(0);
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final String apiUrl = 'https://api-next.kemsu.ru/api/push-notification/fcm';
  final DioClient dio = DioClient(Dio());

  Future<void> setup() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    const androidInitializationSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInitializationSetting = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidInitializationSetting, iOS: iosInitializationSetting);
    await _flutterLocalNotificationsPlugin.initialize(initSettings);
    await _setupFirebaseNotifications();
  }

  Future<void> _setupFirebaseNotifications() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        await FirebaseMessaging.instance.getAPNSToken();
      }

      String? fcmToken = await FirebaseMessaging.instance.getToken();

      if (fcmToken != null) {
        subscribeToNotifications(fcmToken);
      }

      FirebaseMessaging.instance.onTokenRefresh.listen(subscribeToNotifications);
    }
  }

  void showLocalNotification(String title, String body) {
    const androidNotificationDetail = AndroidNotificationDetails('0', 'general');
    const iosNotificationDetail = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(iOS: iosNotificationDetail, android: androidNotificationDetail);
    _flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
  }

  Future<void> subscribeToNotifications(String fcmToken) async {
    String? accessToken = await storage.read(key: "tokenKey");
    await dio.post(
      '$apiUrl/subscribe',
      data: jsonEncode(<String, String>{
        'token': fcmToken,
      }),
      options: Options(
        headers: <String, String>{
          'Content-Type': 'application/json',
          'x-access-token': "$accessToken",
        },
      ),
    );
  }

  Future<void> socketIO() async {
    String? token = await storage.read(key: "tokenKey");

    socket_io.Socket socket = socket_io.io('wss://api-next.kemsu.ru', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'path': '/socket.io/notifications',
      'auth': {'accessToken': token},
    });

    socket.on('connect', (_) async {
      var userNotification = await NotificationViewModel.getUserNotificationsFromAny();
      for (var notification in userNotification) {
        unreadMessages.value += notification.newNotificationFlag ?? 0;
      }
      if (unreadMessages.value > 0) {
        showLocalNotification(userNotification[0].title ?? "Уведомление", userNotification[0].message ?? "У вас есть непросмотренные оповещения!");
      }
    });

    socket.on("notification", (data) async {
      var userNotification = await NotificationViewModel.getUserNotificationsFromAny();
      unreadMessages.value += userNotification[0].newNotificationFlag ?? 0;
      showLocalNotification(userNotification[0].title ?? "Уведомление", userNotification[0].message ?? "Узнайте, что вам пришло, нажав на колокольчик в правом верхнем углу.");
    });

    socket.connect();
  }
}
