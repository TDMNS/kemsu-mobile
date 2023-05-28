import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:stacked/stacked_annotations.dart';
import '../../../Configurations/config.dart';
import '../../splash_screen.dart';
import 'package:http/http.dart' as http;

import 'notifications_model.dart';

class NotificationViewModel extends BaseViewModel {
  NotificationViewModel(BuildContext context);

  Future onReady() async {
    await getUserNotifications();
  }

  List<UserNotifications> userNotifications = [];

  List<UserNotifications> parseUserNotifications(List response) {
    return response.map<UserNotifications>((json) => UserNotifications.fromJson(json)).toList();
  }

  getUserNotifications() async {
    String? token = await storage.read(key: "tokenKey");
    var response = await http.get(Uri.parse('${Config.notifications}?accessToken=$token'));
    userNotifications = parseUserNotifications(json.decode(response.body)["userNotificationList"]);
    notifyListeners();
  }

  socketTest() async {
    String? token = await storage.read(key: "tokenKey");

    IO.Socket socket = IO.io('wss://api-next.kemsu.ru', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false, // Set this to true if you want to connect immediately
      'path': '/socket.io/notifications',
      'auth': {'accessToken': token},
    });

    socket.on('connect', (_) {
      print('Connected');
      // Additional logic on successful connection
    });

    socket.on('disconnect', (_) {
      print('Disconnected');
      // Additional logic on disconnection
    });

    socket.on('error', (data) {
      print('Error: $data');
      // Additional error handling logic
    });

    socket.on("notification", (data) {
      print('Notification: $data');
    });

    socket.connect(); // Connect to the server
  }

  Future<String> getPicture(UserNotifications userNotifications) async {
    String pictureUrl = '${Config.storageNotify}/${userNotifications.fileSrc}';
    return pictureUrl;
  }

  Future<List<String>> getImageUrls(List<UserNotifications> notifications) async {
    List<String> urls = [];
    for (final notification in notifications) {
      String imageUrl = await getPicture(notification);
      urls.add(imageUrl);
    }
    return urls;
  }
}
