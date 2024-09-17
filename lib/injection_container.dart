import 'package:get_it/get_it.dart';
import 'package:pix2life/core/api/api.service.dart';
import 'package:pix2life/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:pix2life/core/services/auth_manager.dart';
import 'package:pix2life/core/services/auth_user_service.dart';
import 'package:pix2life/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:pix2life/features/auth/domain/repositories/auth_repository.dart';
import 'package:pix2life/features/auth/domain/usecases/check_user_account.dart';
import 'package:pix2life/features/auth/domain/usecases/create_user_password.dart';
import 'package:pix2life/features/auth/domain/usecases/user_log_out.dart';
import 'package:pix2life/features/auth/domain/usecases/user_sign_in.dart';
import 'package:pix2life/features/auth/domain/usecases/user_sign_up.dart';
import 'package:pix2life/features/auth/presentation/bloc/auth_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  // Stripe.publishableKey = '${AppConfig.stripePublishableKey}';
  final apiService = ApiService();
  final userService = UserService();
  final authManager = AuthManager();
  serviceLocator.registerLazySingleton(() => apiService);
  serviceLocator.registerLazySingleton(() => userService);
  serviceLocator.registerLazySingleton(() => authManager);
}

void _initAuth() async {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      serviceLocator<AuthManager>(),
      serviceLocator<UserService>(),
    ),
  );

  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(() => AuthBloc(
        userSignUp: serviceLocator<UserSignUp>(),
        userSignIn: serviceLocator<UserSignIn>(),
        checkUserAccount: serviceLocator<CheckUserAccount>(),
        logOutUSer: serviceLocator<LogOutUser>(),
        createUserPassword: serviceLocator<CreateUserPassword>(),
      ));

  serviceLocator.registerFactory<UserSignUp>(
    () => UserSignUp(
      serviceLocator(),
    ),
  );

  serviceLocator.registerFactory<UserSignIn>(
    () => UserSignIn(
      serviceLocator(),
    ),
  );
}
