import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import '../../../Configurations/config.dart';
import '../../splash_screen.dart';
import 'package:http/http.dart' as http;

import 'notifications_model.dart';

class NotificationViewModel extends BaseViewModel {
  NotificationViewModel(BuildContext context);

  bool circle = true;

  Future onReady() async {
    await getUserNotifications();
    circle = false;
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
