import 'package:flutter/material.dart';
import 'package:movilsurtitela/domain/entities/user.dart';
import 'package:movilsurtitela/utils/app_colors.dart';
import 'package:movilsurtitela/presentation/widgets/common/custom_components.dart';

class RepartidorPerfilScreen extends StatefulWidget {
  final User user;
  final VoidCallback onLogout;
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const RepartidorPerfilScreen({
    super.key,
    required this.user,
    required this.onLogout,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<RepartidorPerfilScreen> createState() => _RepartidorPerfilScreenState();
}

class _RepartidorPerfilScreenState extends State<RepartidorPerfilScreen> {
  bool _notificationsEnabled = true;
  bool _isAvailable = true;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.text),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: colors.surfaceElevated,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.person_outline,
                      size: 48,
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.user.name,
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Repartidor',
                    style: TextStyle(color: colors.textSecondary, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Container(
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
                    'Información del Vehículo',
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow(Icons.two_wheeler, 'Tipo', 'Moto', colors),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    Icons.confirmation_number,
                    'Placa',
                    'ABC123',
                    colors,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.check_circle, 'Estado', 'Activo', colors),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                _buildStatCard(
                  'Entregas Mes',
                  '45',
                  Icons.local_shipping,
                  colors,
                  isDark,
                ),
                _buildStatCard(
                  'Tasa Éxito',
                  '98.5%',
                  Icons.trending_up,
                  colors,
                  isDark,
                ),
                _buildStatCard(
                  'Entregas Totales',
                  '320',
                  Icons.inventory,
                  colors,
                  isDark,
                ),
                _buildStatCard(
                  'Calificación',
                  '⭐ 4.8/5',
                  Icons.star,
                  colors,
                  isDark,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border),
              ),
              child: Column(
                children: [
                  _buildSwitchRow(
                    Icons.location_on,
                    'Disponible para entregas',
                    _isAvailable,
                    (value) => setState(() => _isAvailable = value),
                    colors,
                  ),
                  const SizedBox(height: 12),
                  _buildSwitchRow(
                    Icons.dark_mode,
                    'Modo Oscuro',
                    widget.isDarkMode,
                    (value) => widget.onThemeToggle(),
                    colors,
                  ),
                  const SizedBox(height: 12),
                  _buildSwitchRow(
                    Icons.notifications,
                    'Notificaciones',
                    _notificationsEnabled,
                    (value) => setState(() => _notificationsEnabled = value),
                    colors,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colors.border),
              ),
              child: Column(
                children: [
                  _buildMenuItem(Icons.bar_chart, 'Mis Estadísticas', colors),
                  Divider(color: colors.border),
                  _buildMenuItem(Icons.map, 'Historial de Rutas', colors),
                  Divider(color: colors.border),
                  _buildMenuItem(Icons.help_outline, 'Ayuda y Soporte', colors),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Cerrar Sesión',
              icon: Icons.logout,
              backgroundColor: colors.error,
              onPressed: widget.onLogout,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    dynamic colors,
  ) {
    return Row(
      children: [
        Icon(icon, color: colors.textSecondary, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: colors.textTertiary, fontSize: 12),
            ),
            Text(value, style: TextStyle(color: colors.text, fontSize: 14)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: colors.primary, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: colors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: colors.text,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(
    IconData icon,
    String label,
    bool value,
    Function(bool) onChanged,
    dynamic colors,
  ) {
    return Row(
      children: [
        Icon(icon, color: colors.text, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: colors.text, fontSize: 14),
          ),
        ),
        Switch(value: value, onChanged: onChanged, activeColor: colors.primary),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String label, dynamic colors) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: colors.text, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(color: colors.text, fontSize: 14),
              ),
            ),
            Icon(Icons.chevron_right, color: colors.textTertiary),
          ],
        ),
      ),
    );
  }
}
