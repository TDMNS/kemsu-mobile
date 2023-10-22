import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'UI/splash_screen.dart';
import 'UI/views/notifications/notifications_view_model.dart';

final localNotificationService = LocalNotificationService();

class LocalNotificationService {
  static var unreadMessages = 0;
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> setup() async {
    const androidInitializationSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInitializationSetting = DarwinInitializationSettings();
    const initSettings = InitializationSettings(android: androidInitializationSetting, iOS: iosInitializationSetting);
    await _flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  void showLocalNotification(String title, String body) {
    const androidNotificationDetail = AndroidNotificationDetails(
        '0',
        'general'
    );
    const iosNotificationDetail = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
      iOS: iosNotificationDetail,
      android: androidNotificationDetail,
    );
    _flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails);
  }

  socketIO() async {
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
        unreadMessages += notification.newNotificationFlag ?? 0;
      }
      if ((unreadMessages) > 0) {
        localNotificationService.showLocalNotification(
            userNotification[0].title ?? "Уведомление",
            userNotification[0].message ?? "У вас есть непросмотренные оповещения!"
        );
      }
    });

    socket.on("notification", (data) async {
      var userNotification = await NotificationViewModel.getUserNotificationsFromAny();
      localNotificationService.showLocalNotification(
          userNotification[0].title ?? "Уведомление",
          userNotification[0].message ?? "Узнайте, что вам пришло, нажав на колокольчик в правом верхнем углу."
      );
    });

    socket.connect(); // Connect to the server
  }
}
