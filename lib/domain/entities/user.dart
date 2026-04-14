import 'package:equatable/equatable.dart';

enum UserRole { admin, asesor, bodeguero, repartidor, cliente }

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String phone;
  final String? avatar;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.phone,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.cliente,
      ),
      phone: json['phone'] ?? '',
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.name,
      'phone': phone,
      'avatar': avatar,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    String? phone,
    String? avatar,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
    );
  }

  bool get isAdmin => role == UserRole.admin;
  bool get isAsesor => role == UserRole.asesor;
  bool get isBodeguero => role == UserRole.bodeguero;
  bool get isRepartidor => role == UserRole.repartidor;
  bool get isCliente => role == UserRole.cliente;

  @override
  List<Object?> get props => [id, name, email, role, phone, avatar];
}