import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:rankah/core/api/dio_consumer.dart';
import 'package:rankah/core/cache/cache_helper.dart';
import 'package:rankah/feature/authentication/data/repo/authRepo.dart';
import 'package:rankah/feature/authentication/data/repo/authRepoImp.dart';
import 'package:rankah/feature/authentication/logic/cubit/login_cubit.dart';
import 'package:rankah/feature/authentication/logic/cubit/sign_up_cubit.dart';
import 'package:rankah/feature/home/data/home_repository.dart';
import 'package:rankah/feature/home/logic/cubit/home_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> init() async {
  final cacheHelper = CacheHelper();
  await cacheHelper.init();
  getIt.registerLazySingleton<CacheHelper>(() => cacheHelper);

  getIt.registerLazySingleton<Dio>(() => Dio(
        BaseOptions(
          baseUrl: 'https://raknah.runasp.net/',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      ));

  //DioConsumer (API handler)
  getIt
      .registerLazySingleton<DioConsumer>(() => DioConsumer(dio: getIt<Dio>()));

  //  Repository
  getIt.registerLazySingleton<AuthRepo>(
      () => AuthRepoImp(apiConsumer: getIt<DioConsumer>()));
  getIt.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(apiConsumer: getIt<DioConsumer>()));

  //  Cubits
  getIt.registerFactory(() => SignUpCubit(authRepo: getIt<AuthRepo>()));
  getIt.registerFactory(() => LoginCubit(authRepo: getIt<AuthRepo>()));
  getIt.registerFactory(
      () => HomeCubit(homeRepository: getIt<HomeRepository>()));
}
