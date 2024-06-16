import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:kemsu_app/domain/repositories/authorization/abstract_auth_repository.dart';
import 'package:kemsu_app/domain/repositories/authorization/auth_repository.dart';
import 'package:kemsu_app/domain/repositories/features/abstract_features_repository.dart';
import 'package:kemsu_app/domain/repositories/features/features_repositories.dart';
import 'package:kemsu_app/domain/repositories/schedule/abstract_schedule_repository.dart';
import 'package:kemsu_app/domain/repositories/schedule/schedule_repository.dart';

import 'dio_wrapper/dio_client.dart';

void diRegister() async {
  final dio = Dio();
  final dioClient = DioClient(dio);

  GetIt.I.registerLazySingleton<AbstractScheduleRepository>(
    () => ScheduleRepository(
      dio: dioClient,
    ),
  );

  GetIt.I.registerLazySingleton<AbstractAuthRepository>(
    () => AuthRepository(
      dio: dioClient,
    ),
  );

  GetIt.I.registerLazySingleton<AbstractFeaturesRepository>(
    () => FeatureRepository(),
  );
}
