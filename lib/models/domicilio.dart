import 'package:equatable/equatable.dart';

enum EstadoDomicilio { pendiente, enCamino, entregado, fallido }

class Domicilio extends Equatable {
  final String id;
  final String pedidoId;
  final String clienteNombre;
  final String direccion;
  final String ciudad;
  final String? repartidorId;
  final String? repartidorNombre;
  final EstadoDomicilio estado;
  final DateTime? fechaAsignacion;
  final DateTime? fechaEntrega;
  final String? observaciones;

  const Domicilio({
    required this.id,
    required this.pedidoId,
    required this.clienteNombre,
    required this.direccion,
    required this.ciudad,
    this.repartidorId,
    this.repartidorNombre,
    required this.estado,
    this.fechaAsignacion,
    this.fechaEntrega,
    this.observaciones,
  });

  factory Domicilio.fromJson(Map<String, dynamic> json) {
    return Domicilio(
      id: json['id'],
      pedidoId: json['pedidoId'],
      clienteNombre: json['clienteNombre'],
      direccion: json['direccion'],
      ciudad: json['ciudad'],
      repartidorId: json['repartidorId'],
      repartidorNombre: json['repartidorNombre'],
      estado: EstadoDomicilio.values.firstWhere((e) => e.name == json['estado']),
      fechaAsignacion: json['fechaAsignacion'] != null ? DateTime.parse(json['fechaAsignacion']) : null,
      fechaEntrega: json['fechaEntrega'] != null ? DateTime.parse(json['fechaEntrega']) : null,
      observaciones: json['observaciones'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pedidoId': pedidoId,
      'clienteNombre': clienteNombre,
      'direccion': direccion,
      'ciudad': ciudad,
      'repartidorId': repartidorId,
      'repartidorNombre': repartidorNombre,
      'estado': estado.name,
      'fechaAsignacion': fechaAsignacion?.toIso8601String(),
      'fechaEntrega': fechaEntrega?.toIso8601String(),
      'observaciones': observaciones,
    };
  }

  @override
  List<Object?> get props => [id, pedidoId, clienteNombre, direccion, ciudad, repartidorId, repartidorNombre, estado, fechaAsignacion, fechaEntrega, observaciones];
}
