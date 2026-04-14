import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movilsurtitela/domain/entities/producto.dart';
import 'package:movilsurtitela/providers/data_provider.dart';
import 'package:movilsurtitela/utils/app_colors.dart';
import 'package:movilsurtitela/utils/formatters.dart';

class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
          'Inventario',
          style: TextStyle(color: colors.text, fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: colors.primary,
          unselectedLabelColor: colors.textTertiary,
          indicatorColor: colors.primary,
          tabs: const [
            Tab(text: 'Productos'),
            Tab(text: 'Insumos'),
            Tab(text: 'Alertas'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProductosTab(colors, isDark),
          _buildInsumosTab(colors),
          _buildAlertasTab(colors),
        ],
      ),
    );
  }

  Widget _buildProductosTab(dynamic colors, bool isDark) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, _) {
        final productos = dataProvider.productos;
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: productos.length,
          itemBuilder: (context, index) {
            return _buildProductoCard(productos[index], colors, isDark);
          },
        );
      },
    );
  }

  Widget _buildProductoCard(Producto producto, dynamic colors, bool isDark) {
    final isLowStock = producto.stock < 20;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isLowStock ? colors.warning : colors.border,
          width: isLowStock ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  producto.nombre,
                  style: TextStyle(
                    color: colors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: producto.estado == EstadoProducto.disponible
                      ? colors.successBg
                      : colors.errorBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  producto.estado == EstadoProducto.disponible ? 'Disponible' : 'Agotado',
                  style: TextStyle(
                    color: producto.estado == EstadoProducto.disponible
                        ? colors.success
                        : colors.error,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Stock total: ${producto.stock} unidades',
            style: TextStyle(
              color: isLowStock ? colors.warning : colors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: producto.stockPorTalla.entries.map((e) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${e.key}: ${e.value}',
                  style: TextStyle(color: colors.textSecondary, fontSize: 12),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                child: Text(
                  'Ajustar stock',
                  style: TextStyle(color: colors.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsumosTab(dynamic colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory, size: 64, color: colors.textTertiary),
          const SizedBox(height: 16),
          Text(
            'Gestión de insumos',
            style: TextStyle(color: colors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            'Próximamente',
            style: TextStyle(color: colors.textTertiary),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertasTab(dynamic colors) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, _) {
        final lowStockProducts = dataProvider.productos.where((p) => p.stock < 20).toList();
        
        if (lowStockProducts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, size: 64, color: colors.success),
                const SizedBox(height: 16),
                Text(
                  'Sin alertas de inventario',
                  style: TextStyle(color: colors.textSecondary),
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: lowStockProducts.length,
          itemBuilder: (context, index) {
            final producto = lowStockProducts[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.warningBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.warning),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: colors.warning),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          producto.nombre,
                          style: TextStyle(
                            color: colors.text,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Stock: ${producto.stock} unidades',
                          style: TextStyle(color: colors.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('Reponer', style: TextStyle(color: colors.warning)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}