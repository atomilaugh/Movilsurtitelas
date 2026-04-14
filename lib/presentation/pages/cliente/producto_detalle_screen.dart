import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:movilsurtitela/domain/entities/producto.dart';
import 'package:movilsurtitela/utils/app_colors.dart';
import 'package:movilsurtitela/presentation/widgets/common/custom_components.dart';

class ProductoDetalleScreen extends StatefulWidget {
  final Producto producto;
  final Function(ItemCarrito)? onAddToCart;

  const ProductoDetalleScreen({
    super.key,
    required this.producto,
    this.onAddToCart,
  });

  @override
  State<ProductoDetalleScreen> createState() => _ProductoDetalleScreenState();
}

class _ProductoDetalleScreenState extends State<ProductoDetalleScreen> {
  String _tallaSeleccionada = '';
  String _colorSeleccionado = '';
  int _cantidad = 1;
  int _imagenActiva = 0;
  bool _liked = false;

  @override
  void initState() {
    super.initState();
    if (widget.producto.colores.isNotEmpty) {
      _colorSeleccionado = widget.producto.colores.first;
    }
  }

  Color _getColorHex(String colorName) {
    final Map<String, Color> colorMap = {
      'blanco': const Color(0xFFFFFFFF),
      'negro': const Color(0xFF000000),
      'gris': const Color(0xFF999999),
      'gris claro': const Color(0xFFCCCCCC),
      'gris oscuro': const Color(0xFF666666),
      'azul': const Color(0xFF1565C0),
      'azul marino': const Color(0xFF0D47A1),
      'azul claro': const Color(0xFF42A5F5),
      'rojo': const Color(0xFFD32F2F),
      'verde': const Color(0xFF2E7D32),
      'verde oscuro': const Color(0xFF1B5E20),
      'amarillo': const Color(0xFFFBC02D),
      'naranja': const Color(0xFFF57C00),
      'rosa': const Color(0xFFE91E63),
      'morado': const Color(0xFF7B1FA2),
      'beige': const Color(0xFFC4B5A0),
      'café': const Color(0xFF5D4037),
    };
    return colorMap[colorName.toLowerCase()] ?? const Color(0xFFCCCCCC);
  }

  Future<void> _handleWhatsAppPedido() async {
    if (_tallaSeleccionada.isEmpty || _colorSeleccionado.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selecciona talla y color antes de contactarnos'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final total = widget.producto.precioBase * _cantidad;
    final mensaje = Uri.encodeComponent(
      'Hola! Estoy interesado en hacer un pedido:\n\n'
      '🛍️ *${widget.producto.nombre}*\n'
      '📏 Talla: $_tallaSeleccionada\n'
      '🎨 Color: $_colorSeleccionado\n'
      '📦 Cantidad: $_cantidad\n'
      '💰 Total: ${NumberFormat.currency(symbol: '\$', decimalDigits: 0, locale: 'es_CO').format(total)}\n\n'
      '¿Está disponible?'
    );

    const numeroWhatsApp = '573001234567';
    final url = 'https://wa.me/$numeroWhatsApp?text=$mensaje';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  void _handleAgregarAlCarrito() {
    if (_tallaSeleccionada.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona una talla'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_colorSeleccionado.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona un color'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (widget.onAddToCart != null) {
      final item = ItemCarrito(
        productoId: widget.producto.id,
        productoNombre: widget.producto.nombre,
        productoImagen: widget.producto.imagen,
        cantidad: _cantidad,
        talla: _tallaSeleccionada,
        color: _colorSeleccionado,
        precioUnitario: widget.producto.precioBase,
        subtotal: widget.producto.precioBase * _cantidad,
      );

      widget.onAddToCart!(item);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Agregado al carrito!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    final imagenesProducto = [
      widget.producto.imagen,
      widget.producto.imagen,
      widget.producto.imagen,
    ];

    return Scaffold(
      backgroundColor: colors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                _buildGaleria(colors, imagenesProducto),
                _buildInfo(colors),
                _buildSelectorColor(colors, isDark),
                _buildSelectorTalla(colors, isDark),
                _buildControlCantidad(colors, isDark),
                _buildResumen(colors),
                const SizedBox(height: 160),
              ],
            ),
          ),
          _buildHeader(colors),
          _buildBotonesFlotantes(colors),
        ],
      ),
    );
  }

  Widget _buildHeader(AppColorsTheme colors) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
        decoration: BoxDecoration(
          color: colors.background.withOpacity(0.95),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colors.surface,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Icon(Icons.arrow_back, color: colors.text),
              ),
            ),
            Row(
              children: [
                InkWell(
                  onTap: () => setState(() => _liked = !_liked),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colors.surface,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Icon(
                      _liked ? Icons.favorite : Icons.favorite_border,
                      color: _liked ? Colors.red : colors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Icon(Icons.share, color: colors.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGaleria(AppColorsTheme colors, List<String> imagenes) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 400,
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.network(
                    imagenes[_imagenActiva],
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: colors.surfaceElevated,
                      child: Icon(Icons.image_not_supported, color: colors.textSecondary, size: 64),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(imagenes.length, (index) {
                    return GestureDetector(
                      onTap: () => setState(() => _imagenActiva = index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _imagenActiva == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _imagenActiva == index
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              if (widget.producto.stock < 10)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '¡Pocas unidades!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(imagenes.length, (index) {
              return GestureDetector(
                onTap: () => setState(() => _imagenActiva = index),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _imagenActiva == index
                          ? colors.primary
                          : colors.border,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      imagenes[index],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: colors.surfaceElevated,
                        child: Icon(Icons.image_not_supported, color: colors.textSecondary),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(AppColorsTheme colors) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: colors.accentLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.producto.categoria.name,
              style: TextStyle(
                color: colors.accent,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.producto.nombre,
            style: TextStyle(
              color: colors.text,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                NumberFormat.currency(
                  symbol: '\$',
                  decimalDigits: 0,
                  locale: 'es_CO',
                ).format(widget.producto.precioBase),
                style: TextStyle(
                  color: colors.text,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'por unidad',
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.producto.descripcion,
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: colors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Stock: ${widget.producto.stock} unidades',
                style: TextStyle(
                  color: colors.textTertiary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '•',
                style: TextStyle(color: colors.textTertiary),
              ),
              const SizedBox(width: 16),
              Text(
                '${widget.producto.tallas.length} tallas disponibles',
                style: TextStyle(
                  color: colors.textTertiary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectorColor(AppColorsTheme colors, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Color',
                style: TextStyle(
                  color: colors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_colorSeleccionado.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _colorSeleccionado,
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: widget.producto.colores.map((color) {
              final isSelected = _colorSeleccionado == color;
              final colorHex = _getColorHex(color);

              return GestureDetector(
                onTap: () => setState(() {
                  _colorSeleccionado = color;
                  _imagenActiva = 0;
                }),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: colorHex,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? colors.primary : Colors.transparent,
                              width: 4,
                            ),
                            boxShadow: color.toLowerCase() == 'blanco'
                                ? [BoxShadow(color: colors.border, blurRadius: 0, spreadRadius: 1)]
                                : [],
                          ),
                        ),
                        if (isSelected)
                          Positioned(
                            top: -4,
                            right: -4,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: colors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check,
                                color: isDark ? Colors.black : Colors.white,
                                size: 12,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      color,
                      style: TextStyle(
                        color: isSelected ? colors.text : colors.textTertiary,
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectorTalla(AppColorsTheme colors, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Talla',
                style: TextStyle(
                  color: colors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_tallaSeleccionada.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _tallaSeleccionada,
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.producto.tallas.map((talla) {
              final isSelected = _tallaSeleccionada == talla;

              return GestureDetector(
                onTap: () => setState(() => _tallaSeleccionada = talla),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? colors.primary : colors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? colors.primary : colors.border,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    talla,
                    style: TextStyle(
                      color: isSelected
                          ? (isDark ? Colors.black : Colors.white)
                          : colors.text,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildControlCantidad(AppColorsTheme colors, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cantidad',
            style: TextStyle(
              color: colors.text,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() {
                  if (_cantidad > 1) _cantidad--;
                }),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.border, width: 2),
                  ),
                  child: Icon(
                    Icons.remove,
                    color: _cantidad > 1 ? colors.text : colors.textTertiary,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$_cantidad',
                        style: TextStyle(
                          color: colors.text,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _cantidad == 1 ? 'unidad' : 'unidades',
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _cantidad++),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.add,
                    color: isDark ? Colors.black : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResumen(AppColorsTheme colors) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📋 Resumen de tu pedido',
              style: TextStyle(
                color: colors.text,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildResumenRow(colors, 'Producto:', widget.producto.nombre),
            if (_colorSeleccionado.isNotEmpty)
              _buildResumenRowColor(colors, 'Color:', _colorSeleccionado),
            if (_tallaSeleccionada.isNotEmpty)
              _buildResumenRow(colors, 'Talla:', _tallaSeleccionada),
            _buildResumenRow(colors, 'Cantidad:', '$_cantidad ${_cantidad == 1 ? 'unidad' : 'unidades'}'),
            Divider(color: colors.border, height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total:',
                  style: TextStyle(
                    color: colors.text,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  NumberFormat.currency(
                    symbol: '\$',
                    decimalDigits: 0,
                    locale: 'es_CO',
                  ).format(widget.producto.precioBase * _cantidad),
                  style: TextStyle(
                    color: colors.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResumenRow(AppColorsTheme colors, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: colors.text,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResumenRowColor(AppColorsTheme colors, String label, String colorName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 14,
            ),
          ),
          Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: _getColorHex(colorName),
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.border),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                colorName,
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
    );
  }

  Widget _buildBotonesFlotantes(AppColorsTheme colors) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(top: BorderSide(color: colors.border)),
        ),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _handleWhatsAppPedido,
              style: ElevatedButton.styleFrom(
                backgroundColor: _tallaSeleccionada.isEmpty || _colorSeleccionado.isEmpty
                    ? colors.surfaceElevated
                    : const Color(0xFF25D366),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: _tallaSeleccionada.isEmpty || _colorSeleccionado.isEmpty ? 0 : 4,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.message, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Hacer pedido por WhatsApp',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            if (widget.onAddToCart != null) ...[
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _handleAgregarAlCarrito,
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.primary,
                  side: BorderSide(color: colors.primary, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  minimumSize: const Size(double.infinity, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_cart, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Agregar al carrito',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ItemCarrito {
  final String productoId;
  final String productoNombre;
  final String productoImagen;
  final int cantidad;
  final String talla;
  final String color;
  final double precioUnitario;
  final double subtotal;

  ItemCarrito({
    required this.productoId,
    required this.productoNombre,
    required this.productoImagen,
    required this.cantidad,
    required this.talla,
    required this.color,
    required this.precioUnitario,
    required this.subtotal,
  });
}
