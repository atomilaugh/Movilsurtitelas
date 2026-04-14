import 'package:flutter/material.dart';
import 'package:movilsurtitela/domain/entities/user.dart';

class UserList extends StatelessWidget {
  final List<User> users;

  const UserList({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          title: Text(user.name),
          subtitle: Text(user.email),
        );
      },
    );
  }
}