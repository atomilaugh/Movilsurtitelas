import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movilsurtitela/providers/data_provider.dart';
import 'package:movilsurtitela/domain/entities/producto.dart';
import 'package:movilsurtitela/utils/app_colors.dart';
import 'package:movilsurtitela/utils/formatters.dart';
import 'package:movilsurtitela/presentation/widgets/common/custom_components.dart';

class AsesorCatalogoScreen extends StatefulWidget {
  const AsesorCatalogoScreen({super.key});

  @override
  State<AsesorCatalogoScreen> createState() => _AsesorCatalogoScreenState();
}

class _AsesorCatalogoScreenState extends State<AsesorCatalogoScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'todos';
  bool _isGridView = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final dataProvider = Provider.of<DataProvider>(context);

    final productosFiltrados = dataProvider.productos.where((p) {
      if (_searchQuery.isNotEmpty &&
          !p.nombre.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }
      if (_selectedCategory != 'todos' &&
          p.categoria.name != _selectedCategory) {
        return false;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Catálogo de Productos',
          style: TextStyle(
            color: colors.text,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _isGridView ? Icons.view_list : Icons.grid_view,
              color: colors.text,
            ),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: InputDecoration(
                hintText: 'Buscar producto...',
                prefixIcon: Icon(Icons.search, color: colors.textSecondary),
                filled: true,
                fillColor: colors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: colors.border),
                ),
              ),
              style: TextStyle(color: colors.text),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
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
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _isGridView
                ? GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                    itemCount: productosFiltrados.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(
                        productosFiltrados[index],
                        colors,
                        isDark,
                      );
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: productosFiltrados.length,
                    itemBuilder: (context, index) {
                      return _buildProductListItem(
                        productosFiltrados[index],
                        colors,
                        isDark,
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Agregar Producto')));
        },
        backgroundColor: colors.primary,
        child: Icon(Icons.add, color: isDark ? Colors.black : Colors.white),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, dynamic colors) {
    final isSelected = _selectedCategory == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? (Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white)
                : colors.text,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Producto producto, dynamic colors, bool isDark) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Producto: ${producto.nombre}')));
      },
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
              child: Container(
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: const Center(child: Icon(Icons.image, size: 48)),
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
                      fontWeight: FontWeight.w600,
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
                  const SizedBox(height: 4),
                  Text(
                    'Stock: ${producto.stock}',
                    style: TextStyle(
                      color: producto.stock < 20
                          ? colors.error
                          : colors.textSecondary,
                      fontSize: 12,
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

  Widget _buildProductListItem(Producto producto, dynamic colors, bool isDark) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Producto: ${producto.nombre}')));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: colors.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.image, size: 32),
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
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Formatters.formatCurrency(producto.precioBase),
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Stock: ${producto.stock}',
                    style: TextStyle(
                      color: producto.stock < 20
                          ? colors.error
                          : colors.textSecondary,
                      fontSize: 12,
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
}
