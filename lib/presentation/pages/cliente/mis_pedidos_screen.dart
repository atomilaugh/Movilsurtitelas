import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movilsurtitela/utils/app_colors.dart';

enum EstadoPedido {
  recibido,
  enProduccion,
  enCorte,
  enConfeccion,
  enEstampado,
  listo,
  enviado,
  entregado,
  cancelado,
}

class Pedido {
  final String id;
  final List<dynamic> items;
  final double total;
  final EstadoPedido estado;
  final DateTime fechaCreacion;
  final DateTime fechaEntregaEstimada;

  Pedido({
    required this.id,
    required this.items,
    required this.total,
    required this.estado,
    required this.fechaCreacion,
    required this.fechaEntregaEstimada,
  });
}

class MisPedidosScreen extends StatelessWidget {
  final List<Pedido> pedidos;
  final VoidCallback? onRastrear;

  const MisPedidosScreen({
    super.key,
    required this.pedidos,
    this.onRastrear,
  });

  Map<EstadoPedido, Map<String, dynamic>> _getEstadoInfo(AppColorsTheme colors) {
    return {
      EstadoPedido.recibido: {
        'label': 'Recibido',
        'icon': Icons.inventory_2,
        'color': colors.info,
        'bg': colors.infoBg,
        'step': 1,
      },
      EstadoPedido.enProduccion: {
        'label': 'En Producción',
        'icon': Icons.access_time,
        'color': colors.warning,
        'bg': colors.warningBg,
        'step': 2,
      },
      EstadoPedido.enCorte: {
        'label': 'En Corte',
        'icon': Icons.access_time,
        'color': colors.warning,
        'bg': colors.warningBg,
        'step': 2,
      },
      EstadoPedido.enConfeccion: {
        'label': 'En Confección',
        'icon': Icons.access_time,
        'color': colors.warning,
        'bg': colors.warningBg,
        'step': 2,
      },
      EstadoPedido.enEstampado: {
        'label': 'En Estampado',
        'icon': Icons.access_time,
        'color': colors.warning,
        'bg': colors.warningBg,
        'step': 2,
      },
      EstadoPedido.listo: {
        'label': 'Listo para Envío',
        'icon': Icons.check_circle,
        'color': colors.success,
        'bg': colors.successBg,
        'step': 3,
      },
      EstadoPedido.enviado: {
        'label': 'En Camino',
        'icon': Icons.local_shipping,
        'color': colors.accent,
        'bg': colors.accentLight,
        'step': 4,
      },
      EstadoPedido.entregado: {
        'label': 'Entregado',
        'icon': Icons.check_circle,
        'color': colors.success,
        'bg': colors.successBg,
        'step': 5,
      },
      EstadoPedido.cancelado: {
        'label': 'Cancelado',
        'icon': Icons.cancel,
        'color': colors.error,
        'bg': colors.errorBg,
        'step': 0,
      },
    };
  }

  List<Map<String, dynamic>> _getProgressSteps(EstadoPedido estado, AppColorsTheme colors) {
    final estadoInfo = _getEstadoInfo(colors);
    final currentStep = estadoInfo[estado]?['step'] ?? 0;

    final steps = [
      {'label': 'Recibido', 'step': 1},
      {'label': 'En Producción', 'step': 2},
      {'label': 'Listo', 'step': 3},
      {'label': 'En Camino', 'step': 4},
      {'label': 'Entregado', 'step': 5},
    ];

    return steps.map((s) {
      return {
        ...s,
        'completed': currentStep >= s['step'] && estado != EstadoPedido.cancelado,
        'current': currentStep == s['step'],
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colors.surface,
                border: Border(bottom: BorderSide(color: colors.border)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: colors.surfaceElevated,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.arrow_back, color: colors.text),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Mis Pedidos',
                        style: TextStyle(
                          color: colors.text,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const SizedBox(width: 56),
                      Text(
                        '${pedidos.length} ${pedidos.length == 1 ? 'pedido' : 'pedidos'}',
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: pedidos.isEmpty
                  ? _buildEmptyState(colors)
                  : ListView.builder(
                      padding: const EdgeInsets.all(24),
                      itemCount: pedidos.length,
                      itemBuilder: (context, index) {
                        return _buildPedidoCard(colors, pedidos[index]);
                      },
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
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inventory_2,
              size: 48,
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No tienes pedidos',
            style: TextStyle(
              color: colors.text,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tus pedidos aparecerán aquí una vez\nrealices una compra',
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

  Widget _buildPedidoCard(AppColorsTheme colors, Pedido pedido) {
    final estadoInfo = _getEstadoInfo(colors)[pedido.estado]!;
    final progressSteps = _getProgressSteps(pedido.estado, colors);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.border)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pedido #${pedido.id}',
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          NumberFormat.currency(
                            symbol: '\$',
                            decimalDigits: 0,
                            locale: 'es_CO',
                          ).format(pedido.total),
                          style: TextStyle(
                            color: colors.text,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: estadoInfo['bg'],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            estadoInfo['icon'],
                            color: estadoInfo['color'],
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            estadoInfo['label'],
                            style: TextStyle(
                              color: estadoInfo['color'],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Realizado el ${DateFormat('d MMM yyyy', 'es_ES').format(pedido.fechaCreacion)}',
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (pedido.estado != EstadoPedido.cancelado)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: colors.border)),
              ),
              child: Column(
                children: [
                  Row(
                    children: List.generate(progressSteps.length, (index) {
                      final step = progressSteps[index];
                      final completed = step['completed'] as bool;
                      final current = step['current'] as bool;

                      return Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: completed ? colors.accent : colors.surface,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: completed ? colors.accent : colors.border,
                                  width: 2,
                                ),
                              ),
                              child: completed
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    )
                                  : null,
                            ),
                            if (index < progressSteps.length - 1)
                              Expanded(
                                child: Container(
                                  height: 2,
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  color: completed && progressSteps[index + 1]['completed']
                                      ? colors.accent
                                      : colors.border,
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: progressSteps.map((step) {
                      final completed = step['completed'] as bool;
                      final current = step['current'] as bool;

                      return Expanded(
                        child: Text(
                          step['label'],
                          style: TextStyle(
                            color: completed ? colors.text : colors.textTertiary,
                            fontSize: 10,
                            fontWeight: current ? FontWeight.w600 : FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Productos (${pedido.items.length})',
                  style: TextStyle(
                    color: colors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                ...pedido.items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${item.cantidad}x ${item.productoNombre} (${item.talla}, ${item.color})',
                            style: TextStyle(
                              color: colors.text,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Text(
                          NumberFormat.currency(
                            symbol: '\$',
                            decimalDigits: 0,
                            locale: 'es_CO',
                          ).format(item.subtotal),
                          style: TextStyle(
                            color: colors.text,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                if (pedido.estado != EstadoPedido.entregado &&
                    pedido.estado != EstadoPedido.cancelado) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.surfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: colors.accent,
                          size: 16,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Entrega estimada',
                              style: TextStyle(
                                color: colors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              DateFormat('d MMM yyyy', 'es_ES')
                                  .format(pedido.fechaEntregaEstimada),
                              style: TextStyle(
                                color: colors.text,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
