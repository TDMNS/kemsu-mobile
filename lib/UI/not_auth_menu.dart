import 'package:flutter/material.dart';
import 'package:kemsu_app/Configurations/localizable.dart';
import 'package:kemsu_app/UI/views/auth/auth_screen.dart';
import 'package:kemsu_app/UI/views/online_courses/courses_screen.dart';
import 'package:kemsu_app/UI/views/profile/profile_view.dart';
import 'package:kemsu_app/UI/views/profile_bloc/profile_screen.dart';
import 'package:kemsu_app/UI/views/schedule_new/schedule_screen.dart';

class NotAuthMenu extends StatefulWidget {
  const NotAuthMenu({super.key});

  @override
  State<NotAuthMenu> createState() => _NotAuthMenuState();
}

class _NotAuthMenuState extends State<NotAuthMenu> with TickerProviderStateMixin {
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
          AuthScreen(),
          OnlineCourseScreen(),
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
          // BottomNavigationBarItem(
          //   icon: const Icon(Icons.newspaper),
          //   label: Localizable.pageNews,
          // ),
          BottomNavigationBarItem(
            icon: ScaleTransition(
              scale: _animations[0],
              child: const Icon(Icons.lock),
            ),
            label: Localizable.pageAuth,
          ),
          BottomNavigationBarItem(
            icon: ScaleTransition(
              scale: _animations[0],
              child: const Icon(Icons.video_collection),
            ),
            label: Localizable.pageCourses,
          ),
          // BottomNavigationBarItem(
          //   icon: ScaleTransition(
          //     scale: _animations[0],
          //     child: const Icon(Icons.calculate),
          //   ),
          //   label: Localizable.pageCalculation,
          // ),
        ],
      ),
    );
  }
}
