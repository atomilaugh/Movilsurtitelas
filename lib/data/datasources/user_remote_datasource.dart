import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movilsurtitela/data/models/user_model.dart';

abstract class UserRemoteDataSource {
  Future<List<UserModel>> getUsers();
  Future<UserModel?> getUserById(String id);
  Future<void> saveUser(UserModel user);
  Future<void> deleteUser(String id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final http.Client client;

  UserRemoteDataSourceImpl({required this.client});

  @override
  Future<List<UserModel>> getUsers() async {
    final response = await client.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));

    if (response.statusCode == 200) {
      final List<dynamic> userJson = json.decode(response.body);
      return userJson.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Future<UserModel?> getUserById(String id) async {
    final response = await client.get(Uri.parse('https://jsonplaceholder.typicode.com/users/$id'));

    if (response.statusCode == 200) {
      return UserModel.fromJson(json.decode(response.body));
    }
    return null;
  }

  @override
  Future<void> saveUser(UserModel user) async {
    await client.post(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );
  }

  @override
  Future<void> deleteUser(String id) async {
    await client.delete(Uri.parse('https://jsonplaceholder.typicode.com/users/$id'));
  }
}