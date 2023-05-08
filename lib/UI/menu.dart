import 'package:flutter/material.dart';
import 'package:kemsu_app/UI/views/news/news_view.dart';
import 'package:kemsu_app/UI/views/profile/profile_view.dart';
import 'package:kemsu_app/UI/views/schedule/prep_schedule_view.dart';
import 'package:kemsu_app/UI/views/schedule/schedule_view.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key, required this.type}) : super(key: key);
  final int type;
  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            const NewsView(),
            const ProfileView(),
            widget.type == 0
                ? const NewScheduleView()
                : const PrepScheduleView()
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Theme.of(context).primaryColor,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue,
            unselectedItemColor:
                Theme.of(context).canvasColor, //<-- Unselected text
            type: BottomNavigationBarType.fixed,
            onTap: _onItemTapped,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.newspaper),
                label: 'Новости',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Главная',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.schedule),
                label: 'Расписание',
              ),
            ]));
  }
}
