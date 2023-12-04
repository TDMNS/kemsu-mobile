import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/views/notifications/notifications_view.dart';
import 'package:badges/badges.dart' as badges;
import '../local_notification_service.dart';

class EnumScreensWithoutPopArrow {
  static String get profile => "Главная";
  static String get news => "Новости";
  static String get schedule => "Расписание";
  static String get prepScheduleEmp => "Расписание преподавателя";
  static String get prepScheduleStud => "Расписание преподавателей";
}

class ErrorDialog extends StatelessWidget {
  final BuildContext context;
  final String textContent;

  const ErrorDialog({super.key, required this.context, required this.textContent});

  @override
  Widget build(context) {
    return AlertDialog(
      title: const Text('Ошибка'),
      content: Text(textContent),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
          ),
          child: const Text('OK'),
        ),
      ],
    );
  }
}

errorDialog(context, textContent) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Ошибка'),
      content: Text(textContent),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
          ),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

customAppBar(context, name) {
  return AppBar(
    title: Text(
      name,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    centerTitle: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Theme.of(context).primaryColor == Colors.grey.shade900 ? Brightness.light : Brightness.dark,
    ),
    shadowColor: Colors.black.withOpacity(0.2),
    leading: name == EnumScreensWithoutPopArrow.news ||
            name == EnumScreensWithoutPopArrow.profile ||
            name == EnumScreensWithoutPopArrow.schedule ||
            name == EnumScreensWithoutPopArrow.prepScheduleEmp
        ? Container()
        : IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
              color: Colors.blue,
            )),
    actions: [
      name == EnumScreensWithoutPopArrow.news ||
              name == EnumScreensWithoutPopArrow.profile ||
              name == EnumScreensWithoutPopArrow.schedule ||
              name == EnumScreensWithoutPopArrow.prepScheduleEmp
          ? ValueListenableBuilder(
              valueListenable: LocalNotificationService.unreadMessages,
              builder: (BuildContext context, int value, Widget? child) {
                return badges.Badge(
                  position: badges.BadgePosition.topEnd(top: 10, end: 8),
                  showBadge: LocalNotificationService.unreadMessages.value > 0 ? true : false,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationView()));
                    },
                    icon: const Icon(
                      Icons.notifications,
                      color: Colors.blue,
                    ),
                  ),
                );
              })
          : Container()
    ],
  );
}

class Loader extends StatelessWidget {
  const Loader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.blue,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}

class DialogPage<T> extends Page<T> {
  final Offset? anchorPoint;
  final Color? barrierColor;
  final bool barrierDismissible;
  final String? barrierLabel;
  final bool useSafeArea;
  final CapturedThemes? themes;
  final WidgetBuilder builder;

  const DialogPage({
    required this.builder,
    this.anchorPoint,
    this.barrierColor = Colors.black54,
    this.barrierDismissible = true,
    this.barrierLabel,
    this.useSafeArea = true,
    this.themes,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  @override
  Route<T> createRoute(BuildContext context) => DialogRoute<T>(
      context: context,
      settings: this,
      builder: builder,
      anchorPoint: anchorPoint,
      barrierColor: barrierColor,
      barrierDismissible: barrierDismissible,
      barrierLabel: barrierLabel,
      useSafeArea: useSafeArea,
      themes: themes);
}