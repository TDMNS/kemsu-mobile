import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:kemsu_app/UI/menu.dart';
import 'package:kemsu_app/UI/not_auth_menu.dart';
import 'package:kemsu_app/UI/splash_screen.dart';
import 'package:kemsu_app/UI/views/bug_report/bug_report_view.dart';
import 'package:kemsu_app/UI/views/calculation/calculation_screen.dart';
import 'package:kemsu_app/UI/views/check_list/check_list_view.dart';
import 'package:kemsu_app/UI/views/debts/debts_view.dart';
import 'package:kemsu_app/UI/views/edit/edit_view.dart';
import 'package:kemsu_app/UI/views/info/views/info_view.dart';
import 'package:kemsu_app/UI/views/online_courses/courses_screen.dart';
import 'package:kemsu_app/UI/views/online_courses/widgets/player.dart';
import 'package:kemsu_app/UI/views/ordering_information/ordering_information_main/ordering_information_main_view.dart';
import 'package:kemsu_app/UI/views/payment_web_view/payment.dart';
import 'package:kemsu_app/UI/views/profile_bloc/edit/edit_screen.dart';
import 'package:kemsu_app/UI/views/rating_of_students/views/ros_view.dart';
import 'package:kemsu_app/domain/repositories/authorization/abstract_auth_repository.dart';
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
    GoRoute(name: 'auth', path: '/auth', builder: (context, state) => const NotAuthMenu(), routes: [
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
      builder: (context, state) => const MainMenu(),
    ),
    GoRoute(
      name: 'editProfile',
      path: '/editProfile',
      builder: (context, state) => const EditScreen(),
    ),
    GoRoute(
      name: 'ros',
      path: '/ros',
      builder: (context, state) => const RosView(),
    ),
    GoRoute(
      name: 'infoupro',
      path: '/infoupro',
      builder: (context, state) => const InfoOUProView(),
    ),
    GoRoute(
      name: 'debts',
      path: '/debts',
      builder: (context, state) => const DebtsView(),
    ),
    GoRoute(
      name: 'orderInformation',
      path: '/orderInformation',
      builder: (context, state) => const OrderingInformationMainView(),
    ),
    GoRoute(
      name: 'checkList',
      path: '/checkList',
      builder: (context, state) => const CheckListView(),
    ),
    GoRoute(
      name: 'payment',
      path: '/payment',
      builder: (context, state) => PaymentWebView(authRepository: GetIt.I<AbstractAuthRepository>()),
    ),
    GoRoute(
      name: 'support',
      path: '/support',
      builder: (context, state) => const MainBugReportScreen(),
    ),
    GoRoute(
      name: 'courses',
      path: '/courses',
      builder: (context, state) => OnlineCourseScreen(
        fromAuthMenu: (state.extra as Map<String, dynamic>?)?['fromAuthMenu'],
      ),
    ),
    GoRoute(
      name: 'notAuthMenu',
      path: '/notAuthMenu',
      builder: (context, state) => const NotAuthMenu(),
    ),
    GoRoute(
      name: 'calculation',
      path: '/calculation',
      builder: (context, state) => const CalculationScreen(),
    ),
    GoRoute(
      name: 'player',
      path: '/player',
      builder: (context, state) => PlayerScreen(
        title: (state.extra as Map<String, dynamic>?)?['title'],
        videoUrl: (state.extra as Map<String, dynamic>?)?['videoUrl'],
      ),
    ),
  ],
);

class AppRouting {
  AppRouting._();
  static void back() => appRouter.pop();
  static void toAuth() => appRouter.go('/auth');
  static void toNotAuthMenu() => appRouter.go('/notAuthMenu');
  static void toAuthAlert({String? title, required String body}) => appRouter.go('/auth/alert', extra: {'title': title ?? Localizable.authError, 'body': body});
  static void toMenu() => appRouter.go('/menu');
  static void toMenuPop(context) => popUtil(context, '/menu');
  static void toEditProfile() => appRouter.push('/editProfile');
  static void toRos() => appRouter.push('/ros');
  static void toInfOUPro() => appRouter.push('/infoupro');
  static void toDebts() => appRouter.push('/debts');
  static void toOrderInformation() => appRouter.push('/orderInformation');
  static void toCheckList() => appRouter.push('/checkList');
  static void toPayment() => appRouter.push('/payment');
  static void toSupport() => appRouter.push('/support');
  static void toCourses({bool fromAuthMenu = false}) => appRouter.push('/courses', extra: {"fromAuthMenu": fromAuthMenu});
  static void toCalculation() => appRouter.push('/calculation');
  static void toPlayer({required String title, required String videoUrl}) => appRouter.push('/player', extra: {"title": title, "videoUrl": videoUrl});
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
