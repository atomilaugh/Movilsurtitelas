import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movilsurtitela/domain/entities/pedido.dart';
import 'package:movilsurtitela/domain/entities/cliente.dart';
import 'package:movilsurtitela/domain/entities/producto.dart';
import 'package:movilsurtitela/providers/data_provider.dart';
import 'package:movilsurtitela/utils/app_colors.dart';
import 'package:movilsurtitela/utils/formatters.dart';

class PedidosScreen extends StatefulWidget {
  const PedidosScreen({super.key});

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
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
          'Pedidos',
          style: TextStyle(color: colors.text, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: colors.primary),
            onPressed: () => _showCreatePedidoDialog(context, colors, isDark),
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
                            hintText: 'Buscar por cliente o ID...',
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
                      _buildFilterChip('Recibido', 'recibido', colors),
                      const SizedBox(width: 8),
                      _buildFilterChip('En producción', 'enProduccion', colors),
                      const SizedBox(width: 8),
                      _buildFilterChip('Listo', 'listo', colors),
                      const SizedBox(width: 8),
                      _buildFilterChip('Entregado', 'entregado', colors),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<DataProvider>(
              builder: (context, dataProvider, _) {
                var pedidos = dataProvider.pedidos;

                if (_searchQuery.isNotEmpty) {
                  pedidos = pedidos.where((p) =>
                    p.clienteNombre.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    p.id.toLowerCase().contains(_searchQuery.toLowerCase())
                  ).toList();
                }

                if (_filter != 'todos') {
                  pedidos = pedidos.where((p) => p.estado.name == _filter).toList();
                }

                if (pedidos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 64, color: colors.textTertiary),
                        const SizedBox(height: 16),
                        Text(
                          'No hay pedidos',
                          style: TextStyle(color: colors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: pedidos.length,
                  itemBuilder: (context, index) {
                    return _buildPedidoCard(pedidos[index], colors, isDark);
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

  Widget _buildPedidoCard(Pedido pedido, dynamic colors, bool isDark) {
    Color bgColor;
    Color textColor;

    switch (pedido.estado) {
      case EstadoPedido.entregado:
        bgColor = colors.successBg;
        textColor = colors.success;
        break;
      case EstadoPedido.listo:
        bgColor = colors.warningBg;
        textColor = colors.warning;
        break;
      case EstadoPedido.cancelado:
        bgColor = colors.errorBg;
        textColor = colors.error;
        break;
      default:
        bgColor = colors.infoBg;
        textColor = colors.info;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pedido.clienteNombre,
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pedido #${pedido.id} • ${Formatters.formatDate(pedido.fechaCreacion)}',
                    style: TextStyle(color: colors.textSecondary, fontSize: 12),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  pedido.estado.name.replaceAll('_', ' '),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${pedido.items.length} producto(s)',
            style: TextStyle(color: colors.textTertiary, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(color: colors.textTertiary, fontSize: 10),
                  ),
                  Text(
                    Formatters.formatCurrency(pedido.total),
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Saldo',
                    style: TextStyle(color: colors.textTertiary, fontSize: 10),
                  ),
                  Text(
                    Formatters.formatCurrency(pedido.saldo),
                    style: TextStyle(
                      color: pedido.saldo > 0 ? colors.warning : colors.success,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.person, size: 14, color: colors.textTertiary),
              const SizedBox(width: 4),
              Text(
                pedido.asesorNombre,
                style: TextStyle(color: colors.textSecondary, fontSize: 12),
              ),
              const Spacer(),
              if (pedido.observaciones != null) ...[
                Icon(Icons.info_outline, size: 14, color: colors.textTertiary),
                const SizedBox(width: 4),
                Text(
                  'Tiene observaciones',
                  style: TextStyle(color: colors.textTertiary, fontSize: 12),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  void _showCreatePedidoDialog(BuildContext context, dynamic colors, bool isDark) {
    Cliente? selectedCliente;
    final List<Map<String, dynamic>> itemsCarrito = [];
    final observacionesController = TextEditingController();
    double total = 0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final dataProvider = context.read<DataProvider>();
          final clientes = dataProvider.clientes;
          final productos = dataProvider.productos;

          return DraggableScrollableSheet(
            initialChildSize: 0.9,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (context, scrollController) => Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nuevo Pedido',
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        Text('Cliente', style: TextStyle(color: colors.text, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: colors.surfaceElevated,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colors.border),
                          ),
                          child: DropdownButton<Cliente>(
                            value: selectedCliente,
                            hint: Text('Seleccionar cliente', style: TextStyle(color: colors.textTertiary)),
                            isExpanded: true,
                            dropdownColor: colors.surface,
                            items: clientes.map((c) => DropdownMenuItem(
                              value: c,
                              child: Text(c.nombre, style: TextStyle(color: colors.text)),
                            )).toList(),
                            onChanged: (c) => setModalState(() => selectedCliente = c),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Productos', style: TextStyle(color: colors.text, fontWeight: FontWeight.w500)),
                            TextButton.icon(
                              onPressed: () {
                                _showAddProductoToPedido(context, colors, productos, itemsCarrito, (totalTemp) {
                                  setModalState(() => total = totalTemp);
                                });
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Agregar'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (itemsCarrito.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: colors.surfaceElevated,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                'Agrega productos al pedido',
                                style: TextStyle(color: colors.textTertiary),
                              ),
                            ),
                          )
                        else
                          ...itemsCarrito.asMap().entries.map((e) {
                            final item = e.value;
                            return Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: colors.surfaceElevated,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(item['producto'].nombre, style: TextStyle(color: colors.text, fontWeight: FontWeight.w500)),
                                        Text('${item['cantidad']} x ${item['talla']} / ${item['color']}', style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                  Text(Formatters.formatCurrency(item['subtotal']), style: TextStyle(color: colors.text, fontWeight: FontWeight.bold)),
                                  IconButton(
                                    icon: Icon(Icons.delete_outline, color: colors.error),
                                    onPressed: () {
                                      setModalState(() {
                                        itemsCarrito.removeAt(e.key);
                                        total = itemsCarrito.fold(0.0, (sum, i) => sum + (i['subtotal'] as double));
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          }),
                        const SizedBox(height: 16),
                        TextField(
                          controller: observacionesController,
                          maxLines: 2,
                          style: TextStyle(color: colors.text),
                          decoration: InputDecoration(
                            labelText: 'Observaciones (opcional)',
                            labelStyle: TextStyle(color: colors.textSecondary),
                            filled: true,
                            fillColor: colors.surfaceElevated,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: colors.border),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: colors.surfaceElevated,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total', style: TextStyle(color: colors.text, fontSize: 18, fontWeight: FontWeight.bold)),
                              Text(Formatters.formatCurrency(total), style: TextStyle(color: colors.primary, fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: selectedCliente == null || itemsCarrito.isEmpty
                          ? null
                          : () {
                              final items = itemsCarrito.map((i) => ItemPedido(
                                productoId: (i['producto'] as Producto).id,
                                productoNombre: (i['producto'] as Producto).nombre,
                                cantidad: i['cantidad'],
                                talla: i['talla'],
                                color: i['color'],
                                precioUnitario: (i['producto'] as Producto).precioBase,
                                subtotal: i['subtotal'],
                              )).toList();

                              final pedido = Pedido(
                                id: 'ped${DateTime.now().millisecondsSinceEpoch}',
                                clienteId: selectedCliente!.id,
                                clienteNombre: selectedCliente!.nombre,
                                items: items,
                                total: total,
                                abonado: 0,
                                saldo: total,
                                estado: EstadoPedido.recibido,
                                fechaCreacion: DateTime.now(),
                                fechaEntregaEstimada: DateTime.now().add(const Duration(days: 7)),
                                asesorId: '1',
                                asesorNombre: 'Admin',
                                observaciones: observacionesController.text.isEmpty ? null : observacionesController.text,
                              );
                              context.read<DataProvider>().addPedido(pedido);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Pedido creado para ${selectedCliente!.nombre}')),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'Crear Pedido',
                        style: TextStyle(color: isDark ? Colors.black : Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddProductoToPedido(
    BuildContext context,
    dynamic colors,
    List<Producto> productos,
    List<Map<String, dynamic>> itemsCarrito,
    Function(double) onTotalChanged,
  ) {
    Producto? selectedProducto;
    int cantidad = 1;
    String talla = 'M';
    String color = 'Negro';
    double subtotal = 0;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Agregar Producto', style: TextStyle(color: colors.text, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.border),
                ),
                child: DropdownButton<Producto>(
                  value: selectedProducto,
                  hint: Text('Seleccionar producto', style: TextStyle(color: colors.textTertiary)),
                  isExpanded: true,
                  dropdownColor: colors.surface,
                  items: productos.map((p) => DropdownMenuItem(
                    value: p,
                    child: Text('${p.nombre} - ${Formatters.formatCurrency(p.precioBase)}', style: TextStyle(color: colors.text)),
                  )).toList(),
                  onChanged: (p) {
                    setModalState(() {
                      selectedProducto = p;
                      if (p != null) {
                        subtotal = p.precioBase * cantidad;
                      }
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cantidad', style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove, color: colors.text),
                              onPressed: cantidad > 1 ? () {
                                setModalState(() {
                                  cantidad--;
                                  if (selectedProducto != null) {
                                    subtotal = selectedProducto!.precioBase * cantidad;
                                  }
                                });
                              } : null,
                            ),
                            Text('$cantidad', style: TextStyle(color: colors.text, fontSize: 18, fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: Icon(Icons.add, color: colors.text),
                              onPressed: () {
                                setModalState(() {
                                  cantidad++;
                                  if (selectedProducto != null) {
                                    subtotal = selectedProducto!.precioBase * cantidad;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Talla', style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                        const SizedBox(height: 4),
                        Wrap(
                          children: selectedProducto?.tallas.map((t) => ChoiceChip(
                            label: Text(t),
                            selected: talla == t,
                            onSelected: (s) => setModalState(() => talla = t),
                            selectedColor: colors.primary,
                          )).toList() ?? [],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Color', style: TextStyle(color: colors.textSecondary, fontSize: 12)),
              const SizedBox(height: 4),
              Wrap(
                spacing: 8,
                children: selectedProducto?.colores.map((c) => ChoiceChip(
                  label: Text(c),
                  selected: color == c,
                  onSelected: (s) => setModalState(() => color = c),
                  selectedColor: colors.primary,
                )).toList() ?? [],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedProducto == null
                      ? null
                      : () {
                          itemsCarrito.add({
                            'producto': selectedProducto,
                            'cantidad': cantidad,
                            'talla': talla,
                            'color': color,
                            'subtotal': subtotal,
                          });
                          onTotalChanged(itemsCarrito.fold(0.0, (sum, i) => sum + (i['subtotal'] as double)));
                          Navigator.pop(context);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Agregar (${Formatters.formatCurrency(subtotal)})', style: TextStyle(color: isDark(context) ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isDark(BuildContext context) => Theme.of(context).brightness == Brightness.dark;
}