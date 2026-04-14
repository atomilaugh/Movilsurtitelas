import 'package:equatable/equatable.dart';

enum EstadoDevolucion { solicitada, enRevision, aprobada, rechazada, completada }

class ProductoDevolucion extends Equatable {
  final String productoNombre;
  final int cantidad;

  const ProductoDevolucion({
    required this.productoNombre,
    required this.cantidad,
  });

  factory ProductoDevolucion.fromJson(Map<String, dynamic> json) {
    return ProductoDevolucion(
      productoNombre: json['productoNombre'],
      cantidad: json['cantidad'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productoNombre': productoNombre,
      'cantidad': cantidad,
    };
  }

  @override
  List<Object?> get props => [productoNombre, cantidad];
}

class Devolucion extends Equatable {
  final String id;
  final String pedidoId;
  final String clienteNombre;
  final String motivo;
  final List<ProductoDevolucion> productos;
  final EstadoDevolucion estado;
  final String? evidencia;
  final DateTime fechaSolicitud;
  final String? resolucion;

  const Devolucion({
    required this.id,
    required this.pedidoId,
    required this.clienteNombre,
    required this.motivo,
    required this.productos,
    required this.estado,
    this.evidencia,
    required this.fechaSolicitud,
    this.resolucion,
  });

  factory Devolucion.fromJson(Map<String, dynamic> json) {
    return Devolucion(
      id: json['id'],
      pedidoId: json['pedidoId'],
      clienteNombre: json['clienteNombre'],
      motivo: json['motivo'],
      productos: (json['productos'] as List).map((p) => ProductoDevolucion.fromJson(p)).toList(),
      estado: EstadoDevolucion.values.firstWhere((e) => e.name == json['estado']),
      evidencia: json['evidencia'],
      fechaSolicitud: DateTime.parse(json['fechaSolicitud']),
      resolucion: json['resolucion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pedidoId': pedidoId,
      'clienteNombre': clienteNombre,
      'motivo': motivo,
      'productos': productos.map((p) => p.toJson()).toList(),
      'estado': estado.name,
      'evidencia': evidencia,
      'fechaSolicitud': fechaSolicitud.toIso8601String(),
      'resolucion': resolucion,
    };
  }

  @override
  List<Object?> get props => [id, pedidoId, clienteNombre, motivo, productos, estado, evidencia, fechaSolicitud, resolucion];
}
