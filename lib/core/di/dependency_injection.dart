import 'package:coach_app/features/clients/data/datasource/clients_remote_data_source.dart';
import 'package:coach_app/features/clients/domain/repo/clients_repo.dart';
import 'package:coach_app/features/clients/domain/repo/clients_repo_impl.dart';
import 'package:coach_app/features/clients/domain/use_case/get_clients_use_case.dart';
import 'package:coach_app/features/clients/presentation/cubit/clients_cubit.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:coach_app/features/home/data/datasources/coach_subscribers_remote_data_source.dart';
import 'package:coach_app/features/home/data/repositories/coach_subscribers_repository_impl.dart';
import 'package:coach_app/features/home/domain/repositories/coach_subscribers_repository.dart';
import 'package:coach_app/features/home/domain/use_cases/get_coach_subscribers_use_case.dart';
import 'package:coach_app/features/home/presentation/cubit/coach_subscribers_cubit.dart';
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
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<LoginUseCase>()));
  getIt.registerLazySingleton<CoachProfileRemoteDataSource>(
    () => CoachProfileRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<CoachProfileRepository>(
    () => CoachProfileRepositoryImpl(getIt<CoachProfileRemoteDataSource>()),
  );
  getIt.registerLazySingleton<GetCoachProfileUseCase>(
    () => GetCoachProfileUseCase(getIt<CoachProfileRepository>()),
  );
  getIt.registerFactory<CoachProfileCubit>(
    () => CoachProfileCubit(
      getIt<GetCoachProfileUseCase>(),
      getIt<CoachProfileRemoteDataSource>(),
    ),
  );
  // Clients Feature
  getIt.registerLazySingleton<ClientsRemoteDataSource>(
    () => ClientsRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<ClientsRepository>(
    () => ClientsRepositoryImpl(getIt<ClientsRemoteDataSource>()),
  );
  getIt.registerLazySingleton<GetClientsUseCase>(
    () => GetClientsUseCase(getIt<ClientsRepository>()),
  );
  getIt.registerFactory<ClientsCubit>(
    () => ClientsCubit(getIt<GetClientsUseCase>()),
  );
  // Coach subscribers
  getIt.registerLazySingleton<CoachSubscribersRemoteDataSource>(
    () => CoachSubscribersRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<CoachSubscribersRepository>(
    () => CoachSubscribersRepositoryImpl(
      getIt<CoachSubscribersRemoteDataSource>(),
    ),
  );
  getIt.registerLazySingleton<GetCoachSubscribersUseCase>(
    () => GetCoachSubscribersUseCase(getIt<CoachSubscribersRepository>()),
  );
  getIt.registerFactory<CoachSubscribersCubit>(
    () => CoachSubscribersCubit(getIt<GetCoachSubscribersUseCase>()),
  );
}
