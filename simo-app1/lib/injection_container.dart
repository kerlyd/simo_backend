import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simo_app/data/datasources/auth_remote_datasource.dart';
import 'package:simo_app/data/repositories/auth_repository_impl.dart';
import 'package:simo_app/domain/repositories/auth_repository.dart';
import 'package:simo_app/domain/usecases/login_usecase.dart';
import 'package:simo_app/domain/usecases/register_usecase.dart';
import 'package:simo_app/data/datasources/dispositivo_remote_datasource.dart';
import 'package:simo_app/data/datasources/recompensa_remote_datasource.dart';
import 'package:simo_app/data/datasources/punto_reciclaje_remote_datasource.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<DispositivoRemoteDataSource>(
    () => DispositivoRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<RecompensaRemoteDataSource>(
    () => RecompensaRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<PuntoReciclajeRemoteDataSource>(
    () => PuntoReciclajeRemoteDataSourceImpl(sl()),
  );

  final dio = Dio(BaseOptions(
    baseUrl: 'https://simobackend-production.up.railway.app',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    },
  ));

  sl.registerLazySingleton(() => dio);
}
