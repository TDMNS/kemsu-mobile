import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:kemsu_app/domain/repositories/authorization/abstract_auth_repository.dart';
import 'package:kemsu_app/domain/repositories/authorization/auth_repository.dart';
import 'package:kemsu_app/domain/repositories/schedule/abstract_schedule_repository.dart';
import 'package:kemsu_app/domain/repositories/schedule/schedule_repository.dart';

void diRegister() async {
  Dio dio = Dio();

  GetIt.I.registerLazySingleton<AbstractScheduleRepository>(
    () => ScheduleRepository(
      dio: dio,
    ),
  );

  GetIt.I.registerLazySingleton<AbstractAuthRepository>(
        () => AuthRepository(
      dio: dio,
    ),
  );
}
