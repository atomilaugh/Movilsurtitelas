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
      id: json['id'],
      nombre: json['nombre'],
      categoria: CategoriaProducto.values.firstWhere((e) => e.name == json['categoria']),
      descripcion: json['descripcion'],
      imagen: json['imagen'],
      tallas: List<String>.from(json['tallas']),
      colores: List<String>.from(json['colores']),
      precioBase: json['precioBase'].toDouble(),
      stock: json['stock'],
      stockPorTalla: Map<String, int>.from(json['stockPorTalla']),
      estado: EstadoProducto.values.firstWhere((e) => e.name == json['estado']),
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

  @override
  List<Object?> get props => [id, nombre, categoria, descripcion, imagen, tallas, colores, precioBase, stock, stockPorTalla, estado];
}
