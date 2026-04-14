import 'package:flutter/material.dart';
import 'package:movilsurtitela/utils/app_colors.dart';
import 'package:movilsurtitela/presentation/widgets/common/custom_components.dart';

class EntregasCompletadasScreen extends StatefulWidget {
  final bool isDarkMode;

  const EntregasCompletadasScreen({super.key, required this.isDarkMode});

  @override
  State<EntregasCompletadasScreen> createState() =>
      _EntregasCompletadasScreenState();
}

class _EntregasCompletadasScreenState extends State<EntregasCompletadasScreen> {
  void _showEntregaDetalle(Map<String, dynamic> entrega, dynamic colors) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(height: 24),
            Text(
              'Detalle de Entrega',
              style: TextStyle(
                color: colors.text,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildDetalleRow('Cliente', entrega['cliente'], colors),
            const SizedBox(height: 16),
            _buildDetalleRow('Dirección', entrega['direccion'], colors),
            const SizedBox(height: 16),
            _buildDetalleRow('Fecha', entrega['fecha'], colors),
            const SizedBox(height: 16),
            _buildDetalleRow('Hora', entrega['hora'], colors),
            const SizedBox(height: 16),
            _buildDetalleRow('Estado', 'Entregada ✓', colors, isSuccess: true),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: colors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Cerrar', style: TextStyle(color: colors.text)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetalleRow(
    String label,
    String value,
    dynamic colors, {
    bool isSuccess = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(color: colors.textSecondary, fontSize: 14),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: isSuccess ? colors.success : colors.text,
              fontSize: 14,
              fontWeight: isSuccess ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ],
    );
  }

  final List<Map<String, dynamic>> _entregasCompletadas = [
    {
      'id': 'ENT-001',
      'cliente': 'Colegio San José',
      'direccion': 'Cra 15 #45-67, Medellín',
      'fecha': '13/04/2026',
      'hora': '10:15 AM',
      'estado': 'completada',
    },
    {
      'id': 'ENT-002',
      'cliente': 'Distribuidora El Rey',
      'direccion': 'Calle 50 #30-20, Bogotá',
      'fecha': '13/04/2026',
      'hora': '11:45 AM',
      'estado': 'completada',
    },
    {
      'id': 'ENT-003',
      'cliente': 'Juan Pérez',
      'direccion': 'Av 68 #23-45, Cali',
      'fecha': '12/04/2026',
      'hora': '2:30 PM',
      'estado': 'completada',
    },
    {
      'id': 'ENT-004',
      'cliente': 'Empresa XYZ Ltda',
      'direccion': 'Carrera 7 #89-12, Medellín',
      'fecha': '12/04/2026',
      'hora': '4:15 PM',
      'estado': 'completada',
    },
    {
      'id': 'ENT-005',
      'cliente': 'María González',
      'direccion': 'Transversal 20 #15-30, Barranquilla',
      'fecha': '11/04/2026',
      'hora': '9:30 AM',
      'estado': 'completada',
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
          'Entregas Completadas',
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
        itemCount: _entregasCompletadas.length,
        itemBuilder: (context, index) {
          final entrega = _entregasCompletadas[index];
          return InkWell(
            onTap: () => _showEntregaDetalle(entrega, colors),
            borderRadius: BorderRadius.circular(12),
            child: Container(
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
                      color: colors.successBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.check_circle_outline,
                      color: colors.success,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entrega['cliente'],
                          style: TextStyle(
                            color: colors.text,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          entrega['direccion'],
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${entrega['fecha']} • ${entrega['hora']}',
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
            ),
          );
        },
      ),
    );
  }
}
