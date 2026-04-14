import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movilsurtitela/domain/entities/producto.dart';
import 'package:movilsurtitela/providers/data_provider.dart';
import 'package:movilsurtitela/utils/app_colors.dart';
import 'package:movilsurtitela/utils/formatters.dart';

class ProductosScreen extends StatefulWidget {
  const ProductosScreen({super.key});

  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  String _searchQuery = '';
  String _filter = 'todos';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Productos',
          style: TextStyle(color: colors.text, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: colors.primary),
            onPressed: () => _showAddProductoDialog(context, colors, isDark),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: colors.surface,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: colors.textTertiary, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          onChanged: (value) => setState(() => _searchQuery = value),
                          decoration: InputDecoration(
                            hintText: 'Buscar productos...',
                            hintStyle: TextStyle(color: colors.textTertiary),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(color: colors.text),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Todos', 'todos', colors),
                      const SizedBox(width: 8),
                      _buildFilterChip('Camisetas', 'camiseta', colors),
                      const SizedBox(width: 8),
                      _buildFilterChip('Busos', 'buso', colors),
                      const SizedBox(width: 8),
                      _buildFilterChip('Pantalonetas', 'pantaloneta', colors),
                      const SizedBox(width: 8),
                      _buildFilterChip('Gorras', 'gorra', colors),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<DataProvider>(
              builder: (context, dataProvider, _) {
                var productos = dataProvider.productos;

                if (_searchQuery.isNotEmpty) {
                  productos = productos.where((p) =>
                    p.nombre.toLowerCase().contains(_searchQuery.toLowerCase())
                  ).toList();
                }

                if (_filter != 'todos') {
                  productos = productos.where((p) =>
                    p.categoria.name == _filter
                  ).toList();
                }

                if (productos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 64, color: colors.textTertiary),
                        const SizedBox(height: 16),
                        Text(
                          'No hay productos',
                          style: TextStyle(color: colors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: productos.length,
                  itemBuilder: (context, index) {
                    return _buildProductoCard(productos[index], colors, isDark);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, dynamic colors) {
    final isSelected = _filter == value;
    return GestureDetector(
      onTap: () => setState(() => _filter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.surfaceElevated,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? colors.primary : colors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? (colors == AppColors.dark ? Colors.black : Colors.white) : colors.text,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildProductoCard(Producto producto, dynamic colors, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.surfaceElevated,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Icon(
                Icons.checkroom,
                size: 48,
                color: colors.textTertiary,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.nombre,
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.formatCurrency(producto.precioBase),
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: producto.estado == EstadoProducto.disponible
                              ? colors.successBg
                              : colors.errorBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          producto.estado == EstadoProducto.disponible
                              ? 'Disponible'
                              : 'Agotado',
                          style: TextStyle(
                            color: producto.estado == EstadoProducto.disponible
                                ? colors.success
                                : colors.error,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${producto.stock} uds',
                        style: TextStyle(
                          color: colors.textTertiary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddProductoDialog(BuildContext context, dynamic colors, bool isDark) {
    final nombreController = TextEditingController();
    final descripcionController = TextEditingController();
    final precioController = TextEditingController();
    CategoriaProducto _categoria = CategoriaProducto.camiseta;
    final List<String> _tallas = ['S', 'M', 'L', 'XL'];
    final List<String> _colores = ['Negro', 'Blanco'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nuevo Producto',
                  style: TextStyle(
                    color: colors.text,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: nombreController,
                  style: TextStyle(color: colors.text),
                  decoration: _inputDecoration('Nombre del producto', colors),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descripcionController,
                  style: TextStyle(color: colors.text),
                  maxLines: 3,
                  decoration: _inputDecoration('Descripción', colors),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: precioController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: colors.text),
                  decoration: _inputDecoration('Precio base', colors),
                ),
                const SizedBox(height: 16),
                Text('Categoría', style: TextStyle(color: colors.text, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: CategoriaProducto.values.map((cat) {
                    final isSelected = _categoria == cat;
                    return ChoiceChip(
                      label: Text(_getCategoriaLabel(cat)),
                      selected: isSelected,
                      onSelected: (selected) {
                        setModalState(() => _categoria = cat);
                      },
                      selectedColor: colors.primary,
                      labelStyle: TextStyle(color: isSelected ? (isDark ? Colors.black : Colors.white) : colors.text),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text('Tallas disponibles', style: TextStyle(color: colors.text, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: ['XS', 'S', 'M', 'L', 'XL', 'XXL'].map((talla) {
                    final isSelected = _tallas.contains(talla);
                    return FilterChip(
                      label: Text(talla),
                      selected: isSelected,
                      onSelected: (selected) {
                        setModalState(() {
                          if (selected) {
                            _tallas.add(talla);
                          } else {
                            _tallas.remove(talla);
                          }
                        });
                      },
                      selectedColor: colors.primary,
                      labelStyle: TextStyle(color: isSelected ? (isDark ? Colors.black : Colors.white) : colors.text),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text('Colores disponibles', style: TextStyle(color: colors.text, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: ['Negro', 'Blanco', 'Azul', 'Rojo', 'Gris', 'Verde'].map((color) {
                    final isSelected = _colores.contains(color);
                    return FilterChip(
                      label: Text(color),
                      selected: isSelected,
                      onSelected: (selected) {
                        setModalState(() {
                          if (selected) {
                            _colores.add(color);
                          } else {
                            _colores.remove(color);
                          }
                        });
                      },
                      selectedColor: colors.primary,
                      labelStyle: TextStyle(color: isSelected ? (isDark ? Colors.black : Colors.white) : colors.text),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (nombreController.text.isEmpty || precioController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Por favor completa los campos obligatorios')),
                        );
                        return;
                      }
                      final producto = Producto(
                        id: 'p${DateTime.now().millisecondsSinceEpoch}',
                        nombre: nombreController.text,
                        categoria: _categoria,
                        descripcion: descripcionController.text,
                        imagen: '',
                        tallas: List<String>.from(_tallas),
                        colores: List<String>.from(_colores),
                        precioBase: double.tryParse(precioController.text) ?? 0,
                        stock: 0,
                        stockPorTalla: {for (var t in _tallas) t: 0},
                        estado: EstadoProducto.disponible,
                      );
                      context.read<DataProvider>().addProducto(producto);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Producto "${producto.nombre}" agregado correctamente')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Guardar',
                      style: TextStyle(
                        color: isDark ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getCategoriaLabel(CategoriaProducto cat) {
    switch (cat) {
      case CategoriaProducto.camiseta:
        return 'Camiseta';
      case CategoriaProducto.buso:
        return 'Buso';
      case CategoriaProducto.pantaloneta:
        return 'Pantaloneta';
      case CategoriaProducto.gorra:
        return 'Gorra';
      case CategoriaProducto.otro:
        return 'Otro';
    }
  }

  InputDecoration _inputDecoration(String label, dynamic colors) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: colors.textSecondary),
      filled: true,
      fillColor: colors.surfaceElevated,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.primary, width: 2),
      ),
    );
  }
}