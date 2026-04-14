import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:movilsurtitela/domain/entities/user.dart';
import 'package:movilsurtitela/domain/entities/producto.dart';
import 'package:movilsurtitela/providers/data_provider.dart';
import 'package:movilsurtitela/utils/app_colors.dart';
import 'package:movilsurtitela/presentation/widgets/common/custom_components.dart';
import 'package:movilsurtitela/presentation/widgets/cliente/carrito_sheet.dart';
import 'package:movilsurtitela/presentation/pages/cliente/producto_detalle_screen.dart';
import 'package:movilsurtitela/presentation/pages/cliente/checkout_screen.dart';
import 'package:movilsurtitela/presentation/pages/cliente/mis_pedidos_screen.dart';

class CatalogoScreen extends StatefulWidget {
  final User user;
  final Function(Producto) onProductSelect;
  final VoidCallback onOpenCart;
  final VoidCallback? onViewOrders;
  final int cartItemsCount;

  const CatalogoScreen({
    super.key,
    required this.user,
    required this.onProductSelect,
    required this.onOpenCart,
    this.onViewOrders,
    required this.cartItemsCount,
  });

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  String _searchTerm = '';
  String _selectedCategory = 'todos';
  bool _isGridView = true;
  List<dynamic> _carritoItems = [];

  List<Pedido> _pedidosMock = [
    Pedido(
      id: 'PED-001',
      items: [],
      total: 105000,
      estado: EstadoPedido.enviado,
      fechaCreacion: DateTime.now().subtract(const Duration(days: 2)),
      fechaEntregaEstimada: DateTime.now().add(const Duration(days: 1)),
    ),
    Pedido(
      id: 'PED-002',
      items: [],
      total: 75000,
      estado: EstadoPedido.enProduccion,
      fechaCreacion: DateTime.now().subtract(const Duration(days: 5)),
      fechaEntregaEstimada: DateTime.now().add(const Duration(days: 3)),
    ),
  ];

  final List<Map<String, String>> _categorias = [
    {'id': 'todos', 'nombre': 'Todos'},
    {'id': 'camiseta', 'nombre': 'Camisetas'},
    {'id': 'buso', 'nombre': 'Busos'},
    {'id': 'pantaloneta', 'nombre': 'Pantalonetas'},
    {'id': 'gorra', 'nombre': 'Gorras'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final dataProvider = Provider.of<DataProvider>(context);

    final productosFiltrados = dataProvider.productos.where((p) {
      final matchSearch = p.nombre.toLowerCase().contains(_searchTerm.toLowerCase()) ||
                         p.descripcion.toLowerCase().contains(_searchTerm.toLowerCase());
      final matchCategory = _selectedCategory == 'todos' || p.categoria.name == _selectedCategory;
      return matchSearch && matchCategory && p.estado == EstadoProducto.disponible;
    }).toList();

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(colors),
            _buildCategorias(colors),
            _buildViewControls(colors, productosFiltrados.length),
            Expanded(
              child: _isGridView
                  ? _buildGridView(colors, productosFiltrados)
                  : _buildListView(colors, productosFiltrados),
            ),
          ],
        ),
      ),
      endDrawer: _buildSideMenu(colors, isDark),
    );
  }

  void _openCarritoSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CarritoSheet(
        items: _carritoItems,
        onUpdateQuantity: (productoId, talla, color, cantidad) {
          setState(() {
            final index = _carritoItems.indexWhere(
              (item) => item.productoId == productoId && item.talla == talla && item.color == color
            );
            if (index != -1) {
              final item = _carritoItems[index];
              _carritoItems[index] = ItemCarrito(
                productoId: item.productoId,
                productoNombre: item.productoNombre,
                productoImagen: item.productoImagen,
                cantidad: cantidad,
                talla: item.talla,
                color: item.color,
                precioUnitario: item.precioUnitario,
                subtotal: item.precioUnitario * cantidad,
              );
            }
          });
        },
        onRemoveItem: (productoId, talla, color) {
          setState(() {
            _carritoItems.removeWhere(
              (item) => item.productoId == productoId && item.talla == talla && item.color == color
            );
          });
        },
        onCheckout: () {
          Navigator.pop(context);
          final total = _carritoItems.fold<double>(0, (sum, item) => sum + item.subtotal);
          Navigator.push(context, MaterialPageRoute(builder: (context) => 
            CheckoutScreen(
              items: _carritoItems,
              total: total,
              onConfirmOrder: (orderData) {
                setState(() {
                  _carritoItems.clear();
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('¡Pedido realizado exitosamente!'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            )
          ));
        },
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  void _agregarAlCarrito(ItemCarrito item) {
    setState(() {
      final existingIndex = _carritoItems.indexWhere(
        (i) => i.productoId == item.productoId && i.talla == item.talla && i.color == item.color
      );
      if (existingIndex != -1) {
        final existing = _carritoItems[existingIndex];
        _carritoItems[existingIndex] = ItemCarrito(
          productoId: existing.productoId,
          productoNombre: existing.productoNombre,
          productoImagen: existing.productoImagen,
          cantidad: existing.cantidad + item.cantidad,
          talla: existing.talla,
          color: existing.color,
          precioUnitario: existing.precioUnitario,
          subtotal: existing.subtotal + item.subtotal,
        );
      } else {
        _carritoItems.add(item);
      }
    });
  }

  Widget _buildHeader(AppColorsTheme colors) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          bottom: BorderSide(color: colors.border),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Builder(
                builder: (context) => InkWell(
                  onTap: () => Scaffold.of(context).openEndDrawer(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colors.surfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.person, color: colors.text),
                  ),
                ),
              ),
              Text(
                'Surticamisetas',
                style: TextStyle(
                  color: colors.text,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: _openCarritoSheet,
                child: Stack(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colors.surfaceElevated,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.shopping_cart, color: colors.text),
                    ),
                    if (_carritoItems.isNotEmpty)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: colors.accent,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${_carritoItems.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: colors.textSecondary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    onChanged: (value) => setState(() => _searchTerm = value),
                    decoration: InputDecoration(
                      hintText: 'Buscar productos...',
                      hintStyle: TextStyle(color: colors.textSecondary),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    style: TextStyle(color: colors.text, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorias(AppColorsTheme colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.border),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _categorias.map((cat) {
            final isSelected = _selectedCategory == cat['id'];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => setState(() => _selectedCategory = cat['id']!),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? colors.accent : colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    cat['nombre']!,
                    style: TextStyle(
                      color: isSelected ? Colors.white : colors.text,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildViewControls(AppColorsTheme colors, int productCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$productCount productos',
            style: TextStyle(color: colors.textSecondary, fontSize: 14),
          ),
          Row(
            children: [
              InkWell(
                onTap: () => setState(() => _isGridView = true),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _isGridView ? colors.accentLight : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.grid_view,
                    color: _isGridView ? colors.accent : colors.textSecondary,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => setState(() => _isGridView = false),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: !_isGridView ? colors.accentLight : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.list,
                    color: !_isGridView ? colors.accent : colors.textSecondary,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(AppColorsTheme colors, List<Producto> productos) {
    if (productos.isEmpty) {
      return _buildEmptyState(colors);
    }

    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: productos.length,
      itemBuilder: (context, index) {
        final producto = productos[index];
        return _buildProductCard(colors, producto);
      },
    );
  }

  Widget _buildProductCard(AppColorsTheme colors, Producto producto) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => 
        ProductoDetalleScreen(
          producto: producto,
          onAddToCart: _agregarAlCarrito,
        )
      )),
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      producto.imagen,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: colors.surfaceElevated,
                        child: Icon(Icons.image_not_supported, color: colors.textSecondary),
                      ),
                    ),
                  ),
                  if (producto.stock < 10)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.warningBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Últimas unidades',
                          style: TextStyle(
                            color: colors.warning,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.nombre,
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    producto.descripcion,
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    NumberFormat.currency(
                      symbol: '\$',
                      decimalDigits: 0,
                      locale: 'es_CO',
                    ).format(producto.precioBase),
                    style: TextStyle(
                      color: colors.accent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView(AppColorsTheme colors, List<Producto> productos) {
    if (productos.isEmpty) {
      return _buildEmptyState(colors);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: productos.length,
      itemBuilder: (context, index) {
        final producto = productos[index];
        return _buildProductListItem(colors, producto);
      },
    );
  }

  Widget _buildProductListItem(AppColorsTheme colors, Producto producto) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => 
        ProductoDetalleScreen(
          producto: producto,
          onAddToCart: _agregarAlCarrito,
        )
      )),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                producto.imagen,
                width: 96,
                height: 96,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 96,
                  height: 96,
                  color: colors.surfaceElevated,
                  child: Icon(Icons.image_not_supported, color: colors.textSecondary),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.nombre,
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    producto.descripcion,
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        NumberFormat.currency(
                          symbol: '\$',
                          decimalDigits: 0,
                          locale: 'es_CO',
                        ).format(producto.precioBase),
                        style: TextStyle(
                          color: colors.accent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (producto.stock < 10)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: colors.warningBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Stock bajo',
                            style: TextStyle(
                              color: colors.warning,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppColorsTheme colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search,
              size: 40,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No se encontraron productos',
            style: TextStyle(
              color: colors.text,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Intenta con otros términos de búsqueda\no cambia la categoría',
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSideMenu(AppColorsTheme colors, bool isDark) {
    return Drawer(
      child: Container(
        color: colors.surface,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mi Cuenta',
                  style: TextStyle(
                    color: colors.text,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.user.name,
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 32),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => 
                      MisPedidosScreen(pedidos: _pedidosMock)
                    ));
                  },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colors.surfaceElevated,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.inventory_2, color: colors.text),
                          const SizedBox(width: 12),
                          Text(
                            'Mis Pedidos',
                            style: TextStyle(
                              color: colors.text,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors.error,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Cerrar Sesión',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
