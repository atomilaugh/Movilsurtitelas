import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movilsurtitela/domain/entities/domicilio.dart';
import 'package:movilsurtitela/providers/data_provider.dart';
import 'package:movilsurtitela/utils/app_colors.dart';
import 'package:movilsurtitela/utils/formatters.dart';

class DomiciliosScreen extends StatefulWidget {
  const DomiciliosScreen({super.key});

  @override
  State<DomiciliosScreen> createState() => _DomiciliosScreenState();
}

class _DomiciliosScreenState extends State<DomiciliosScreen> {
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
          'Domicilios',
          style: TextStyle(color: colors.text, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: colors.surface,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Todos', 'todos', colors),
                  const SizedBox(width: 8),
                  _buildFilterChip('Pendiente', 'pendiente', colors),
                  const SizedBox(width: 8),
                  _buildFilterChip('En camino', 'enCamino', colors),
                  const SizedBox(width: 8),
                  _buildFilterChip('Entregado', 'entregado', colors),
                  const SizedBox(width: 8),
                  _buildFilterChip('Fallido', 'fallido', colors),
                ],
              ),
            ),
          ),
          Expanded(
            child: Consumer<DataProvider>(
              builder: (context, dataProvider, _) {
                var domicilios = dataProvider.domicilios;

                if (_filter != 'todos') {
                  try {
                    final estado = EstadoDomicilio.values.firstWhere((e) => e.name == _filter);
                    domicilios = domicilios.where((d) => d.estado == estado).toList();
                  } catch (_) {}
                }

                if (domicilios.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_shipping_outlined, size: 64, color: colors.textTertiary),
                        const SizedBox(height: 16),
                        Text(
                          'No hay domicilios',
                          style: TextStyle(color: colors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: domicilios.length,
                  itemBuilder: (context, index) {
                    return _buildDomicilioCard(domicilios[index], colors, isDark);
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

  Widget _buildDomicilioCard(Domicilio domicilio, dynamic colors, bool isDark) {
    Color statusColor;
    Color statusBg;
    IconData statusIcon;
    
    switch (domicilio.estado) {
      case EstadoDomicilio.entregado:
        statusColor = colors.success;
        statusBg = colors.successBg;
        statusIcon = Icons.check_circle;
        break;
      case EstadoDomicilio.enCamino:
        statusColor = colors.warning;
        statusBg = colors.warningBg;
        statusIcon = Icons.local_shipping;
        break;
      case EstadoDomicilio.fallido:
        statusColor = colors.error;
        statusBg = colors.errorBg;
        statusIcon = Icons.error;
        break;
      case EstadoDomicilio.pendiente:
        statusColor = colors.textTertiary;
        statusBg = colors.surfaceElevated;
        statusIcon = Icons.schedule;
        break;
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      domicilio.clienteNombre,
                      style: TextStyle(
                        color: colors.text,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Pedido #${domicilio.pedidoId}',
                      style: TextStyle(color: colors.textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 12, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      domicilio.estado.name.replaceAll('enCamino', 'en camino'),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.location_on, size: 14, color: colors.textTertiary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${domicilio.direccion}, ${domicilio.ciudad}',
                  style: TextStyle(color: colors.textSecondary, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (domicilio.repartidorNombre != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person, size: 14, color: colors.textTertiary),
                const SizedBox(width: 4),
                Text(
                  'Repartidor: ${domicilio.repartidorNombre}',
                  style: TextStyle(color: colors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ],
          if (domicilio.fechaEntrega != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: colors.textTertiary),
                const SizedBox(width: 4),
                Text(
                  'Entregado: ${Formatters.formatDateTime(domicilio.fechaEntrega!)}',
                  style: TextStyle(color: colors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ],
          if (domicilio.estado == EstadoDomicilio.pendiente) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colors.border),
                    ),
                    child: Text('Asignar', style: TextStyle(color: colors.text)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}