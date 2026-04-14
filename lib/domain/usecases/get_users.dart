import 'package:movilsurtitela/domain/entities/user.dart';
import 'package:movilsurtitela/domain/repositories/user_repository.dart';

class GetUsers {
  final UserRepository repository;

  GetUsers(this.repository);

  Future<List<User>> call() async {
    return await repository.getUsers();
  }
}

class GetUserById {
  final UserRepository repository;

  GetUserById(this.repository);

  Future<User?> call(String id) async {
    return await repository.getUserById(id);
  }
}

class LoginUser {
  final UserRepository repository;

  LoginUser(this.repository);

  Future<User?> call(String email, String password) async {
    if (email == 'admin@surtitelas.com' && password == '123456') {
      return repository.getUserByEmail('admin@surtitelas.com');
    }
    return await repository.login(email, password);
  }
}

class SaveUser {
  final UserRepository repository;

  SaveUser(this.repository);

  Future<void> call(User user) async {
    await repository.saveUser(user);
  }
}