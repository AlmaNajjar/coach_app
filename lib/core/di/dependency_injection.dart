import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:coach_app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:coach_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:coach_app/features/auth/data/repos/auth_repo_impl.dart';
import 'package:coach_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:coach_app/features/auth/domain/use_cases/login_use_case.dart';
import 'package:coach_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:coach_app/features/home/data/datasources/coach_profile_remote_data_source.dart';
import 'package:coach_app/features/home/data/repositories/coach_profile_repository_impl.dart';
import 'package:coach_app/features/home/domain/repositories/coach_profile_repository.dart';
import 'package:coach_app/features/home/domain/use_cases/get_coach_profile_use_case.dart';
import 'package:coach_app/features/home/presentation/cubit/coach_profile_cubit.dart';
import '../networking/dio_factory.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Global Navigator Key
  getIt.registerSingleton<GlobalKey<NavigatorState>>(
    GlobalKey<NavigatorState>(),
  );

  // Dio client singleton
  getIt.registerLazySingleton<Dio>(() => DioFactory.getDio());

  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      localDataSource: getIt<AuthLocalDataSource>(),
    ),
  );
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(getIt<LoginUseCase>()),
  );
  getIt.registerLazySingleton<CoachProfileRemoteDataSource>(
    () => CoachProfileRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<CoachProfileRepository>(
    () => CoachProfileRepositoryImpl(
      getIt<CoachProfileRemoteDataSource>(),
    ),
  );
  getIt.registerLazySingleton<GetCoachProfileUseCase>(
    () => GetCoachProfileUseCase(getIt<CoachProfileRepository>()),
  );
  getIt.registerFactory<CoachProfileCubit>(
    () => CoachProfileCubit(getIt<GetCoachProfileUseCase>()),
  );
}
