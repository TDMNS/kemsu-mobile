import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kemsu_app/UI/menu.dart';
import 'package:kemsu_app/UI/splash_screen.dart';
import 'package:kemsu_app/UI/views/auth/new_auth/auth_screen.dart';
import '../UI/widgets.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'loading',
      path: '/',
      builder: (context, state) => const LoadingView(),
    ),
    GoRoute(
      name: 'auth',
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
      routes: [
        GoRoute(
          name: 'alert',
          path: 'alert',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return DialogPage(builder: (_) {
              final textContent = (state.extra as Map<String, dynamic>?)?['content'] ?? 'Default error message';
              return ErrorDialog(context: context, textContent: textContent);
            });
          },
        ),
      ]
    ),
    GoRoute(
      name: 'menu',
      path: '/menu',
      builder: (context, state) => const MainMenu(type: 0),
    ),
  ],
);

class AppRouting {
  AppRouting._();

  static void toAuth() => appRouter.go('/auth');
  static void toAlert(String textContent) => appRouter.go('/auth/alert', extra: {'content': textContent});
  static void toMenu() => appRouter.go('/menu');
}
