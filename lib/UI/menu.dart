import 'package:flutter/material.dart';
import 'package:kemsu_app/Configurations/localizable.dart';
import 'package:kemsu_app/UI/views/profile_bloc/profile_screen.dart';
import 'package:kemsu_app/UI/views/schedule_new/schedule_screen.dart';


class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> with TickerProviderStateMixin {
  int _selectedIndex = 0;

  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _animationControllers = List.generate(
        2,
        (index) => AnimationController(
              vsync: this,
              duration: const Duration(milliseconds: 300),
            ));

    _animations = _animationControllers
        .map((controller) => Tween<double>(begin: 1.0, end: 1.2).animate(
              CurvedAnimation(parent: controller, curve: Curves.elasticOut),
            ))
        .toList();

    _animationControllers[_selectedIndex].forward();
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      _animationControllers[_selectedIndex].reverse().then((_) {
        _animationControllers[index].forward();
      });
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          ProfileScreen(),
          ScheduleScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Theme.of(context).canvasColor,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: ScaleTransition(
              scale: _animations[0],
              child: const Icon(Icons.home),
            ),
            label: Localizable.pageMain,
          ),
          BottomNavigationBarItem(
            icon: ScaleTransition(
              scale: _animations[1],
              child: const Icon(Icons.schedule),
            ),
            label: Localizable.pageSchedule,
          ),
        ],
      ),
    );
  }
}
