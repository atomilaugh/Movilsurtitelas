import 'package:equatable/equatable.dart';

enum TipoCliente { mayorista, minorista }

class Cliente extends Equatable {
  final String id;
  final String nombre;
  final String telefono;
  final String? email;
  final String direccion;
  final String ciudad;
  final TipoCliente tipoCliente;
  final double totalCompras;
  final int pedidosRealizados;
  final DateTime fechaRegistro;

  const Cliente({
    required this.id,
    required this.nombre,
    required this.telefono,
    this.email,
    required this.direccion,
    required this.ciudad,
    required this.tipoCliente,
    required this.totalCompras,
    required this.pedidosRealizados,
    required this.fechaRegistro,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nombre: json['nombre'],
      telefono: json['telefono'],
      email: json['email'],
      direccion: json['direccion'],
      ciudad: json['ciudad'],
      tipoCliente: TipoCliente.values.firstWhere((e) => e.name == json['tipoCliente']),
      totalCompras: json['totalCompras'].toDouble(),
      pedidosRealizados: json['pedidosRealizados'],
      fechaRegistro: DateTime.parse(json['fechaRegistro']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'telefono': telefono,
      'email': email,
      'direccion': direccion,
      'ciudad': ciudad,
      'tipoCliente': tipoCliente.name,
      'totalCompras': totalCompras,
      'pedidosRealizados': pedidosRealizados,
      'fechaRegistro': fechaRegistro.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, nombre, telefono, email, direccion, ciudad, tipoCliente, totalCompras, pedidosRealizados, fechaRegistro];
}
