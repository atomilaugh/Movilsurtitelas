import 'package:movilsurtitela/domain/entities/user.dart';

abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<User?> getUserById(String id);
  Future<User?> getUserByEmail(String email);
  Future<void> saveUser(User user);
  Future<void> deleteUser(String id);
  Future<User?> login(String email, String password);
}