import 'package:go_router/go_router.dart';
import 'package:kemsu_app/UI/menu.dart';
import 'package:kemsu_app/UI/splash_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'loading',
      path: '/',
      builder: (context, state) => const LoadingView(),
    ),
    GoRoute(
      name: 'menu',
      path: '/menu',
      builder: (context, state) => const MainMenu(
        type: 0,
      ),
    ),
  ],
);

class AppRouting {
  AppRouting._();

  static void toMenu() => appRouter.go('/menu');
}
