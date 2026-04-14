import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movilsurtitela/domain/entities/abono.dart';
import 'package:movilsurtitela/providers/data_provider.dart';
import 'package:movilsurtitela/utils/app_colors.dart';
import 'package:movilsurtitela/utils/formatters.dart';

class AbonosScreen extends StatefulWidget {
  const AbonosScreen({super.key});

  @override
  State<AbonosScreen> createState() => _AbonosScreenState();
}

class _AbonosScreenState extends State<AbonosScreen> {
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
          'Abonos y Pagos',
          style: TextStyle(color: colors.text, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: colors.primary),
            onPressed: () => _showAddAbonoDialog(context, colors, isDark),
          ),
        ],
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
                  _buildFilterChip('Efectivo', 'efectivo', colors),
                  const SizedBox(width: 8),
                  _buildFilterChip('Transferencia', 'transferencia', colors),
                  const SizedBox(width: 8),
                  _buildFilterChip('Tarjeta', 'tarjeta', colors),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Consumer<DataProvider>(
              builder: (context, dataProvider, _) {
                final totalAbonos = dataProvider.abonos.fold(0.0, (sum, a) => sum + a.monto);
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total abonado',
                            style: TextStyle(color: colors.textSecondary, fontSize: 12),
                          ),
                          Text(
                            Formatters.formatCurrency(totalAbonos),
                            style: TextStyle(
                              color: colors.text,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.payments, color: colors.primary, size: 40),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Consumer<DataProvider>(
              builder: (context, dataProvider, _) {
                var abonos = dataProvider.abonos;

                if (_filter != 'todos') {
                  abonos = abonos.where((a) => a.metodoPago.name == _filter).toList();
                }

                if (abonos.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.money_off, size: 64, color: colors.textTertiary),
                        const SizedBox(height: 16),
                        Text(
                          'No hay abonos registrados',
                          style: TextStyle(color: colors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: abonos.length,
                  itemBuilder: (context, index) {
                    return _buildAbonoCard(abonos[index], colors);
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

  Widget _buildAbonoCard(Abono abono, dynamic colors) {
    Color methodColor;
    IconData methodIcon;

    switch (abono.metodoPago) {
      case MetodoPago.efectivo:
        methodColor = colors.success;
        methodIcon = Icons.money;
        break;
      case MetodoPago.transferencia:
        methodColor = colors.info;
        methodIcon = Icons.account_balance;
        break;
      case MetodoPago.tarjeta:
        methodColor = colors.warning;
        methodIcon = Icons.credit_card;
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
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: methodColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(methodIcon, color: methodColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  abono.clienteNombre,
                  style: TextStyle(
                    color: colors.text,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pedido #${abono.pedidoId}',
                  style: TextStyle(color: colors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  'Registrado por: ${abono.registradoPor}',
                  style: TextStyle(color: colors.textTertiary, fontSize: 10),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                Formatters.formatCurrency(abono.monto),
                style: TextStyle(
                  color: colors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                Formatters.formatDate(abono.fecha),
                style: TextStyle(color: colors.textTertiary, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddAbonoDialog(BuildContext context, dynamic colors, bool isDark) {
    final montoController = TextEditingController();
    String selectedMethod = 'efectivo';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nuevo Abono',
                  style: TextStyle(
                    color: colors.text,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: montoController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: colors.text),
                  decoration: _inputDecoration('Monto del abono', colors),
                ),
                const SizedBox(height: 16),
                Text(
                  'Método de pago',
                  style: TextStyle(color: colors.textSecondary, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildMethodChip('Efectivo', 'efectivo', selectedMethod, colors, (v) => setModalState(() => selectedMethod = v)),
                    const SizedBox(width: 8),
                    _buildMethodChip('Transferencia', 'transferencia', selectedMethod, colors, (v) => setModalState(() => selectedMethod = v)),
                    const SizedBox(width: 8),
                    _buildMethodChip('Tarjeta', 'tarjeta', selectedMethod, colors, (v) => setModalState(() => selectedMethod = v)),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final abono = Abono(
                        id: 'ab${DateTime.now().millisecondsSinceEpoch}',
                        pedidoId: 'ped001',
                        clienteNombre: 'Cliente Demo',
                        monto: double.tryParse(montoController.text) ?? 0,
                        metodoPago: MetodoPago.values.firstWhere((e) => e.name == selectedMethod),
                        fecha: DateTime.now(),
                        registradoPor: 'Admin',
                      );
                      context.read<DataProvider>().addAbono(abono);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Registrar Abono',
                      style: TextStyle(
                        color: isDark ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMethodChip(String label, String value, String selected, dynamic colors, Function(String) onTap) {
    final isSelected = selected == value;
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.surfaceElevated,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? colors.primary : colors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? (colors == AppColors.dark ? Colors.black : Colors.white) : colors.text,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, dynamic colors) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: colors.textSecondary),
      filled: true,
      fillColor: colors.surfaceElevated,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.primary, width: 2),
      ),
    );
  }
}