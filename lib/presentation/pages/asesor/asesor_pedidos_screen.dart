import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movilsurtitela/providers/data_provider.dart';
import 'package:movilsurtitela/domain/entities/pedido.dart';
import 'package:movilsurtitela/utils/app_colors.dart';
import 'package:movilsurtitela/utils/formatters.dart';

class AsesorPedidosScreen extends StatefulWidget {
  final bool isDarkMode;

  const AsesorPedidosScreen({super.key, required this.isDarkMode});

  @override
  State<AsesorPedidosScreen> createState() => _AsesorPedidosScreenState();
}

class _AsesorPedidosScreenState extends State<AsesorPedidosScreen> {
  String _selectedFilter = 'todos';

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final colors = isDark ? AppColors.dark : AppColors.light;
    final dataProvider = Provider.of<DataProvider>(context);

    final pedidosFiltrados = dataProvider.pedidos.where((p) {
      if (_selectedFilter == 'todos') return true;
      if (_selectedFilter == 'pendientes')
        return p.estado == EstadoPedido.recibido;
      if (_selectedFilter == 'proceso')
        return [
          EstadoPedido.enProduccion,
          EstadoPedido.enCorte,
          EstadoPedido.enConfeccion,
          EstadoPedido.enEstampado,
          EstadoPedido.listo,
          EstadoPedido.enviado,
        ].contains(p.estado);
      if (_selectedFilter == 'completados')
        return p.estado == EstadoPedido.entregado;
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
          'Mis Pedidos',
          style: TextStyle(
            color: colors.text,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Todos', 'todos', colors),
                  const SizedBox(width: 8),
                  _buildFilterChip('Pendientes', 'pendientes', colors),
                  const SizedBox(width: 8),
                  _buildFilterChip('En Proceso', 'proceso', colors),
                  const SizedBox(width: 8),
                  _buildFilterChip('Completados', 'completados', colors),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: pedidosFiltrados.length,
              itemBuilder: (context, index) {
                final pedido = pedidosFiltrados[index];
                return _buildPedidoCard(pedido, colors);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, dynamic colors) {
    final isSelected = _selectedFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = value),
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
                ? (widget.isDarkMode ? Colors.black : Colors.white)
                : colors.text,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildPedidoCard(Pedido pedido, dynamic colors) {
    Color estadoColor;
    String estadoTexto;

    switch (pedido.estado) {
      case EstadoPedido.recibido:
        estadoColor = colors.warning;
        estadoTexto = 'Pendiente';
        break;
      case EstadoPedido.enProduccion:
        estadoColor = colors.info;
        estadoTexto = 'En Producción';
        break;
      case EstadoPedido.entregado:
        estadoColor = colors.success;
        estadoTexto = 'Entregado';
        break;
      case EstadoPedido.cancelado:
        estadoColor = colors.error;
        estadoTexto = 'Cancelado';
        break;
      default:
        estadoColor = colors.textSecondary;
        estadoTexto = 'Desconocido';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pedido #${pedido.id}',
                style: TextStyle(
                  color: colors.text,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: estadoColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  estadoTexto,
                  style: TextStyle(
                    color: estadoColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.person_outline, color: colors.textSecondary, size: 16),
              const SizedBox(width: 8),
              Text(
                pedido.clienteNombre,
                style: TextStyle(color: colors.text, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today, color: colors.textSecondary, size: 16),
              const SizedBox(width: 8),
              Text(
                Formatters.formatDate(pedido.fechaCreacion),
                style: TextStyle(color: colors.textSecondary, fontSize: 12),
              ),
            ],
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
                    style: TextStyle(color: colors.textSecondary, fontSize: 11),
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
                    style: TextStyle(color: colors.textSecondary, fontSize: 11),
                  ),
                  Text(
                    Formatters.formatCurrency(pedido.saldo),
                    style: TextStyle(
                      color: pedido.saldo > 0 ? colors.error : colors.success,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colors.border),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Ver Detalle',
                    style: TextStyle(color: colors.text, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
