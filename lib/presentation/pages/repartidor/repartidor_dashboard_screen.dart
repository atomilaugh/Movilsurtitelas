import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:movilsurtitela/domain/entities/user.dart';
import 'package:movilsurtitela/utils/app_colors.dart';
import 'package:movilsurtitela/utils/formatters.dart';
import 'package:movilsurtitela/presentation/widgets/common/custom_components.dart';
import 'package:movilsurtitela/presentation/pages/repartidor/repartidor_entregas_pendientes_screen.dart';
import 'package:movilsurtitela/presentation/pages/repartidor/entregas_completadas_screen.dart';
import 'package:movilsurtitela/presentation/pages/repartidor/devoluciones_screen.dart';
import 'package:movilsurtitela/presentation/pages/repartidor/repartidor_perfil_screen.dart';
import 'package:movilsurtitela/presentation/pages/repartidor/rastreo_entrega_screen.dart';

class RepartidorDashboardScreen extends StatefulWidget {
  final User user;
  final VoidCallback onLogout;
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const RepartidorDashboardScreen({
    super.key,
    required this.user,
    required this.onLogout,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<RepartidorDashboardScreen> createState() => _RepartidorDashboardScreenState();
}

class _RepartidorDashboardScreenState extends State<RepartidorDashboardScreen> {
  int _selectedIndex = 0;
  bool _isAvailable = true;
  int _entregasPendientes = 6;
  int _entregasCompletadas = 3;

  final List<Map<String, dynamic>> _entregasHoy = [
    {
      'id': 'ent001',
      'cliente': 'Colegio San José',
      'direccion': 'Cra 15 #45-67, Medellín',
      'hora': '10:00 AM',
      'prioridad': 'urgente',
      'estado': 'en_camino',
    },
    {
      'id': 'ent002',
      'cliente': 'Distribuidora El Rey',
      'direccion': 'Calle 50 #30-20, Bogotá',
      'hora': '11:30 AM',
      'prioridad': 'normal',
      'estado': 'asignada',
    },
    {
      'id': 'ent003',
      'cliente': 'Juan Pérez',
      'direccion': 'Av 68 #23-45, Cali',
      'hora': '2:00 PM',
      'prioridad': 'normal',
      'estado': 'asignada',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Scaffold(
      backgroundColor: colors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(colors, isDark),
            const SizedBox(height: 24),
            _buildEstadoDiaCard(colors, isDark),
            const SizedBox(height: 24),
            _buildMetricsCards(colors, isDark),
            const SizedBox(height: 24),
            _buildSalesChart(colors, isDark),
            const SizedBox(height: 24),
            _buildEntregasHoy(colors, isDark),
            const SizedBox(height: 24),
            _buildQuickActions(colors, isDark),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(colors, isDark),
    );
  }

  Widget _buildHeader(dynamic colors, bool isDark) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hola, ${widget.user.name.split(' ').first} 👋',
              style: TextStyle(
                color: colors.text,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Repartidor',
              style: TextStyle(
                color: colors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const Spacer(),
        Stack(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colors.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.notifications_none, color: colors.text, size: 24),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: colors.error,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '2',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: colors.surfaceElevated,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.person_outline, color: colors.text, size: 24),
        ),
      ],
    );
  }

  Widget _buildEstadoDiaCard(dynamic colors, bool isDark) {
    final progreso = _entregasCompletadas / _entregasPendientes;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_shipping, color: Colors.white, size: 32),
              const SizedBox(width: 12),
              Text(
                'Tienes $_entregasPendientes entregas pendientes hoy',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progreso,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 12,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_entregasCompletadas/$_entregasPendientes completadas',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                '${(progreso * 100).toInt()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.map, color: Colors.white),
              label: const Text(
                'Ver Ruta del Día',
                style: TextStyle(color: Colors.white),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white30),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsCards(dynamic colors, bool isDark) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _buildMetricCard(
          'Entregas Hoy',
          '$_entregasCompletadas/$_entregasPendientes',
          Icons.local_shipping,
          const Color(0xFF10B981),
          colors,
          isDark,
        ),
        _buildMetricCard(
          'Entregas Mes',
          '45',
          Icons.calendar_month,
          const Color(0xFF3B82F6),
          colors,
          isDark,
        ),
        _buildMetricCard(
          'Eficiencia',
          '98.5%',
          Icons.trending_up,
          const Color(0xFFF59E0B),
          colors,
          isDark,
        ),
        _buildMetricCard(
          'Devoluciones',
          '2',
          Icons.assignment_return,
          const Color(0xFFEF4444),
          colors,
          isDark,
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    String label,
    String value,
    IconData icon,
    Color iconColor,
    dynamic colors,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const Spacer(),
          Text(
            label,
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: colors.text,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesChart(dynamic colors, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Entregas últimos 7 días',
            style: TextStyle(
              color: colors.text,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            days[value.toInt()],
                            style: TextStyle(color: colors.textSecondary, fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 8, color: const Color(0xFF10B981))]),
                  BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 10, color: const Color(0xFF10B981))]),
                  BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 5, color: const Color(0xFF10B981))]),
                  BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 7, color: const Color(0xFF10B981))]),
                  BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 9, color: const Color(0xFF10B981))]),
                  BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 6, color: const Color(0xFFEF4444))]),
                  BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 3, color: const Color(0xFF10B981))]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntregasHoy(dynamic colors, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Entregas de Hoy',
          style: TextStyle(
            color: colors.text,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ..._entregasHoy.map((entrega) {
          final isUrgent = entrega['prioridad'] == 'urgente';
          final inProgress = entrega['estado'] == 'en_camino';

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isUrgent ? colors.error : colors.border,
                width: isUrgent ? 1.5 : 1,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: inProgress ? colors.successBg : colors.surfaceElevated,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.local_shipping,
                        color: inProgress ? colors.success : colors.textTertiary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  entrega['cliente'],
                                  style: TextStyle(
                                    color: colors.text,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (isUrgent)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: colors.errorBg,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Urgente',
                                    style: TextStyle(
                                      color: colors.error,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            entrega['direccion'],
                            style: TextStyle(color: colors.textSecondary, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          entrega['hora'],
                          style: TextStyle(
                            color: colors.text,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '#${entrega['id']}',
                          style: TextStyle(color: colors.textTertiary, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.map, size: 18, color: colors.primary),
                        label: Text('Ver Mapa', style: TextStyle(color: colors.primary)),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: colors.border),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildQuickActions(dynamic colors, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Accesos Rápidos',
          style: TextStyle(
            color: colors.text,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            _buildActionButton('Ruta del Día', Icons.map, colors, isDark),
            _buildActionButton('Entregas Pendientes', Icons.inbox, colors, isDark),
            _buildActionButton('Entregas Completadas', Icons.check_circle, colors, isDark),
            _buildActionButton('Devoluciones', Icons.assignment_return, colors, isDark),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, dynamic colors, bool isDark) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.surfaceElevated,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: colors.primary, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.text,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation(dynamic colors, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border, width: 1)),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Inicio', 0, colors, isDark),
            _buildNavItem(Icons.local_shipping, 'Entregas', 1, colors, isDark),
            _buildNavItem(Icons.check_circle, 'Completadas', 2, colors, isDark),
            _buildNavItem(Icons.person, 'Perfil', 3, colors, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, dynamic colors, bool isDark) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() => _selectedIndex = index);
        if (index == 1) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => 
            const RepartidorEntregasPendientesScreen()
          ));
        } else if (index == 2) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => 
            EntregasCompletadasScreen(isDarkMode: widget.isDarkMode)
          ));
        } else if (index == 3) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => 
            RepartidorPerfilScreen(
              user: widget.user,
              onLogout: widget.onLogout,
              onThemeToggle: widget.onThemeToggle,
              isDarkMode: widget.isDarkMode,
            )
          ));
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? colors.primary : colors.textTertiary,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? colors.primary : colors.textTertiary,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}