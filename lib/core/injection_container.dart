import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:movilsurtitela/data/datasources/user_remote_datasource.dart';
import 'package:movilsurtitela/data/repositories/user_repository_impl.dart';
import 'package:movilsurtitela/domain/repositories/user_repository.dart';
import 'package:movilsurtitela/domain/usecases/get_users.dart';
import 'package:movilsurtitela/presentation/blocs/user/user_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC
  sl.registerFactory(() => UserBloc(getUsers: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetUsers(sl()));
  sl.registerLazySingleton(() => GetUserById(sl()));
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => SaveUser(sl()));

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(client: sl()),
  );

  // External
  sl.registerLazySingleton(() => http.Client());
}