import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:pix2life/core/network/connection_checker.dart';
import 'package:pix2life/src/features/audio/data/data%20sources/audio_remote_data_source.dart';
import 'package:pix2life/src/features/audio/data/data%20sources/audio_service.dart';
import 'package:pix2life/src/features/audio/data/repositories/audio_repository_impl.dart';
import 'package:pix2life/src/features/audio/domain/repositories/audio_repository.dart';
import 'package:pix2life/src/features/audio/domain/usecases/delete_audio.dart';
import 'package:pix2life/src/features/audio/domain/usecases/fetch_audios.dart';
import 'package:pix2life/src/features/audio/domain/usecases/update_audio.dart';
import 'package:pix2life/src/features/audio/domain/usecases/upload_audio.dart';
import 'package:pix2life/src/features/audio/presentation/bloc/audio_bloc.dart';
import 'package:pix2life/src/features/auth/data/data_source/auth_manager.dart';
import 'package:pix2life/src/api/data/data_source/api.service.dart';
import 'package:pix2life/src/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:pix2life/src/features/auth/data/data_source/auth_service.dart';
import 'package:pix2life/src/features/auth/data/data_source/auth_user_service.dart';
import 'package:pix2life/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:pix2life/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:pix2life/src/features/auth/domain/usecases/get_user_data.dart';
import 'package:pix2life/src/features/auth/domain/usecases/check_user_account.dart';
import 'package:pix2life/src/features/auth/domain/usecases/create_user_password.dart';
import 'package:pix2life/src/features/auth/domain/usecases/payment_stripe.dart';
import 'package:pix2life/src/features/auth/domain/usecases/retrieve_auth_user.dart';
import 'package:pix2life/src/features/auth/domain/usecases/user_log_out.dart';
import 'package:pix2life/src/features/auth/domain/usecases/user_sign_in.dart';
import 'package:pix2life/src/features/auth/domain/usecases/user_sign_up.dart';
import 'package:pix2life/src/features/auth/domain/usecases/verify_user_logged_in.dart';
import 'package:pix2life/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:pix2life/src/features/gallery/data/data_source/gallery_remote_data_source.dart';
import 'package:pix2life/src/features/gallery/data/data_source/gallery_service.dart';
import 'package:pix2life/src/features/gallery/data/repositories/gallery_repository_impl.dart';
import 'package:pix2life/src/features/gallery/domain/repositories/gallery_repository.dart';
import 'package:pix2life/src/features/gallery/domain/usecases/create_gallery.dart';
import 'package:pix2life/src/features/gallery/domain/usecases/fetch_audios.dart';
import 'package:pix2life/src/features/gallery/domain/usecases/fetch_galleries.dart';
import 'package:pix2life/src/features/gallery/domain/usecases/fetch_images.dart';
import 'package:pix2life/src/features/gallery/domain/usecases/fetch_videos.dart';
import 'package:pix2life/src/features/gallery/presentation/bloc/gallery_bloc.dart';
import 'package:pix2life/src/features/image/data/data%20sources/image_remote_data_source.dart';
import 'package:pix2life/src/features/image/data/data%20sources/image_service.dart';
import 'package:pix2life/src/features/image/data/repositories/image_repository_impl.dart';
import 'package:pix2life/src/features/image/domain/repositories/image_repository.dart';
import 'package:pix2life/src/features/image/domain/usecases/delete_image.dart';
import 'package:pix2life/src/features/image/domain/usecases/fetch_images.dart';
import 'package:pix2life/src/features/image/domain/usecases/match_image.dart';
import 'package:pix2life/src/features/image/domain/usecases/update_image.dart';
import 'package:pix2life/src/features/image/domain/usecases/upload_avatar.dart';
import 'package:pix2life/src/features/image/domain/usecases/upload_image.dart';
import 'package:pix2life/src/features/image/presentation/bloc/image_bloc.dart';
import 'package:pix2life/src/features/video/data/data%20sources/video_remote_data_source.dart';
import 'package:pix2life/src/features/video/data/data%20sources/video_service.dart';
import 'package:pix2life/src/features/video/data/repositories/video_repository_impl.dart';
import 'package:pix2life/src/features/video/domain/repositories/video_repository.dart';
import 'package:pix2life/src/features/video/domain/usecases/delete_video.dart';
import 'package:pix2life/src/features/video/domain/usecases/fetch_video.dart';
import 'package:pix2life/src/features/video/domain/usecases/update_video.dart';
import 'package:pix2life/src/features/video/domain/usecases/upload_video.dart';
import 'package:pix2life/src/features/video/presentation/bloc/video_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Register SharedPreferences as a singleton
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  //#######################################################################
  // ############# presentation layer { Application Logic } ###############
  //#######################################################################

  //Authentication Bloc
  sl.registerFactory(
    () => AuthBloc(
      userSignUp: sl(),
      userSignIn: sl(),
      checkUserAccount: sl(),
      logOutUSer: sl(),
      createUserPassword: sl(),
      getUserData: sl(),
      retrieveAuthUser: sl(),
      isUserLoggedIn: sl(),
      stripePayment: sl(),
    ),
  );

  //Audio Files Bloc
  sl.registerFactory(
    () => AudioBloc(
      deleteAudio: sl(),
      fetchAudios: sl(),
      updateAudio: sl(),
      uploadAudio: sl(),
    ),
  );

  //Image Bloc
  sl.registerFactory(
    () => ImageBloc(
      deleteImage: sl(),
      fetchImages: sl(),
      matchImage: sl(),
      updateImage: sl(),
      uploadImage: sl(),
      uploadAvatar: sl(),
    ),
  );

  //Video Bloc
  sl.registerFactory(
    () => VideoBloc(
      deleteVideo: sl(),
      fetchVideo: sl(),
      updateVideo: sl(),
      uploadVideo: sl(),
    ),
  );

  //Galley Bloc
  sl.registerFactory(
    () => GalleryBloc(
      createGallery: sl(),
      fetchGalleries: sl(),
      fetchImagesByGallery: sl(),
      fetchAudiosByGallery: sl(),
      fetchVideosByGallery: sl(),
    ),
  );
  //#######################################################################
  //#################### domain layer { Usecases } ########################
  //#######################################################################

  //Authentication usecases
  sl.registerLazySingleton(() => UserSignUp(sl()));
  sl.registerLazySingleton(() => UserSignIn(sl()));
  sl.registerLazySingleton(() => GetUserData(sl()));
  sl.registerLazySingleton(() => LogOutUser(sl()));
  sl.registerLazySingleton(() => CreateUserPassword(sl()));
  sl.registerLazySingleton(() => CheckUserAccount(sl()));
  sl.registerLazySingleton(() => RetrieveAuthUser(sl()));
  sl.registerLazySingleton(() => IsUserLoggedIn(sl()));
  sl.registerLazySingleton(() => StripePayment(sl()));

  //Audio usecases
  sl.registerLazySingleton(() => DeleteAudio(sl()));
  sl.registerLazySingleton(() => FetchAudios(sl()));
  sl.registerLazySingleton(() => UpdateAudio(sl()));
  sl.registerLazySingleton(() => UploadAudio(sl()));

  //Image usecases
  sl.registerLazySingleton(() => DeleteImage(sl()));
  sl.registerLazySingleton(() => FetchImages(sl()));
  sl.registerLazySingleton(() => MatchImage(sl()));
  sl.registerLazySingleton(() => UpdateImage(sl()));
  sl.registerLazySingleton(() => UploadAvatar(sl()));
  sl.registerLazySingleton(() => UploadImage(sl()));

  //Video usecases
  sl.registerLazySingleton(() => DeleteVideo(sl()));
  sl.registerLazySingleton(() => FetchVideo(sl()));
  sl.registerLazySingleton(() => UpdateVideo(sl()));
  sl.registerLazySingleton(() => UploadVideo(sl()));

  //Gallery usecases
  sl.registerLazySingleton(() => CreateGallery(sl()));
  sl.registerLazySingleton(() => FetchAudiosByGallery(sl()));
  sl.registerLazySingleton(() => FetchVideosByGallery(sl()));
  sl.registerLazySingleton(() => FetchImagesByGallery(sl()));
  sl.registerLazySingleton(() => FetchGalleries(sl()));

  //#######################################################################
  //##########################  data layer { repositories } ###############
  //#######################################################################

  //Authentication Bloc
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl(), sl(), sl()));

  // Audio Bloc
  sl.registerLazySingleton<AudioRepository>(() => AudioRepositoryImpl(sl()));
  sl.registerLazySingleton<AudioRemoteDataSource>(
      () => AudioRemoteDataSourceImpl(sl()));

  // Image Bloc
  sl.registerLazySingleton<ImageRepository>(() => ImageRepositoryImpl(sl()));
  sl.registerLazySingleton<ImageRemoteDataSource>(
      () => ImageRemoteDataSourceImpl(sl()));

  // Video Bloc
  sl.registerLazySingleton<VideoRepository>(() => VideoRepositoryImpl(sl()));
  sl.registerLazySingleton<VideoRemoteDataSource>(
      () => VideoRemoteDataSourceImpl(sl()));

  // Gallery Bloc
  sl.registerLazySingleton<GalleryRepository>(
      () => GalleryRepositoryImpl(sl()));
  sl.registerLazySingleton<GalleryRemoteDataSource>(
      () => GalleryRemoteDataSourceImpl(sl()));

  //#######################################################################
  //##################### data source external dependencies ###############
  //#######################################################################

  //Authentication Bloc
  sl.registerLazySingleton(() => AuthManager(sl()));
  sl.registerLazySingleton(() => AuthService(sl()));
  sl.registerLazySingleton(() => UserService(sl()));

  //Audio Bloc
  sl.registerLazySingleton(() => AudioService(sl()));

  //Image Bloc
  sl.registerLazySingleton(() => ImageService(sl()));

  //Video bloc
  sl.registerLazySingleton(() => VideoService(sl()));

  //Gallery Bloc
  sl.registerLazySingleton(() => GalleryService(sl()));

  //Api Service class
  sl.registerLazySingleton(() => ApiService(sl(), sl()));

  //connection checker class
  sl.registerFactory<ConnectionChecker>(() => ConnectionCheckerImpl(sl()));

  //Flutter Technology dependencies
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage());
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton(() => InternetConnection());

  try {
    await sl.allReady(); // Wait for all async initializations to complete
  } catch (e) {
    // Handle initialization failure, maybe log or retry
    // ignore: avoid_print
    print(e.toString());
  }
}
