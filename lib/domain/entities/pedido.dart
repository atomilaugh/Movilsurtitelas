import 'package:equatable/equatable.dart';

enum EstadoPedido {
  recibido,
  enProduccion,
  enCorte,
  enConfeccion,
  enEstampado,
  listo,
  enviado,
  entregado,
  cancelado
}

class ItemPedido extends Equatable {
  final String productoId;
  final String productoNombre;
  final int cantidad;
  final String talla;
  final String color;
  final double precioUnitario;
  final double subtotal;

  const ItemPedido({
    required this.productoId,
    required this.productoNombre,
    required this.cantidad,
    required this.talla,
    required this.color,
    required this.precioUnitario,
    required this.subtotal,
  });

  factory ItemPedido.fromJson(Map<String, dynamic> json) {
    return ItemPedido(
      productoId: json['productoId'] ?? '',
      productoNombre: json['productoNombre'] ?? '',
      cantidad: json['cantidad'] ?? 0,
      talla: json['talla'] ?? '',
      color: json['color'] ?? '',
      precioUnitario: (json['precioUnitario'] ?? 0).toDouble(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productoId': productoId,
      'productoNombre': productoNombre,
      'cantidad': cantidad,
      'talla': talla,
      'color': color,
      'precioUnitario': precioUnitario,
      'subtotal': subtotal,
    };
  }

  @override
  List<Object?> get props => [
        productoId,
        productoNombre,
        cantidad,
        talla,
        color,
        precioUnitario,
        subtotal,
      ];
}

class Pedido extends Equatable {
  final String id;
  final String clienteId;
  final String clienteNombre;
  final List<ItemPedido> items;
  final double total;
  final double abonado;
  final double saldo;
  final EstadoPedido estado;
  final DateTime fechaCreacion;
  final DateTime fechaEntregaEstimada;
  final String asesorId;
  final String asesorNombre;
  final String? observaciones;

  const Pedido({
    required this.id,
    required this.clienteId,
    required this.clienteNombre,
    required this.items,
    required this.total,
    required this.abonado,
    required this.saldo,
    required this.estado,
    required this.fechaCreacion,
    required this.fechaEntregaEstimada,
    required this.asesorId,
    required this.asesorNombre,
    this.observaciones,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'] ?? '',
      clienteId: json['clienteId'] ?? '',
      clienteNombre: json['clienteNombre'] ?? '',
      items: (json['items'] as List?)
              ?.map((i) => ItemPedido.fromJson(i))
              .toList() ??
          [],
      total: (json['total'] ?? 0).toDouble(),
      abonado: (json['abonado'] ?? 0).toDouble(),
      saldo: (json['saldo'] ?? 0).toDouble(),
      estado: EstadoPedido.values.firstWhere(
        (e) => e.name == json['estado'],
        orElse: () => EstadoPedido.recibido,
      ),
      fechaCreacion: json['fechaCreacion'] != null
          ? DateTime.parse(json['fechaCreacion'])
          : DateTime.now(),
      fechaEntregaEstimada: json['fechaEntregaEstimada'] != null
          ? DateTime.parse(json['fechaEntregaEstimada'])
          : DateTime.now().add(const Duration(days: 7)),
      asesorId: json['asesorId'] ?? '',
      asesorNombre: json['asesorNombre'] ?? '',
      observaciones: json['observaciones'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clienteId': clienteId,
      'clienteNombre': clienteNombre,
      'items': items.map((i) => i.toJson()).toList(),
      'total': total,
      'abonado': abonado,
      'saldo': saldo,
      'estado': estado.name,
      'fechaCreacion': fechaCreacion.toIso8601String(),
      'fechaEntregaEstimada': fechaEntregaEstimada.toIso8601String(),
      'asesorId': asesorId,
      'asesorNombre': asesorNombre,
      'observaciones': observaciones,
    };
  }

  Pedido copyWith({
    String? id,
    String? clienteId,
    String? clienteNombre,
    List<ItemPedido>? items,
    double? total,
    double? abonado,
    double? saldo,
    EstadoPedido? estado,
    DateTime? fechaCreacion,
    DateTime? fechaEntregaEstimada,
    String? asesorId,
    String? asesorNombre,
    String? observaciones,
  }) {
    return Pedido(
      id: id ?? this.id,
      clienteId: clienteId ?? this.clienteId,
      clienteNombre: clienteNombre ?? this.clienteNombre,
      items: items ?? this.items,
      total: total ?? this.total,
      abonado: abonado ?? this.abonado,
      saldo: saldo ?? this.saldo,
      estado: estado ?? this.estado,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      fechaEntregaEstimada: fechaEntregaEstimada ?? this.fechaEntregaEstimada,
      asesorId: asesorId ?? this.asesorId,
      asesorNombre: asesorNombre ?? this.asesorNombre,
      observaciones: observaciones ?? this.observaciones,
    );
  }

  bool get isPaid => abonado >= total;
  bool get hasPendingPayment => saldo > 0;
  bool get isCompleted =>
      estado == EstadoPedido.entregado || estado == EstadoPedido.cancelado;
  int get itemCount => items.fold(0, (sum, item) => sum + item.cantidad);

  @override
  List<Object?> get props => [
        id,
        clienteId,
        clienteNombre,
        items,
        total,
        abonado,
        saldo,
        estado,
        fechaCreacion,
        fechaEntregaEstimada,
        asesorId,
        asesorNombre,
        observaciones,
      ];
}