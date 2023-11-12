import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:kemsu_app/local_notification_service.dart';
import 'package:stacked/stacked.dart';
import '../../../Configurations/config.dart';
import '../../splash_screen.dart';
import 'package:http/http.dart' as http;

import 'notifications_model.dart';

class NotificationViewModel extends BaseViewModel {
  NotificationViewModel(BuildContext context);

  bool circle = true;

  Future onReady() async {
    await _getUserNotifications();
    await _setReadStatusUserNotification();
    circle = false;
  }

  List<UserNotifications> userNotifications = [];

  _getUserNotifications() async {
    String? token = await storage.read(key: "tokenKey");
    var response = await http.get(Uri.parse('${Config.notifications}?accessToken=$token'));
    userNotifications = parseUserNotifications(json.decode(response.body)["userNotificationList"]);
    notifyListeners();
  }

  _setReadStatusUserNotification() async {
    String? token = await storage.read(key: "tokenKey");
    await http.post(Uri.parse('${Config.setReadStatusUserNotification}?accessToken=$token'));
    LocalNotificationService.unreadMessages.value = 0;
    notifyListeners();
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

  static List<UserNotifications> parseUserNotifications(List response) {
    return response.map<UserNotifications>((json) => UserNotifications.fromJson(json)).toList();
  }

  static Future<List<UserNotifications>> getUserNotificationsFromAny() async {
    String? token = await storage.read(key: "tokenKey");
    var response = await http.get(Uri.parse('${Config.notifications}?accessToken=$token'));
    return parseUserNotifications(json.decode(response.body)["userNotificationList"]);
  }
}
