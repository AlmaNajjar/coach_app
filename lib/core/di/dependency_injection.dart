import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../networking/dio_factory.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // Global Navigator Key
  getIt.registerSingleton<GlobalKey<NavigatorState>>(
    GlobalKey<NavigatorState>(),
  );

  // Dio client singleton
  getIt.registerLazySingleton<Dio>(() => DioFactory.getDio());

  // سنقوم بإضافة الـ AuthRepo والـ AuthCubit للكوتش هنا بمجرد كتابتهما فوراً
}
