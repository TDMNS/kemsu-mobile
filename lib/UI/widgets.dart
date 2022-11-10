import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kemsu_app/UI/views/bug_report/main_bug_report_screen.dart';
import 'package:kemsu_app/UI/views/notifications/notifications_view.dart';

class EnumScreensWithoutPopArrow {
  static String get profile => "Главная";
  static String get news => "Новости";
  static String get schedule => "Расписание";
}

errorDialog1(context) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Ошибка'),
      content: const Text('Требуется логин/пароль пользователя!'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'OK'),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

errorDialog2(context) {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Ошибка'),
      content: const Text('Некорректный логин/пароль пользователя!'),
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
      style: TextStyle(color: Colors.blueGrey.shade800),
    ),
    centerTitle: true,
    actions: name == "Сообщения об ошибках"
        ? null
        : <Widget>[
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationView()));
                },
                icon: Icon(
                  Icons.notifications,
                  color: Colors.indigo.shade700,
                  size: 32,
                )),
          ],
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
    backgroundColor: Colors.white,
    shadowColor: Colors.black.withOpacity(0.2),
    leading: name == EnumScreensWithoutPopArrow.news ||
            name == EnumScreensWithoutPopArrow.profile ||
            name == EnumScreensWithoutPopArrow.schedule
        ? Container()
        : IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_outlined,
              color: Colors.indigo.shade700,
            )),
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
                  colors: <Color>[
                    Color.fromRGBO(0, 89, 165, 1),
                    Color.fromRGBO(1, 160, 226, 1)
                  ],
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
                  colors: <Color>[
                    Color.fromRGBO(0, 89, 165, 1),
                    Color.fromRGBO(1, 160, 226, 1)
                  ],
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
                  colors: <Color>[
                    Color.fromRGBO(0, 89, 165, 1),
                    Color.fromRGBO(1, 160, 226, 1)
                  ],
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
