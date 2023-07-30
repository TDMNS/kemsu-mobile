import 'package:flutter/material.dart';
import 'package:kemsu_app/UI/views/news/news_view.dart';
import 'package:kemsu_app/UI/views/profile/profile_view.dart';
import 'package:kemsu_app/UI/views/prep_schedule/prep_schedule_view.dart';
import 'package:kemsu_app/UI/views/schedule/schedule_view.dart';

import '../Configurations/localizable.dart';

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
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(Icons.newspaper),
                label: Localizable.pageNews,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: Localizable.pageMain,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.schedule),
                label: Localizable.pageSchedule,
              ),
            ]));
  }
}
