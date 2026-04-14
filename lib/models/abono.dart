import 'package:equatable/equatable.dart';

enum MetodoPago { efectivo, transferencia, tarjeta }

class Abono extends Equatable {
  final String id;
  final String pedidoId;
  final String clienteNombre;
  final double monto;
  final MetodoPago metodoPago;
  final String? comprobante;
  final DateTime fecha;
  final String registradoPor;

  const Abono({
    required this.id,
    required this.pedidoId,
    required this.clienteNombre,
    required this.monto,
    required this.metodoPago,
    this.comprobante,
    required this.fecha,
    required this.registradoPor,
  });

  factory Abono.fromJson(Map<String, dynamic> json) {
    return Abono(
      id: json['id'],
      pedidoId: json['pedidoId'],
      clienteNombre: json['clienteNombre'],
      monto: json['monto'].toDouble(),
      metodoPago: MetodoPago.values.firstWhere((e) => e.name == json['metodoPago']),
      comprobante: json['comprobante'],
      fecha: DateTime.parse(json['fecha']),
      registradoPor: json['registradoPor'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pedidoId': pedidoId,
      'clienteNombre': clienteNombre,
      'monto': monto,
      'metodoPago': metodoPago.name,
      'comprobante': comprobante,
      'fecha': fecha.toIso8601String(),
      'registradoPor': registradoPor,
    };
  }

  @override
  List<Object?> get props => [id, pedidoId, clienteNombre, monto, metodoPago, comprobante, fecha, registradoPor];
}
