import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kemsu_app/UI/menu.dart';
import 'package:kemsu_app/UI/splash_screen.dart';
import 'package:kemsu_app/UI/views/auth/auth_screen.dart';
import '../UI/common_widgets.dart';
import 'localizable.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'loading',
      path: '/',
      builder: (context, state) => const LoadingView(),
    ),
    GoRoute(name: 'auth', path: '/auth', builder: (context, state) => const AuthScreen(), routes: [
      GoRoute(
        name: 'alert',
        path: 'alert',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return DialogPage(builder: (_) {
            final title = (state.extra as Map<String, dynamic>?)?['title'] ?? Localizable.authError;
            final body = (state.extra as Map<String, dynamic>?)?['body'] ?? Localizable.someErrorBodyDescription;
            return ErrorDialog(context: context, title: title, body: body);
          });
        },
      ),
    ]),
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
  static void toAuthAlert({String? title, required String body}) =>
      appRouter.go('/auth/alert', extra: {'title': title ?? Localizable.authError, 'body': body});
  static void toMenu() => appRouter.go('/menu');
  static void toMenuPop(context) => popUtil(context, '/menu');
}

//Кажется не работает
popUtil(context, page) {
  final router = GoRouter.of(context);
  final GoRouterDelegate delegate = router.routerDelegate;
  final routes = delegate.currentConfiguration.routes;
  for (var i = 0; i < routes.length; i++) {
    final route = routes[i] as GoRoute;
    if (route.name == page) break;
    GoRouter.of(context).pop();
  }
}
