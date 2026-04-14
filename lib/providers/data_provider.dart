import 'package:flutter/foundation.dart';
import 'package:movilsurtitela/domain/entities/cliente.dart';
import 'package:movilsurtitela/domain/entities/producto.dart';
import 'package:movilsurtitela/domain/entities/pedido.dart';
import 'package:movilsurtitela/domain/entities/abono.dart';
import 'package:movilsurtitela/domain/entities/produccion.dart';
import 'package:movilsurtitela/domain/entities/domicilio.dart';
import 'package:movilsurtitela/domain/entities/devolucion.dart';
import 'package:movilsurtitela/data/mock_data.dart';

class DataProvider extends ChangeNotifier {
  List<Cliente> _clientes = [];
  List<Producto> _productos = [];
  List<Pedido> _pedidos = [];
  List<Abono> _abonos = [];
  List<ProcesoProduccion> _procesosProduccion = [];
  List<Domicilio> _domicilios = [];
  List<Devolucion> _devoluciones = [];

  List<Cliente> get clientes => _clientes;
  List<Producto> get productos => _productos;
  List<Pedido> get pedidos => _pedidos;
  List<Abono> get abonos => _abonos;
  List<ProcesoProduccion> get procesosProduccion => _procesosProduccion;
  List<Domicilio> get domicilios => _domicilios;
  List<Devolucion> get devoluciones => _devoluciones;

  DataProvider() {
    _loadMockData();
  }

  void _loadMockData() {
    _clientes = MockData.clientes;
    _productos = MockData.productos;
    _pedidos = MockData.pedidos;
    _abonos = MockData.abonos;
    _procesosProduccion = MockData.procesosProduccion;
    _domicilios = MockData.domicilios;
    _devoluciones = MockData.devoluciones;
    notifyListeners();
  }

  double get ventasDelMes {
    final now = DateTime.now();
    final inicioMes = DateTime(now.year, now.month, 1);
    return _pedidos
        .where((p) => p.fechaCreacion.isAfter(inicioMes))
        .fold(0.0, (sum, p) => sum + p.total);
  }

  double get ventasHoy {
    final now = DateTime.now();
    final inicioDia = DateTime(now.year, now.month, now.day);
    return _pedidos
        .where((p) => p.fechaCreacion.isAfter(inicioDia))
        .fold(0.0, (sum, p) => sum + p.total);
  }

  int get clientesActivos => _clientes.length;

  int get pedidosEnProduccion => _pedidos
      .where((p) =>
          p.estado != EstadoPedido.entregado &&
          p.estado != EstadoPedido.cancelado)
      .length;

  int get pedidosCompletados => _pedidos
      .where((p) => p.estado == EstadoPedido.entregado)
      .length;

  double get saldoPendiente {
    return _pedidos.fold(0.0, (sum, p) => sum + p.saldo);
  }

  int get productosStockBajo {
    return _productos.where((p) => p.stock < 20).length;
  }

  int get domiciliosPendientes {
    return _domicilios.where((d) => d.estado == EstadoDomicilio.pendiente).length;
  }

  List<Pedido> get pedidosRecientes {
    final sorted = List<Pedido>.from(_pedidos);
    sorted.sort((a, b) => b.fechaCreacion.compareTo(a.fechaCreacion));
    return sorted.take(5).toList();
  }

  void addCliente(Cliente cliente) {
    _clientes.add(cliente);
    notifyListeners();
  }

  void updateCliente(Cliente cliente) {
    final index = _clientes.indexWhere((c) => c.id == cliente.id);
    if (index != -1) {
      _clientes[index] = cliente;
      notifyListeners();
    }
  }

  void deleteCliente(String id) {
    _clientes.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  void addPedido(Pedido pedido) {
    _pedidos.add(pedido);
    notifyListeners();
  }

  void updatePedidoEstado(String pedidoId, EstadoPedido nuevoEstado) {
    final index = _pedidos.indexWhere((p) => p.id == pedidoId);
    if (index != -1) {
      final pedido = _pedidos[index];
      _pedidos[index] = pedido.copyWith(estado: nuevoEstado);
      notifyListeners();
    }
  }

  void addAbono(Abono abono) {
    _abonos.add(abono);

    final pedidoIndex = _pedidos.indexWhere((p) => p.id == abono.pedidoId);
    if (pedidoIndex != -1) {
      final pedido = _pedidos[pedidoIndex];
      final nuevoAbonado = pedido.abonado + abono.monto;
      final nuevoSaldo = pedido.total - nuevoAbonado;

      _pedidos[pedidoIndex] = pedido.copyWith(
        abonado: nuevoAbonado,
        saldo: nuevoSaldo,
      );
    }

    notifyListeners();
  }

  void updateDomicilioEstado(String domicilioId, EstadoDomicilio nuevoEstado) {
    final index = _domicilios.indexWhere((d) => d.id == domicilioId);
    if (index != -1) {
      final domicilio = _domicilios[index];
      _domicilios[index] = domicilio.copyWith(
        estado: nuevoEstado,
        fechaEntrega: nuevoEstado == EstadoDomicilio.entregado ? DateTime.now() : null,
      );
      notifyListeners();
    }
  }

  void asignarRepartidor(String domicilioId, String repartidorId, String repartidorNombre) {
    final index = _domicilios.indexWhere((d) => d.id == domicilioId);
    if (index != -1) {
      final domicilio = _domicilios[index];
      _domicilios[index] = domicilio.copyWith(
        repartidorId: repartidorId,
        repartidorNombre: repartidorNombre,
        fechaAsignacion: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void updateDevolucionEstado(String devolucionId, EstadoDevolucion nuevoEstado, String? resolucion) {
    final index = _devoluciones.indexWhere((d) => d.id == devolucionId);
    if (index != -1) {
      final devolucion = _devoluciones[index];
      _devoluciones[index] = devolucion.copyWith(
        estado: nuevoEstado,
        resolucion: resolucion,
      );
      notifyListeners();
    }
  }

  void addProducto(Producto producto) {
    _productos.add(producto);
    notifyListeners();
  }

  void updateProductoStock(String productoId, Map<String, int> nuevoStockPorTalla) {
    final index = _productos.indexWhere((p) => p.id == productoId);
    if (index != -1) {
      final producto = _productos[index];
      int nuevoStock = 0;
      nuevoStockPorTalla.forEach((_, cant) => nuevoStock += cant);

      _productos[index] = producto.copyWith(
        stock: nuevoStock,
        stockPorTalla: nuevoStockPorTalla,
      );
      notifyListeners();
    }
  }
}