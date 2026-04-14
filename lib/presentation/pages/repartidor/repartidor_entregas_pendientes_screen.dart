import 'package:flutter/material.dart';
import 'package:movilsurtitela/domain/entities/user.dart';
import 'package:movilsurtitela/utils/app_colors.dart';
import 'package:movilsurtitela/utils/formatters.dart';
import 'package:movilsurtitela/presentation/widgets/common/custom_components.dart';
import 'package:movilsurtitela/presentation/pages/repartidor/rastreo_entrega_screen.dart';

class RepartidorEntregasPendientesScreen extends StatefulWidget {
  const RepartidorEntregasPendientesScreen({super.key});

  @override
  State<RepartidorEntregasPendientesScreen> createState() =>
      _RepartidorEntregasPendientesScreenState();
}

class _RepartidorEntregasPendientesScreenState
    extends State<RepartidorEntregasPendientesScreen> {
  String _selectedFilter = 'todas';

  void _showEstadoEntregaModal(Map<String, dynamic> entrega, dynamic colors) {
    int currentStep = 0;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            title: const Text('Estado de Entrega'),
            titleTextStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: colors.text,
            ),
            contentPadding: const EdgeInsets.all(24),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: currentStep >= 0
                            ? colors.primary
                            : colors.surface,
                        shape: BoxShape.circle,
                        boxShadow: currentStep >= 0
                            ? [
                                BoxShadow(
                                  color: colors.primary.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Icon(
                        Icons.inventory_2,
                        color: currentStep >= 0
                            ? (colors == AppColors.dark
                                  ? Colors.black
                                  : Colors.white)
                            : colors.textSecondary,
                        size: 24,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 2,
                        color: currentStep >= 1
                            ? colors.primary
                            : colors.border,
                      ),
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: currentStep >= 1
                            ? colors.primary
                            : colors.surface,
                        shape: BoxShape.circle,
                        border: currentStep < 1
                            ? Border.all(color: colors.border)
                            : null,
                      ),
                      child: Icon(
                        Icons.location_on,
                        color: currentStep >= 1
                            ? (colors == AppColors.dark
                                  ? Colors.black
                                  : Colors.white)
                            : colors.textSecondary,
                        size: 24,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 2,
                        color: currentStep >= 2
                            ? colors.primary
                            : colors.border,
                      ),
                    ),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: currentStep >= 2
                            ? colors.primary
                            : colors.surface,
                        shape: BoxShape.circle,
                        border: currentStep < 2
                            ? Border.all(color: colors.border)
                            : null,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: currentStep >= 2
                            ? (colors == AppColors.dark
                                  ? Colors.black
                                  : Colors.white)
                            : colors.textSecondary,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: currentStep < 2
                            ? () {
                                setModalState(() {
                                  currentStep++;
                                });
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          currentStep == 2 ? 'Finalizar' : 'Siguiente',
                          style: TextStyle(
                            color: colors == AppColors.dark
                                ? Colors.black
                                : Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: colors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Cerrar',
                          style: TextStyle(
                            color: colors.text,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.close, color: colors.text),
                onPressed: () => Navigator.pop(context),
              ),
            ],
            backgroundColor: colors.surface,
          );
        },
      ),
    );
  }

  String _selectedSort = 'hora';

  final List<Map<String, dynamic>> _entregas = [
    {
      'id': 'ent001',
      'pedidoId': 'ped001',
      'cliente': 'Colegio San José',
      'telefono': '3001234567',
      'direccion': 'Cra 15 #45-67, Medellín',
      'hora': '10:00 AM',
      'prioridad': 'urgente',
      'estado': 'en_camino',
      'productos': 150,
      'valor': 7500000,
      'contraEntrega': true,
      'observaciones': 'Entregar en portería principal',
    },
    {
      'id': 'ent002',
      'pedidoId': 'ped002',
      'cliente': 'Distribuidora El Rey',
      'telefono': '3109876543',
      'direccion': 'Calle 50 #30-20, Bogotá',
      'hora': '11:30 AM',
      'prioridad': 'normal',
      'estado': 'asignada',
      'productos': 80,
      'valor': 2800000,
      'contraEntrega': false,
    },
    {
      'id': 'ent003',
      'pedidoId': 'ped003',
      'cliente': 'Juan Pérez',
      'telefono': '3156789012',
      'direccion': 'Av 68 #23-45, Cali',
      'hora': '2:00 PM',
      'prioridad': 'normal',
      'estado': 'asignada',
      'productos': 10,
      'valor': 375000,
      'contraEntrega': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    var entregasFiltradas = _entregas.where((e) {
      if (_selectedFilter == 'todas') return true;
      if (_selectedFilter == 'hoy') return true;
      if (_selectedFilter == 'urgentes') return e['prioridad'] == 'urgente';
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
          'Entregas Pendientes',
          style: TextStyle(color: colors.text, fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${entregasFiltradas.length} entregas',
              style: TextStyle(color: colors.text),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildFilterChip('Todas', 'todas', colors),
                const SizedBox(width: 8),
                _buildFilterChip('Hoy', 'hoy', colors),
                const SizedBox(width: 8),
                _buildFilterChip('Urgentes', 'urgentes', colors),
              ],
            ),
            const SizedBox(height: 24),
            ...entregasFiltradas.map(
              (entrega) => _buildEntregaCard(entrega, colors),
            ),
          ],
        ),
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
                ? (colors == AppColors.dark ? Colors.black : Colors.white)
                : colors.text,
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildEntregaCard(Map<String, dynamic> entrega, dynamic colors) {
    final isUrgent = entrega['prioridad'] == 'urgente';
    final inProgress = entrega['estado'] == 'en_camino';

    return InkWell(
      onTap: () {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                RastreoEntregaScreen(entrega: entrega, isDarkMode: isDark),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUrgent ? colors.error : colors.border,
            width: isUrgent ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Text(
                      entrega['hora'],
                      style: TextStyle(
                        color: colors.text,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isUrgent)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colors.errorBg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'URGENTE',
                          style: TextStyle(
                            color: colors.error,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '#${entrega['id']}',
                            style: TextStyle(
                              color: colors.textTertiary,
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          StatusBadge(
                            text: entrega['estado'] == 'en_camino'
                                ? 'En Camino'
                                : 'Asignada',
                            status: entrega['estado'] == 'en_camino'
                                ? 'info'
                                : 'success',
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        entrega['cliente'],
                        style: TextStyle(
                          color: colors.text,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        entrega['direccion'],
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.shopping_bag, color: colors.textTertiary, size: 16),
                const SizedBox(width: 4),
                Text(
                  '${entrega['productos']} items',
                  style: TextStyle(color: colors.textSecondary, fontSize: 12),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.monetization_on,
                  color: colors.textTertiary,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  Formatters.formatCurrency(entrega['valor']),
                  style: TextStyle(color: colors.textSecondary, fontSize: 12),
                ),
                if (entrega['contraEntrega']) ...[
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colors.warningBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Contra Entrega',
                      style: TextStyle(color: colors.warning, fontSize: 10),
                    ),
                  ),
                ],
              ],
            ),
            if (entrega['observaciones'] != null &&
                entrega['observaciones'].isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.note_alt_outlined,
                      color: colors.textSecondary,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        entrega['observaciones'],
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Iniciar Entrega',
                    backgroundColor: inProgress
                        ? colors.success
                        : colors.primary,
                    onPressed: () => _showEstadoEntregaModal(entrega, colors),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.contact_phone, color: colors.primary),
                label: Text(
                  'Contactar Cliente',
                  style: TextStyle(color: colors.primary),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: colors.border),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
