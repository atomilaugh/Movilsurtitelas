import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:movilsurtitela/utils/app_colors.dart';
import 'package:movilsurtitela/presentation/widgets/common/custom_components.dart';

class OrderData {
  final String direccion;
  final String ciudad;
  final String telefono;
  final String metodoPago;
  final String observaciones;

  OrderData({
    required this.direccion,
    required this.ciudad,
    required this.telefono,
    required this.metodoPago,
    required this.observaciones,
  });
}

class CheckoutScreen extends StatefulWidget {
  final List<dynamic> items;
  final double total;
  final Function(OrderData) onConfirmOrder;

  const CheckoutScreen({
    super.key,
    required this.items,
    required this.total,
    required this.onConfirmOrder,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _step = 1;

  final _direccionController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _observacionesController = TextEditingController();
  String _metodoPago = 'efectivo';

  final List<Map<String, dynamic>> _metodosPago = [
    {
      'id': 'efectivo',
      'nombre': 'Efectivo',
      'icon': Icons.account_balance_wallet,
      'descripcion': 'Pago contra entrega',
    },
    {
      'id': 'transferencia',
      'nombre': 'Transferencia',
      'icon': Icons.credit_card,
      'descripcion': 'Bancolombia o Nequi',
    },
    {
      'id': 'tarjeta',
      'nombre': 'Tarjeta',
      'icon': Icons.credit_card,
      'descripcion': 'Débito o crédito',
    },
  ];

  void _handleNext() {
    if (_step == 1) {
      if (_direccionController.text.isEmpty ||
          _ciudadController.text.isEmpty ||
          _telefonoController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor completa todos los campos de entrega'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      setState(() => _step = 2);
    } else if (_step == 2) {
      setState(() => _step = 3);
    }
  }

  void _handleBack() {
    if (_step > 1) {
      setState(() => _step--);
    }
  }

  void _handleConfirm() {
    final orderData = OrderData(
      direccion: _direccionController.text,
      ciudad: _ciudadController.text,
      telefono: _telefonoController.text,
      metodoPago: _metodoPago,
      observaciones: _observacionesController.text,
    );

    widget.onConfirmOrder(orderData);
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
            _buildHeader(colors),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _step == 1
                    ? _buildPaso1(colors)
                    : _step == 2
                        ? _buildPaso2(colors)
                        : _buildPaso3(colors),
              ),
            ),
            _buildFooter(colors),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppColorsTheme colors) {
    return Container(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Finalizar Pedido',
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Paso $_step de 3',
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: colors.surfaceElevated,
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: _step / 3,
              child: Container(
                decoration: BoxDecoration(
                  color: colors.accent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaso1(AppColorsTheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dirección de Entrega',
          style: TextStyle(
            color: colors.text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        _buildTextField(
          colors,
          'Dirección completa *',
          'Ej: Calle 123 #45-67',
          _direccionController,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          colors,
          'Ciudad *',
          'Ej: Bogotá',
          _ciudadController,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          colors,
          'Teléfono de contacto *',
          'Ej: 3001234567',
          _telefonoController,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          colors,
          'Observaciones (opcional)',
          'Instrucciones adicionales para la entrega',
          _observacionesController,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildPaso2(AppColorsTheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Método de Pago',
          style: TextStyle(
            color: colors.text,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        ..._metodosPago.map((metodo) {
          final isSelected = _metodoPago == metodo['id'];

          return GestureDetector(
            onTap: () => setState(() => _metodoPago = metodo['id']),
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? colors.accentLight : colors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? colors.accent : colors.border,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected ? colors.accent : colors.surfaceElevated,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      metodo['icon'],
                      color: isSelected ? Colors.white : colors.text,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          metodo['nombre'],
                          style: TextStyle(
                            color: colors.text,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          metodo['descripcion'],
                          style: TextStyle(
                            color: colors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: colors.accent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildPaso3(AppColorsTheme colors) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: colors.successBg,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check,
            color: colors.success,
            size: 40,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Confirmar Pedido',
          style: TextStyle(
            color: colors.text,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Revisa los detalles antes de confirmar',
          style: TextStyle(
            color: colors.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 32),
        _buildResumenCard(
          colors,
          'Entrega',
          Icons.location_on,
          [
            _direccionController.text,
            _ciudadController.text,
            'Tel: ${_telefonoController.text}',
          ],
        ),
        const SizedBox(height: 16),
        _buildResumenCard(
          colors,
          'Pago',
          Icons.account_balance_wallet,
          [
            _metodosPago.firstWhere((m) => m['id'] == _metodoPago)['nombre'],
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Productos (${widget.items.length})',
                style: TextStyle(
                  color: colors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...widget.items.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${item.cantidad}x ${item.productoNombre}',
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 14,
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
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResumenCard(
    AppColorsTheme colors,
    String title,
    IconData icon,
    List<String> lines,
  ) {
    return Container(
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
            children: [
              Icon(icon, color: colors.text, size: 16),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: colors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...lines.map((line) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                line,
                style: TextStyle(
                  color: colors.text,
                  fontSize: 14,
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTextField(
    AppColorsTheme colors,
    String label,
    String hint,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: colors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: colors.textTertiary),
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
          ),
          style: TextStyle(color: colors.text),
        ),
      ],
    );
  }

  Widget _buildFooter(AppColorsTheme colors) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  color: colors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                NumberFormat.currency(
                  symbol: '\$',
                  decimalDigits: 0,
                  locale: 'es_CO',
                ).format(widget.total),
                style: TextStyle(
                  color: colors.accent,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              if (_step > 1)
                Expanded(
                  child: OutlinedButton(
                    onPressed: _handleBack,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.text,
                      side: BorderSide(color: colors.border),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Atrás',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              if (_step > 1) const SizedBox(width: 12),
              Expanded(
                flex: _step > 1 ? 1 : 1,
                child: ElevatedButton(
                  onPressed: _step == 3 ? _handleConfirm : _handleNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.accent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _step == 3 ? 'Confirmar Pedido' : 'Continuar',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _direccionController.dispose();
    _ciudadController.dispose();
    _telefonoController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }
}
