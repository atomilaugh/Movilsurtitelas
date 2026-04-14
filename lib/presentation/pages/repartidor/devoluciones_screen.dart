import 'package:flutter/material.dart';
import 'package:movilsurtitela/utils/app_colors.dart';
import 'package:movilsurtitela/presentation/widgets/common/custom_components.dart';

class DevolucionesScreen extends StatefulWidget {
  final bool isDarkMode;

  const DevolucionesScreen({
    super.key,
    required this.isDarkMode,
  });

  @override
  State<DevolucionesScreen> createState() => _DevolucionesScreenState();
}

class _DevolucionesScreenState extends State<DevolucionesScreen> {
  final List<Map<String, dynamic>> _devolucionesPendientes = [
    {
      'id': 'DEV-001',
      'cliente': 'Tienda ABC',
      'direccion': 'Calle 10 #25-30, Medellín',
      'motivo': 'Producto dañado',
      'fecha': '13/04/2026',
      'estado': 'pendiente',
    },
    {
      'id': 'DEV-002',
      'cliente': 'Carlos Ramírez',
      'direccion': 'Av 30 #18-45, Bogotá',
      'motivo': 'Talla incorrecta',
      'fecha': '12/04/2026',
      'estado': 'en_proceso',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        title: Text(
          'Devoluciones Pendientes',
          style: TextStyle(
            color: colors.text,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: _devolucionesPendientes.length,
        itemBuilder: (context, index) {
          final devolucion = _devolucionesPendientes[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: colors.warningBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.undo_outlined,
                    color: colors.warning,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        devolucion['cliente'],
                        style: TextStyle(
                          color: colors.text,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Motivo: ${devolucion['motivo']}',
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        devolucion['fecha'],
                        style: TextStyle(
                          color: colors.textTertiary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: colors.textSecondary,
                  size: 16,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
