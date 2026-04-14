import 'package:equatable/equatable.dart';

enum CategoriaProducto { camiseta, buso, pantaloneta, gorra, otro }
enum EstadoProducto { disponible, agotado, descontinuado }

class Producto extends Equatable {
  final String id;
  final String nombre;
  final CategoriaProducto categoria;
  final String descripcion;
  final String imagen;
  final List<String> tallas;
  final List<String> colores;
  final double precioBase;
  final int stock;
  final Map<String, int> stockPorTalla;
  final EstadoProducto estado;

  const Producto({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.descripcion,
    required this.imagen,
    required this.tallas,
    required this.colores,
    required this.precioBase,
    required this.stock,
    required this.stockPorTalla,
    required this.estado,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'] ?? '',
      nombre: json['nombre'] ?? '',
      categoria: CategoriaProducto.values.firstWhere(
        (e) => e.name == json['categoria'],
        orElse: () => CategoriaProducto.otro,
      ),
      descripcion: json['descripcion'] ?? '',
      imagen: json['imagen'] ?? '',
      tallas: List<String>.from(json['tallas'] ?? []),
      colores: List<String>.from(json['colores'] ?? []),
      precioBase: (json['precioBase'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      stockPorTalla: Map<String, int>.from(json['stockPorTalla'] ?? {}),
      estado: EstadoProducto.values.firstWhere(
        (e) => e.name == json['estado'],
        orElse: () => EstadoProducto.disponible,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'categoria': categoria.name,
      'descripcion': descripcion,
      'imagen': imagen,
      'tallas': tallas,
      'colores': colores,
      'precioBase': precioBase,
      'stock': stock,
      'stockPorTalla': stockPorTalla,
      'estado': estado.name,
    };
  }

  Producto copyWith({
    String? id,
    String? nombre,
    CategoriaProducto? categoria,
    String? descripcion,
    String? imagen,
    List<String>? tallas,
    List<String>? colores,
    double? precioBase,
    int? stock,
    Map<String, int>? stockPorTalla,
    EstadoProducto? estado,
  }) {
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      categoria: categoria ?? this.categoria,
      descripcion: descripcion ?? this.descripcion,
      imagen: imagen ?? this.imagen,
      tallas: tallas ?? this.tallas,
      colores: colores ?? this.colores,
      precioBase: precioBase ?? this.precioBase,
      stock: stock ?? this.stock,
      stockPorTalla: stockPorTalla ?? this.stockPorTalla,
      estado: estado ?? this.estado,
    );
  }

  bool get isAvailable => estado == EstadoProducto.disponible && stock > 0;
  bool get isLowStock => stock > 0 && stock < 20;

  @override
  List<Object?> get props => [
        id,
        nombre,
        categoria,
        descripcion,
        imagen,
        tallas,
        colores,
        precioBase,
        stock,
        stockPorTalla,
        estado,
      ];
}