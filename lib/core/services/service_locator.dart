import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:rankah/core/api/dio_consumer.dart';
import 'package:rankah/core/cache/cache_helper.dart';
import 'package:rankah/core/network/dio_helper.dart';
import 'package:rankah/feature/authentication/data/repo/authRepo.dart';
import 'package:rankah/feature/authentication/data/repo/authRepoImp.dart';
import 'package:rankah/feature/authentication/data/repo/forgot_password_repository.dart';
import 'package:rankah/feature/authentication/logic/cubit/forget_password_cubit.dart';
import 'package:rankah/feature/authentication/logic/cubit/login_cubit.dart';
import 'package:rankah/feature/authentication/logic/cubit/sign_up_cubit.dart';
import 'package:rankah/feature/profile/data/profile_repo.dart';
import 'package:rankah/feature/profile/logic/cubit/profile_cubit.dart';
import 'package:rankah/feature/history/logic/cubit/history_cubit.dart';
import 'package:rankah/feature/reservation/logic/cubit/reservation_cubit.dart';
import 'package:rankah/feature/home/data/home_repository.dart';
import 'package:rankah/feature/home/logic/cubit/home_cubit.dart';
import 'package:rankah/feature/home/data/pending_reservation_repository.dart';
import 'package:rankah/feature/home/logic/cubit/pending_reservation_cubit.dart';

final GetIt getIt = GetIt.instance;
final sl = getIt;

Future<void> init() async {
  print('Service locator: Starting initialization');

  // Local Cache
  final cacheHelper = CacheHelper();
  await cacheHelper.init();
  getIt.registerLazySingleton<CacheHelper>(() => cacheHelper);
  print('Service locator: CacheHelper registered');

  // Initialize Dio + Auth Interceptor
  await DioHelper.init();
  getIt.registerLazySingleton<Dio>(() => DioHelper.dio);
  print('Service locator: Dio registered');

  //  Dio Consumer
  getIt
      .registerLazySingleton<DioConsumer>(() => DioConsumer(dio: getIt<Dio>()));
  print('Service locator: DioConsumer registered');

  // Repositories
  getIt.registerLazySingleton<AuthRepo>(
      () => AuthRepoImp(apiConsumer: getIt<DioConsumer>()));
  print('Service locator: AuthRepo registered');

  getIt.registerLazySingleton<ProfileRepository>(
      () => ProfileRepository(api: getIt<DioConsumer>()));
  print('Service locator: ProfileRepository registered');

  getIt.registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(apiConsumer: getIt<DioConsumer>()));
  print('Service locator: HomeRepository registered');

  getIt.registerLazySingleton<PendingReservationRepository>(() =>
      PendingReservationRepositoryImpl(apiConsumer: getIt<DioConsumer>()));
  print('Service locator: PendingReservationRepository registered');

  // Cubits
  getIt.registerFactory(() => SignUpCubit(authRepo: getIt<AuthRepo>()));
  print('Service locator: SignUpCubit registered');

  getIt.registerFactory(() => LoginCubit(authRepo: getIt<AuthRepo>()));
  print('Service locator: LoginCubit registered');

  getIt.registerLazySingleton<ForgotPasswordRepository>(
      () => ForgotPasswordRepository(getIt<Dio>()));
  print('Service locator: ForgotPasswordRepository registered');

  getIt.registerFactory(
      () => ForgotPasswordCubit(getIt<ForgotPasswordRepository>()));
  print('Service locator: ForgotPasswordCubit registered');

  getIt.registerFactory(
      () => ProfileCubit(repository: getIt<ProfileRepository>()));
  print('Service locator: ProfileCubit registered');

  getIt.registerFactory(() => HistoryCubit());
  print('Service locator: HistoryCubit registered');

  getIt.registerFactory(() => ReservationCubit());
  print('Service locator: ReservationCubit registered');

  getIt.registerFactory(
      () => HomeCubit(homeRepository: getIt<HomeRepository>()));
  print('Service locator: HomeCubit registered');

  getIt.registerFactory(() => PendingReservationCubit(
      pendingReservationRepository: getIt<PendingReservationRepository>()));
  print('Service locator: PendingReservationCubit registered');

  print('Service locator: Initialization completed successfully');
}
