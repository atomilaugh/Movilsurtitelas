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
      tipoCliente: TipoCliente.values.firstWhere(
        (e) => e.name == json['tipoCliente'],
        orElse: () => TipoCliente.minorista,
      ),
      totalCompras: (json['totalCompras'] ?? 0).toDouble(),
      pedidosRealizados: json['pedidosRealizados'] ?? 0,
      fechaRegistro: json['fechaRegistro'] != null 
          ? DateTime.parse(json['fechaRegistro']) 
          : DateTime.now(),
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

  Cliente copyWith({
    String? id,
    String? nombre,
    String? telefono,
    String? email,
    String? direccion,
    String? ciudad,
    TipoCliente? tipoCliente,
    double? totalCompras,
    int? pedidosRealizados,
    DateTime? fechaRegistro,
  }) {
    return Cliente(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      telefono: telefono ?? this.telefono,
      email: email ?? this.email,
      direccion: direccion ?? this.direccion,
      ciudad: ciudad ?? this.ciudad,
      tipoCliente: tipoCliente ?? this.tipoCliente,
      totalCompras: totalCompras ?? this.totalCompras,
      pedidosRealizados: pedidosRealizados ?? this.pedidosRealizados,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
    );
  }

  @override
  List<Object?> get props => [
        id,
        nombre,
        telefono,
        email,
        direccion,
        ciudad,
        tipoCliente,
        totalCompras,
        pedidosRealizados,
        fechaRegistro,
      ];
}