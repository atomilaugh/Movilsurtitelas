import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movilsurtitela/domain/entities/cliente.dart';
import 'package:movilsurtitela/providers/data_provider.dart';
import 'package:movilsurtitela/utils/app_colors.dart';
import 'package:movilsurtitela/utils/formatters.dart';

class ClientesScreen extends StatefulWidget {
  const ClientesScreen({super.key});

  @override
  State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
  String _searchQuery = '';
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
          'Clientes',
          style: TextStyle(color: colors.text, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: colors.primary),
            onPressed: () => _showAddClienteDialog(context, colors),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: colors.surface,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: colors.textTertiary, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          onChanged: (value) => setState(() => _searchQuery = value),
                          decoration: InputDecoration(
                            hintText: 'Buscar clientes...',
                            hintStyle: TextStyle(color: colors.textTertiary),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(color: colors.text),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildFilterChip('Todos', 'todos', colors),
                    const SizedBox(width: 8),
                    _buildFilterChip('Mayoristas', 'mayorista', colors),
                    const SizedBox(width: 8),
                    _buildFilterChip('Minoristas', 'minorista', colors),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<DataProvider>(
              builder: (context, dataProvider, _) {
                var clientes = dataProvider.clientes;

                if (_searchQuery.isNotEmpty) {
                  clientes = clientes.where((c) =>
                    c.nombre.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    c.ciudad.toLowerCase().contains(_searchQuery.toLowerCase())
                  ).toList();
                }

                if (_filter != 'todos') {
                  clientes = clientes.where((c) =>
                    c.tipoCliente.name == _filter
                  ).toList();
                }

                if (clientes.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline, size: 64, color: colors.textTertiary),
                        const SizedBox(height: 16),
                        Text(
                          'No hay clientes',
                          style: TextStyle(color: colors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: clientes.length,
                  itemBuilder: (context, index) {
                    return _buildClienteCard(clientes[index], colors, isDark);
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

  Widget _buildClienteCard(Cliente cliente, dynamic colors, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cliente.nombre,
                      style: TextStyle(
                        color: colors.text,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: cliente.tipoCliente == TipoCliente.mayorista
                                ? colors.accentLight
                                : colors.infoBg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            cliente.tipoCliente == TipoCliente.mayorista ? 'Mayorista' : 'Minorista',
                            style: TextStyle(
                              color: cliente.tipoCliente == TipoCliente.mayorista
                                  ? colors.accent
                                  : colors.info,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.location_on, size: 12, color: colors.textTertiary),
                        Text(
                          ' ${cliente.ciudad}',
                          style: TextStyle(color: colors.textTertiary, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton(
                icon: Icon(Icons.more_vert, color: colors.textTertiary),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        const SizedBox(width: 8),
                        Text('Editar'),
                      ],
                    ),
                    onTap: () {},
                  ),
                  PopupMenuItem(
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: colors.error),
                        const SizedBox(width: 8),
                        Text('Eliminar', style: TextStyle(color: colors.error)),
                      ],
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.phone, size: 14, color: colors.textTertiary),
              const SizedBox(width: 4),
              Text(
                Formatters.formatPhoneNumber(cliente.telefono),
                style: TextStyle(color: colors.textSecondary, fontSize: 12),
              ),
              if (cliente.email != null) ...[
                const SizedBox(width: 16),
                Icon(Icons.email, size: 14, color: colors.textTertiary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    cliente.email!,
                    style: TextStyle(color: colors.textSecondary, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total compras',
                    style: TextStyle(color: colors.textTertiary, fontSize: 10),
                  ),
                  Text(
                    Formatters.formatCurrency(cliente.totalCompras),
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Pedidos',
                    style: TextStyle(color: colors.textTertiary, fontSize: 10),
                  ),
                  Text(
                    '${cliente.pedidosRealizados}',
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddClienteDialog(BuildContext context, dynamic colors) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nombreController = TextEditingController();
    final telefonoController = TextEditingController();
    final emailController = TextEditingController();
    final direccionController = TextEditingController();
    final ciudadController = TextEditingController();
    TipoCliente _tipoCliente = TipoCliente.minorista;

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
                  'Nuevo Cliente',
                  style: TextStyle(
                    color: colors.text,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: nombreController,
                  style: TextStyle(color: colors.text),
                  decoration: _inputDecoration('Nombre', colors),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: telefonoController,
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: colors.text),
                  decoration: _inputDecoration('Teléfono', colors),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: colors.text),
                  decoration: _inputDecoration('Email (opcional)', colors),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: direccionController,
                  style: TextStyle(color: colors.text),
                  decoration: _inputDecoration('Dirección', colors),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: ciudadController,
                  style: TextStyle(color: colors.text),
                  decoration: _inputDecoration('Ciudad', colors),
                ),
                const SizedBox(height: 16),
                Text('Tipo de cliente', style: TextStyle(color: colors.text, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildTipoOption('Mayorista', _tipoCliente == TipoCliente.mayorista, colors, () => setModalState(() => _tipoCliente = TipoCliente.mayorista)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTipoOption('Minorista', _tipoCliente == TipoCliente.minorista, colors, () => setModalState(() => _tipoCliente = TipoCliente.minorista)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (nombreController.text.isEmpty || telefonoController.text.isEmpty || ciudadController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Por favor completa los campos obligatorios')),
                        );
                        return;
                      }
                      final cliente = Cliente(
                        id: 'c${DateTime.now().millisecondsSinceEpoch}',
                        nombre: nombreController.text,
                        telefono: telefonoController.text,
                        email: emailController.text.isEmpty ? null : emailController.text,
                        direccion: direccionController.text,
                        ciudad: ciudadController.text,
                        tipoCliente: _tipoCliente,
                        totalCompras: 0,
                        pedidosRealizados: 0,
                        fechaRegistro: DateTime.now(),
                      );
                      context.read<DataProvider>().addCliente(cliente);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Cliente "${cliente.nombre}" agregado correctamente')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Guardar',
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

  Widget _buildTipoOption(String label, bool isSelected, dynamic colors, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? colors.primary : colors.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? colors.primary : colors.border),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? (colors == AppColors.dark ? Colors.black : Colors.white) : colors.text,
              fontWeight: FontWeight.w500,
            ),
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