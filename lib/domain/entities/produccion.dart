import 'package:equatable/equatable.dart';

enum EtapaProduccion { corte, confeccion, estampado }
enum EstadoProceso { pendiente, enProceso, completado }

class ProcesoProduccion extends Equatable {
  final String id;
  final String pedidoId;
  final EtapaProduccion etapa;
  final EstadoProceso estado;
  final String? tallerExterno;
  final DateTime? fechaInicio;
  final DateTime? fechaFin;
  final String responsable;

  const ProcesoProduccion({
    required this.id,
    required this.pedidoId,
    required this.etapa,
    required this.estado,
    this.tallerExterno,
    this.fechaInicio,
    this.fechaFin,
    required this.responsable,
  });

  factory ProcesoProduccion.fromJson(Map<String, dynamic> json) {
    return ProcesoProduccion(
      id: json['id'] ?? '',
      pedidoId: json['pedidoId'] ?? '',
      etapa: EtapaProduccion.values.firstWhere(
        (e) => e.name == json['etapa'],
        orElse: () => EtapaProduccion.corte,
      ),
      estado: EstadoProceso.values.firstWhere(
        (e) => e.name == json['estado'],
        orElse: () => EstadoProceso.pendiente,
      ),
      tallerExterno: json['tallerExterno'],
      fechaInicio: json['fechaInicio'] != null
          ? DateTime.parse(json['fechaInicio'])
          : null,
      fechaFin: json['fechaFin'] != null
          ? DateTime.parse(json['fechaFin'])
          : null,
      responsable: json['responsable'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pedidoId': pedidoId,
      'etapa': etapa.name,
      'estado': estado.name,
      'tallerExterno': tallerExterno,
      'fechaInicio': fechaInicio?.toIso8601String(),
      'fechaFin': fechaFin?.toIso8601String(),
      'responsable': responsable,
    };
  }

  ProcesoProduccion copyWith({
    String? id,
    String? pedidoId,
    EtapaProduccion? etapa,
    EstadoProceso? estado,
    String? tallerExterno,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    String? responsable,
  }) {
    return ProcesoProduccion(
      id: id ?? this.id,
      pedidoId: pedidoId ?? this.pedidoId,
      etapa: etapa ?? this.etapa,
      estado: estado ?? this.estado,
      tallerExterno: tallerExterno ?? this.tallerExterno,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
      responsable: responsable ?? this.responsable,
    );
  }

  bool get isPending => estado == EstadoProceso.pendiente;
  bool get isInProgress => estado == EstadoProceso.enProceso;
  bool get isCompleted => estado == EstadoProceso.completado;

  @override
  List<Object?> get props => [
        id,
        pedidoId,
        etapa,
        estado,
        tallerExterno,
        fechaInicio,
        fechaFin,
        responsable,
      ];
}