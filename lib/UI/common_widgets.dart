import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/Configurations/navigation.dart';
import 'package:kemsu_app/UI/splash_screen.dart';
import 'package:kemsu_app/UI/views/notifications/notifications_view.dart';
import 'package:badges/badges.dart' as badges;
import '../Configurations/localizable.dart';
import '../local_notification_service.dart';

class EnumScreensWithoutPopArrow {
  static const String profile = "Главная";
  static const String news = "Новости";
  static const String schedule = "Расписание";
  static const String prepScheduleEmp = "Расписание преподавателя";
  static const String prepScheduleStud = "Расписание преподавателей";
  static const String courses = "Курсы";
  static const String calculator = "Калькулятор";
}

class ErrorDialog extends StatelessWidget {
  final BuildContext context;
  final String title;
  final String body;

  const ErrorDialog({super.key, required this.context, required this.title, required this.body});

  @override
  Widget build(context) {
    return AlertDialog(
      title: Text(title),
      content: Text(body),
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

customAppBar(BuildContext context, String? name, {bool canBack = true}) {
  Widget? leadingIcon;

  switch (name) {
    case EnumScreensWithoutPopArrow.profile:
      leadingIcon = _exitLeadingAction(context, leadingIcon);
      break;
    case EnumScreensWithoutPopArrow.news:
      leadingIcon = _exitLeadingAction(context, leadingIcon);
      break;
    case EnumScreensWithoutPopArrow.schedule:
      leadingIcon = _exitLeadingAction(context, leadingIcon);
      break;
    default:
      if (canBack) {
        leadingIcon = IconButton(
          icon: const Icon(Icons.arrow_back_outlined, color: Colors.blue),
          onPressed: () {
            AppRouting.back();
          },
        );
      }
  }

  return AppBar(
    title: Text(
      name ?? '',
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    centerTitle: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Theme.of(context).primaryColor == Colors.grey.shade900 ? Brightness.light : Brightness.dark,
    ),
    shadowColor: Colors.black.withOpacity(0.2),
    leading: leadingIcon,
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

_exitLeadingAction(context, leadingIcon) {
  return leadingIcon = IconButton(
    icon: const Icon(Icons.exit_to_app, color: Colors.blue),
    onPressed: () {
      _logoutConfirm(context);
    },
  );
}

_logoutConfirm(context) {
  return showDialog(
    context: context,
    builder: (context) => Theme(
      data: ThemeData(useMaterial3: false),
      child: AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        title: Text(
          Localizable.mainWarning,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  width: 15,
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    Localizable.cancel,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () async {
                    await storage.delete(key: "tokenKey");
                    AppRouting.toNotAuthMenu();
                  },
                  child: Text(
                    Localizable.yes,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
              ],
            ),
          )
        ],
      ),
    ),
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
