import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kemsu_app/local_notification_service.dart';
import 'package:stacked/stacked.dart';
import '../../../Configurations/config.dart';
import '../../../domain/dio_wrapper/dio_client.dart';
import 'notifications_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NotificationViewModel extends BaseViewModel {
  NotificationViewModel(BuildContext context);

  final DioClient dio = DioClient(Dio());
  final storage = const FlutterSecureStorage();
  bool circle = true;
  List<UserNotifications> userNotifications = [];

  Future onReady() async {
    await _getUserNotifications();
    await _setReadStatusUserNotification();
    circle = false;
    notifyListeners();
  }

  Future<void> _getUserNotifications() async {
    String? token = await storage.read(key: "tokenKey");
    bool isTestUser = token == 'accessToken';

    if (isTestUser) {
      userNotifications = [
        UserNotifications(
          notificationId: 1,
          title: "Test Notification 1",
          message: "This is a test notification content 1",
          notificationDateTime: DateTime.now().toString(),
          newNotificationFlag: 1,
        ),
        UserNotifications(
          notificationId: 2,
          title: "Test Notification 2",
          message: "This is a test notification content 2",
          notificationDateTime: DateTime.now().toString(),
          newNotificationFlag: 1
        ),
      ];
    } else {
      final response = await dio.get(
        Config.notifications,
        options: Options(headers: {'x-access-token': token}),
      );
      userNotifications = parseUserNotifications(response.data["userNotificationList"]);
    }
    notifyListeners();
  }

  Future<void> _setReadStatusUserNotification() async {
    String? token = await storage.read(key: "tokenKey");
    bool isTestUser = token == 'accessToken';

    if (!isTestUser) {
      await dio.post(
        Config.setReadStatusUserNotification,
        options: Options(headers: {'x-access-token': token}),
      );
    }
    LocalNotificationService.unreadMessages.value = 0;
    notifyListeners();
  }

  Future<String> getPicture(UserNotifications userNotification) async {
    String pictureUrl = '${Config.storageNotify}/${userNotification.fileSrc}';
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
    final dio = DioClient(Dio());
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: "tokenKey");
    bool isTestUser = token == 'accessToken';

    if (isTestUser) {
      return [
        UserNotifications(
          notificationId: 1,
          title: "Test Notification 1",
          message: "This is a test notification content 1",
          notificationDateTime: DateTime.now().toString(),
          newNotificationFlag: 1
        ),
        UserNotifications(
          notificationId: 2,
          title: "Test Notification 2",
          message: "This is a test notification content 2",
          notificationDateTime: DateTime.now().toString(),
          newNotificationFlag: 1
        ),
      ];
    } else {
      final response = await dio.get(
        Config.notifications,
        options: Options(headers: {'x-access-token': token}),
      );
      return parseUserNotifications(response.data["userNotificationList"]);
    }
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
    String? token = await storage.read(key: "tokenKey");
    bool isTestUser = token == 'accessToken';

    if (!isTestUser) {
      await dio.post(
        Config.setUserVote,
        options: Options(headers: {'x-access-token': token}),
        data: {"notificationId": notificationId, "voteId": voteId},
      );
    }
  }
}
