import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movilsurtitela/domain/entities/user.dart';
import 'package:movilsurtitela/domain/entities/pedido.dart';
import 'package:movilsurtitela/providers/data_provider.dart';
import 'package:movilsurtitela/utils/app_colors.dart';
import 'package:movilsurtitela/utils/formatters.dart';
import 'package:movilsurtitela/presentation/pages/admin/clientes_screen.dart';
import 'package:movilsurtitela/presentation/pages/admin/productos_screen.dart';
import 'package:movilsurtitela/presentation/pages/admin/pedidos_screen.dart';
import 'package:movilsurtitela/presentation/pages/admin/abonos_screen.dart';
import 'package:movilsurtitela/presentation/pages/admin/inventario_screen.dart';
import 'package:movilsurtitela/presentation/pages/admin/produccion_screen.dart';
import 'package:movilsurtitela/presentation/pages/admin/domicilios_screen.dart';
import 'package:movilsurtitela/presentation/pages/admin/devoluciones_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  final User user;
  final VoidCallback onLogout;
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const AdminDashboardScreen({
    super.key,
    required this.user,
    required this.onLogout,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(colors, isDark),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildKPISection(colors, isDark),
                      const SizedBox(height: 24),
                      _buildQuickActions(colors, isDark),
                      const SizedBox(height: 24),
                      _buildAlertsSection(colors),
                      const SizedBox(height: 24),
                      _buildRecentActivitySection(colors),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(colors, isDark),
    );
  }

  Widget _buildHeader(dynamic colors, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: AssetImage(
                          isDark 
                            ? 'assets/images/02835ac5-4140-4bab-b953-6c025775f772.jpg'
                            : 'assets/images/b8d9c351-54f3-4f66-acae-650ec61f619e.jpg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SurtiCamisetas',
                        style: TextStyle(color: colors.text, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        _getGreeting(),
                        style: TextStyle(color: colors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  _buildCircleButton(
                    isDark ? Icons.wb_sunny : Icons.nightlight_round,
                    colors,
                    widget.onThemeToggle,
                  ),
                  const SizedBox(width: 8),
                  _buildCircleButton(Icons.notifications, colors, null, badge: '3'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: colors.textTertiary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Buscar...',
                    style: TextStyle(color: colors.textTertiary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, colors, VoidCallback? onTap, {String? badge}) {
    return Stack(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: colors.text, size: 20),
          ),
        ),
        if (badge != null)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(color: colors.error, shape: BoxShape.circle),
              child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
      ],
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días';
    if (hour < 18) return 'Buenas tardes';
    return 'Buenas noches';
  }

  Widget _buildKPISection(dynamic colors, bool isDark) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumen',
              style: TextStyle(color: colors.text, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _buildKPICard(
                  'Ventas mes',
                  Formatters.formatCurrency(dataProvider.ventasDelMes),
                  Icons.trending_up,
                  const Color(0xFF10B981),
                  colors,
                ),
                _buildKPICard(
                  'Ventas hoy',
                  Formatters.formatCurrency(dataProvider.ventasHoy),
                  Icons.today,
                  const Color(0xFF3B82F6),
                  colors,
                ),
                _buildKPICard(
                  'Pedidos',
                  dataProvider.pedidosEnProduccion.toString(),
                  Icons.shopping_bag,
                  const Color(0xFFF59E0B),
                  colors,
                ),
                _buildKPICard(
                  'Clientes',
                  dataProvider.clientesActivos.toString(),
                  Icons.people,
                  const Color(0xFF8B5CF6),
                  colors,
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildKPICard(String label, String value, IconData icon, Color accent, dynamic colors) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: accent, size: 16),
          ),
          const Spacer(),
          Text(value, style: TextStyle(color: colors.text, fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(color: colors.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildQuickActions(dynamic colors, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones rápidas',
          style: TextStyle(color: colors.text, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildActionChip('Nuevo pedido', Icons.add_shopping_cart, const Color(0xFF3B82F6), colors, () => _navigateTo(const PedidosScreen()))),
            const SizedBox(width: 8),
            Expanded(child: _buildActionChip('Cliente', Icons.person_add, const Color(0xFF10B981), colors, () => _navigateTo(const ClientesScreen()))),
            const SizedBox(width: 8),
            Expanded(child: _buildActionChip('Pago', Icons.payment, const Color(0xFFF59E0B), colors, () => _navigateTo(const AbonosScreen()))),
          ],
        ),
      ],
    );
  }

  Widget _buildActionChip(String label, IconData icon, Color color, dynamic colors, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.border),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(color: colors.text, fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsSection(dynamic colors) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, _) {
        final saldo = dataProvider.saldoPendiente;
        final stock = dataProvider.productosStockBajo;
        final domi = dataProvider.domiciliosPendientes;

        if (saldo == 0 && stock == 0 && domi == 0) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber, color: colors.warning, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Alertas',
                  style: TextStyle(color: colors.text, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (saldo > 0) _buildAlertTile('Cobrar ${Formatters.formatCurrency(saldo)}', Icons.attach_money, colors.warning, colors),
            if (stock > 0) _buildAlertTile('$stock productos con stock bajo', Icons.inventory, colors.error, colors),
            if (domi > 0) _buildAlertTile('$domi domicilios pendientes', Icons.local_shipping, colors.info, colors),
          ],
        );
      },
    );
  }

  Widget _buildAlertTile(String text, IconData icon, Color color, dynamic colors) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyle(color: colors.text, fontWeight: FontWeight.w500))),
          Icon(Icons.chevron_right, color: colors.textTertiary, size: 20),
        ],
      ),
    );
  }

  Widget _buildRecentActivitySection(dynamic colors) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pedidos recientes',
                  style: TextStyle(color: colors.text, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => _navigateTo(const PedidosScreen()),
                  child: Text('Ver todos', style: TextStyle(color: colors.primary)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...dataProvider.pedidosRecientes.take(3).map((p) => _buildPedidoCard(p, colors)),
          ],
        );
      },
    );
  }

  Widget _buildPedidoCard(Pedido pedido, dynamic colors) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.receipt_long, color: colors.textSecondary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pedido.clienteNombre, style: TextStyle(color: colors.text, fontWeight: FontWeight.w600)),
                Text('#${pedido.id} • ${Formatters.formatDate(pedido.fechaCreacion)}', style: TextStyle(color: colors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(Formatters.formatCurrency(pedido.total), style: TextStyle(color: colors.text, fontWeight: FontWeight.bold)),
              _buildMiniBadge(pedido.estado, colors),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniBadge(EstadoPedido estado, dynamic colors) {
    Color color;
    IconData icon;
    switch (estado) {
      case EstadoPedido.entregado:
        color = colors.success;
        icon = Icons.check_circle;
        break;
      case EstadoPedido.listo:
        color = colors.warning;
        icon = Icons.hourglass_empty;
        break;
      default:
        color = colors.info;
        icon = Icons.pending;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(4)),
      child: Icon(icon, color: color, size: 14),
    );
  }

  Widget _buildBottomNav(dynamic colors, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Inicio', true, colors),
            _buildNavItem(Icons.shopping_bag, 'Pedidos', false, colors),
            _buildNavItem(Icons.inventory_2, 'Productos', false, colors),
            _buildNavItem(Icons.people, 'Clientes', false, colors),
            _buildNavItem(Icons.menu, 'Más', false, colors),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isSelected, dynamic colors) {
    return InkWell(
      onTap: () {
        if (label == 'Pedidos') _navigateTo(const PedidosScreen());
        if (label == 'Productos') _navigateTo(const ProductosScreen());
        if (label == 'Clientes') _navigateTo(const ClientesScreen());
        if (label == 'Más') _showMoreMenu(colors);
        if (label == 'Inicio') setState(() {});
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? colors.primary : colors.textTertiary, size: 24),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: isSelected ? colors.primary : colors.textTertiary, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  void _showMoreMenu(dynamic colors) {
    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: colors.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 24),
            Text('Más opciones', style: TextStyle(color: colors.text, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildMenuItem(Icons.attach_money, 'Abonos y pagos', colors, () { Navigator.pop(context); _navigateTo(const AbonosScreen()); }),
            _buildMenuItem(Icons.local_shipping, 'Domicilios', colors, () { Navigator.pop(context); _navigateTo(const DomiciliosScreen()); }),
            _buildMenuItem(Icons.build, 'Producción', colors, () { Navigator.pop(context); _navigateTo(const ProduccionScreen()); }),
            _buildMenuItem(Icons.replay, 'Devoluciones', colors, () { Navigator.pop(context); _navigateTo(const DevolucionesScreen()); }),
            _buildMenuItem(Icons.inventory, 'Inventario', colors, () { Navigator.pop(context); _navigateTo(const InventarioScreen()); }),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () { Navigator.pop(context); widget.onLogout(); },
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesión'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.error,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, dynamic colors, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: colors.text),
      title: Text(label, style: TextStyle(color: colors.text)),
      trailing: Icon(Icons.chevron_right, color: colors.textTertiary),
      onTap: onTap,
    );
  }

  void _navigateTo(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}