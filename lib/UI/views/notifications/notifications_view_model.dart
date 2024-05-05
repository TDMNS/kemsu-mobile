import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kemsu_app/local_notification_service.dart';
import 'package:stacked/stacked.dart';
import '../../../Configurations/config.dart';
import '../../splash_screen.dart';
import 'package:http/http.dart' as http;
import 'notifications_model.dart';

class NotificationViewModel extends BaseViewModel {
  NotificationViewModel(BuildContext context);

  bool circle = true;
  List<UserNotifications> userNotifications = [];

  Future onReady() async {
    await _getUserNotifications();
    await _setReadStatusUserNotification();
    circle = false;
  }

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

  bool isLink(String text) {
    final RegExp urlRegex = RegExp(
      r'^(?:http|ftp)s?://'
      r'(?:(?:[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?\.)+(?:[A-Z]{2,6}\.?|[A-Z0-9-]{2,}\.?)|'
      r'localhost|'
      r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}|'
      r'\[?[A-F0-9]*:[A-F0-9:]+\]?)'
      r'(?::\d+)?'
      r'(?:/?|[/?]\S+)$',
      caseSensitive: false,
    );

    return urlRegex.hasMatch(text);
  }

  Future<void> setUserVote(int notificationId, int? voteId) async {
    final Dio dio = Dio();
    String? token = await storage.read(key: "tokenKey");
    await dio.post(Config.setUserVote, options: Options(headers: {'x-access-token': token}), data: {"notificationId": notificationId, "voteId": voteId});
  }
}
