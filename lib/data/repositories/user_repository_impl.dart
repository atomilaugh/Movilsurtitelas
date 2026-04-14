import 'package:movilsurtitela/data/datasources/user_remote_datasource.dart';
import 'package:movilsurtitela/data/models/user_model.dart';
import 'package:movilsurtitela/domain/entities/user.dart';
import 'package:movilsurtitela/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<User>> getUsers() async {
    final userModels = await remoteDataSource.getUsers();
    return userModels;
  }

  @override
  Future<User?> getUserById(String id) async {
    return await remoteDataSource.getUserById(id);
  }

  @override
  Future<User?> getUserByEmail(String email) async {
    final users = await remoteDataSource.getUsers();
    try {
      return users.firstWhere((u) => u.email.toLowerCase() == email.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveUser(User user) async {
    await remoteDataSource.saveUser(UserModel.fromEntity(user));
  }

  @override
  Future<void> deleteUser(String id) async {
    await remoteDataSource.deleteUser(id);
  }

  @override
  Future<User?> login(String email, String password) async {
    final user = await getUserByEmail(email);
    if (user != null) {
      return user;
    }
    return null;
  }
}