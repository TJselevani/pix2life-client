import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:pix2life/src/auth/data/data_source/auth_manager.dart';
import 'package:pix2life/src/api/data/data_source/api.service.dart';
import 'package:pix2life/src/auth/data/data_source/auth_remote_data_source.dart';
import 'package:pix2life/src/auth/data/data_source/auth_user_service.dart';
import 'package:pix2life/src/auth/data/repositories/auth_repository_impl.dart';
import 'package:pix2life/src/auth/domain/repositories/auth_repository.dart';
import 'package:pix2life/src/auth/domain/usecases/check_auth_status.dart';
import 'package:pix2life/src/auth/domain/usecases/check_user_account.dart';
import 'package:pix2life/src/auth/domain/usecases/create_user_password.dart';
import 'package:pix2life/src/auth/domain/usecases/user_log_out.dart';
import 'package:pix2life/src/auth/domain/usecases/user_sign_in.dart';
import 'package:pix2life/src/auth/domain/usecases/user_sign_up.dart';
import 'package:pix2life/src/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  //presentation layer { Application Logic}
  sl.registerFactory(
    () => AuthBloc(
      userSignUp: sl(),
      userSignIn: sl(),
      checkUserAccount: sl(),
      logOutUSer: sl(),
      createUserPassword: sl(),
      checkAuthStatus: sl(),
    ),
  );

  //domain layer { Usecases }
  sl.registerLazySingleton(() => UserSignUp(sl()));
  sl.registerLazySingleton(() => UserSignIn(sl()));
  sl.registerLazySingleton(() => CheckAuthStatus(sl()));
  sl.registerLazySingleton(() => LogOutUser(sl()));
  sl.registerLazySingleton(() => CreateUserPassword(sl()));
  sl.registerLazySingleton(() => CheckUserAccount(sl()));

  //data layer { repositories }
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl(), sl()));

  //data source external dependencies
  sl.registerLazySingleton(() => AuthManager());
  sl.registerLazySingleton(() => UserService(sl()));

  sl.registerLazySingleton(() => ApiService(sl(), sl()));

  //
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => const FlutterSecureStorage());
}
