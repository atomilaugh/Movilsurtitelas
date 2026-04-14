import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movilsurtitela/utils/app_colors.dart';
import 'package:movilsurtitela/presentation/widgets/common/custom_components.dart';

class RepartidorCompletarEntregaScreen extends StatefulWidget {
  final String entregaId;
  final String cliente;
  final String direccion;

  const RepartidorCompletarEntregaScreen({
    super.key,
    required this.entregaId,
    required this.cliente,
    required this.direccion,
  });

  @override
  State<RepartidorCompletarEntregaScreen> createState() => _RepartidorCompletarEntregaScreenState();
}

class _RepartidorCompletarEntregaScreenState extends State<RepartidorCompletarEntregaScreen> {
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  final TextEditingController _nombreRecibeController = TextEditingController();
  final TextEditingController _cedulaRecibeController = TextEditingController();
  final TextEditingController _observacionesController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _fotoEntrega;
  bool _todosProductosEntregados = true;

  @override
  void dispose() {
    _signatureController.dispose();
    _nombreRecibeController.dispose();
    _cedulaRecibeController.dispose();
    _observacionesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = isDark ? AppColors.dark : AppColors.light;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: colors.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Completar Entrega',
              style: TextStyle(color: colors.text, fontWeight: FontWeight.bold),
            ),
            Text(
              '#${widget.entregaId}',
              style: TextStyle(color: colors.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verificación de Productos',
              style: TextStyle(
                color: colors.text,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
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
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _todosProductosEntregados,
                        onChanged: (value) => setState(() => _todosProductosEntregados = value ?? true),
                      ),
                      const Text('Todos los productos fueron entregados'),
                    ],
                  ),
                  if (!_todosProductosEntregados)
                    CustomTextField(
                      label: 'Motivo de entrega parcial',
                      controller: _observacionesController,
                      maxLines: 3,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Evidencia de Entrega',
              style: TextStyle(
                color: colors.text,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Foto de la entrega',
              style: TextStyle(color: colors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final XFile? photo = await _picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 80,
                );
                if (photo != null) {
                  setState(() => _fotoEntrega = photo);
                }
              },
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  color: colors.surfaceElevated,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colors.border),
                ),
                child: _fotoEntrega != null
                    ? Center(child: Icon(Icons.check_circle, color: colors.success, size: 48))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, color: colors.textTertiary, size: 32),
                          const SizedBox(height: 8),
                          Text(
                            'Tomar Foto',
                            style: TextStyle(color: colors.textTertiary),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Firma Digital',
              style: TextStyle(color: colors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.border),
              ),
              child: Signature(
                controller: _signatureController,
                height: 200,
                backgroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => _signatureController.clear(),
                  icon: Icon(Icons.delete, color: colors.error),
                  label: Text('Limpiar Firma', style: TextStyle(color: colors.error)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Datos de quien recibe',
              style: TextStyle(color: colors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              label: 'Nombre completo',
              controller: _nombreRecibeController,
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Cédula (opcional)',
              controller: _cedulaRecibeController,
              prefixIcon: Icons.badge,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Observaciones (opcional)',
              controller: _observacionesController,
              prefixIcon: Icons.note,
              maxLines: 2,
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Confirmar Entrega',
              icon: Icons.check_circle,
              onPressed: () {},
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}