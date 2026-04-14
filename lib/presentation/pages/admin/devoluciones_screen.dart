import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movilsurtitela/domain/entities/devolucion.dart';
import 'package:movilsurtitela/providers/data_provider.dart';
import 'package:movilsurtitela/utils/app_colors.dart';
import 'package:movilsurtitela/utils/formatters.dart';

class DevolucionesScreen extends StatefulWidget {
  const DevolucionesScreen({super.key});

  @override
  State<DevolucionesScreen> createState() => _DevolucionesScreenState();
}

class _DevolucionesScreenState extends State<DevolucionesScreen> {
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
          'Devoluciones',
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
                  _buildFilterChip('Solicitada', 'solicitada', colors),
                  const SizedBox(width: 8),
                  _buildFilterChip('En revisión', 'enRevision', colors),
                  const SizedBox(width: 8),
                  _buildFilterChip('Aprobada', 'aprobada', colors),
                  const SizedBox(width: 8),
                  _buildFilterChip('Rechazada', 'rechazada', colors),
                  const SizedBox(width: 8),
                  _buildFilterChip('Completada', 'completada', colors),
                ],
              ),
            ),
          ),
          Expanded(
            child: Consumer<DataProvider>(
              builder: (context, dataProvider, _) {
                var devoluciones = dataProvider.devoluciones;

                if (_filter != 'todos') {
                  try {
                    final estado = EstadoDevolucion.values.firstWhere((e) => e.name == _filter);
                    devoluciones = devoluciones.where((d) => d.estado == estado).toList();
                  } catch (_) {}
                }

                if (devoluciones.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.assignment_return_outlined, size: 64, color: colors.textTertiary),
                        const SizedBox(height: 16),
                        Text(
                          'No hay devoluciones',
                          style: TextStyle(color: colors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: devoluciones.length,
                  itemBuilder: (context, index) {
                    return _buildDevolucionCard(devoluciones[index], colors, isDark);
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

  Widget _buildDevolucionCard(Devolucion devolucion, dynamic colors, bool isDark) {
    Color statusColor;
    Color statusBg;
    
    switch (devolucion.estado) {
      case EstadoDevolucion.completada:
        statusColor = colors.success;
        statusBg = colors.successBg;
        break;
      case EstadoDevolucion.aprobada:
        statusColor = colors.success;
        statusBg = colors.successBg;
        break;
      case EstadoDevolucion.rechazada:
        statusColor = colors.error;
        statusBg = colors.errorBg;
        break;
      case EstadoDevolucion.enRevision:
        statusColor = colors.warning;
        statusBg = colors.warningBg;
        break;
      case EstadoDevolucion.solicitada:
        statusColor = colors.info;
        statusBg = colors.infoBg;
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
                      devolucion.clienteNombre,
                      style: TextStyle(
                        color: colors.text,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Pedido #${devolucion.pedidoId}',
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
                child: Text(
                  devolucion.estado.name.replaceAll('', ' ').trim(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Motivo:',
            style: TextStyle(
              color: colors.textTertiary,
              fontSize: 10,
            ),
          ),
          Text(
            devolucion.motivo,
            style: TextStyle(color: colors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Text(
            'Productos:',
            style: TextStyle(
              color: colors.textTertiary,
              fontSize: 10,
            ),
          ),
          ...devolucion.productos.map((p) => Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Icon(Icons.check_box_outlined, size: 14, color: colors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  '${p.productoNombre} (${p.cantidad})',
                  style: TextStyle(color: colors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          )),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: colors.textTertiary),
              const SizedBox(width: 4),
              Text(
                'Solicitado: ${Formatters.formatDate(devolucion.fechaSolicitud)}',
                style: TextStyle(color: colors.textTertiary, fontSize: 10),
              ),
            ],
          ),
          if (devolucion.resolucion != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colors.surfaceElevated,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Resolución: ${devolucion.resolucion}',
                style: TextStyle(color: colors.textSecondary, fontSize: 12),
              ),
            ),
          ],
          if (devolucion.estado == EstadoDevolucion.enRevision) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showResolveDialog(devolucion, colors, isDark, approved: true),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colors.success),
                    ),
                    child: Text('Aprobar', style: TextStyle(color: colors.success)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showResolveDialog(devolucion, colors, isDark, approved: false),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: colors.error),
                    ),
                    child: Text('Rechazar', style: TextStyle(color: colors.error)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _showResolveDialog(Devolucion devolucion, dynamic colors, bool isDark, {required bool approved}) {
    final controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text(
          approved ? 'Aprobar Devolución' : 'Rechazar Devolución',
          style: TextStyle(color: colors.text),
        ),
        content: TextField(
          controller: controller,
          style: TextStyle(color: colors.text),
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Escribe la resolución...',
            hintStyle: TextStyle(color: colors.textTertiary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: TextStyle(color: colors.textTertiary)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<DataProvider>().updateDevolucionEstado(
                devolucion.id,
                approved ? EstadoDevolucion.aprobada : EstadoDevolucion.rechazada,
                controller.text.isEmpty ? null : controller.text,
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: approved ? colors.success : colors.error,
            ),
            child: Text(
              approved ? 'Aprobar' : 'Rechazar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}