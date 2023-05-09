import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/views/notifications/notifications_view.dart';

class EnumScreensWithoutPopArrow {
  static String get profile => "Главная";
  static String get news => "Новости";
  static String get schedule => "Расписание";
  static String get prepScheduleEmp => "Расписание преподавателя";
  static String get prepScheduleStud => "Расписание преподавателей";
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
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

customAppBar(context, model, name) {
  return AppBar(
    title: Text(
      name,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    centerTitle: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          Theme.of(context).primaryColor == Colors.grey.shade900 ? Brightness.light : Brightness.dark,
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
      ?
      IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationView()));
          },
          icon: const Icon(
            Icons.notifications,
            color: Colors.blue,
          ))
          : Container()
    ],
  );
}

customBottomBar(BuildContext context, model) {
  return Container(
    decoration: BoxDecoration(
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 10,
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        currentIndex: model.selectedIndex,
        showSelectedLabels: true,
        backgroundColor: Colors.white,
        showUnselectedLabels: true,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, "/first");
              break;
            case 1:
              Navigator.pushNamed(context, "/second");
              break;
            case 2:
              Navigator.pushNamed(context, "/third");
              break;
          }
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: const Color.fromRGBO(91, 91, 126, 1),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: <Color>[Color.fromRGBO(0, 89, 165, 1), Color.fromRGBO(1, 160, 226, 1)],
                  tileMode: TileMode.repeated,
                ).createShader(bounds);
              },
              child: const Icon(Icons.newspaper),
            ),
            icon: const Icon(Icons.newspaper),
            label: 'Новости',
          ),
          BottomNavigationBarItem(
            activeIcon: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: <Color>[Color.fromRGBO(0, 89, 165, 1), Color.fromRGBO(1, 160, 226, 1)],
                  tileMode: TileMode.repeated,
                ).createShader(bounds);
              },
              child: const Icon(Icons.home),
            ),
            icon: const Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            activeIcon: ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  colors: <Color>[Color.fromRGBO(0, 89, 165, 1), Color.fromRGBO(1, 160, 226, 1)],
                  tileMode: TileMode.repeated,
                ).createShader(bounds);
              },
              child: const Icon(Icons.schedule),
            ),
            icon: const Icon(Icons.schedule),
            label: 'Расписание',
          ),
        ],
      ),
    ),
  );
}
