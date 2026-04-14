import 'package:flutter/material.dart';
import 'package:movilsurtitela/utils/app_colors.dart';
import 'package:movilsurtitela/presentation/widgets/common/custom_components.dart';
import 'package:url_launcher/url_launcher.dart';

class RastreoEntregaScreen extends StatefulWidget {
  final Map<String, dynamic> entrega;
  final bool isDarkMode;

  const RastreoEntregaScreen({
    super.key,
    required this.entrega,
    required this.isDarkMode,
  });

  @override
  State<RastreoEntregaScreen> createState() => _RastreoEntregaScreenState();
}

class _RastreoEntregaScreenState extends State<RastreoEntregaScreen> {
  int _currentStep = 0;

  final List<Map<String, dynamic>> _timelineSteps = [
    {
      'title': 'Asignada',
      'description': 'Entrega asignada al repartidor',
      'icon': Icons.assignment_outlined,
    },
    {
      'title': 'En Camino',
      'description': 'Repartidor se dirige a la dirección',
      'icon': Icons.directions_car_outlined,
    },
    {
      'title': 'Llegada',
      'description': 'Repartidor ha llegado al destino',
      'icon': Icons.location_on_outlined,
    },
    {
      'title': 'Firma y Foto',
      'description': 'Evidencia de entrega recolectada',
      'icon': Icons.camera_alt_outlined,
    },
    {
      'title': 'Completada',
      'description': 'Entrega finalizada correctamente',
      'icon': Icons.check_circle_outlined,
    },
  ];

  Future<void> _openGoogleMaps() async {
    final String direccion = widget.entrega['direccion'] ?? '';
    final Uri mapsUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(direccion)}');

    if (await canLaunchUrl(mapsUri)) {
      await launchUrl(mapsUri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _callClient() async {
    final String telefono = widget.entrega['telefono'] ?? '';
    final Uri callUri = Uri.parse('tel:$telefono');
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    }
  }

  void _nextStep() {
    if (_currentStep < _timelineSteps.length - 1) {
      setState(() {
        _currentStep++;
      });
    }
  }

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
          'Seguimiento Entrega',
          style: TextStyle(
            color: colors.text,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: colors.text),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDeliveryCard(colors),
            const SizedBox(height: 24),
            _buildTimelineIndicator(colors),
            const SizedBox(height: 32),
            _buildActionButtons(colors),
            const SizedBox(height: 24),
            _buildNextStepButton(colors),
            const SizedBox(height: 16),
            _buildReportIssueButton(colors),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryCard(AppColorsTheme colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.local_shipping_outlined,
                  color: colors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.entrega['cliente'] ?? 'Sin nombre',
                      style: TextStyle(
                        color: colors.text,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '#${widget.entrega['id'] ?? 'ENT-000'}',
                      style: TextStyle(
                        color: colors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.entrega['prioridad'] ?? 'Normal',
                  style: TextStyle(
                    color: colors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow(
            icons: Icons.location_on_outlined,
            title: 'Dirección',
            value: widget.entrega['direccion'] ?? 'No especificada',
            colors: colors,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icons: Icons.access_time_outlined,
            title: 'Hora estimada',
            value: widget.entrega['hora'] ?? 'Por confirmar',
            colors: colors,
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            icons: Icons.phone_outlined,
            title: 'Teléfono',
            value: widget.entrega['telefono'] ?? 'No registrado',
            colors: colors,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icons,
    required String title,
    required String value,
    required AppColorsTheme colors,
  }) {
    return Row(
      children: [
        Icon(icons, size: 18, color: colors.textSecondary),
        const SizedBox(width: 10),
        Text(
          '$title: ',
          style: TextStyle(
            color: colors.textSecondary,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: colors.text,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineIndicator(AppColorsTheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estado de entrega',
          style: TextStyle(
            color: colors.text,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: _timelineSteps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isCompleted = index < _currentStep;
            final isCurrent = index == _currentStep;

            return Expanded(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        children: [
                          if (index > 0)
                            Expanded(
                              child: Container(
                                height: 3,
                                color: index <= _currentStep ? colors.primary : colors.border,
                              ),
                            ),
                          if (index == 0) const Spacer(),
                          if (index < _timelineSteps.length - 1)
                            Expanded(
                              child: Container(
                                height: 3,
                                color: index < _currentStep ? colors.primary : colors.border,
                              ),
                            ),
                        ],
                      ),
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: isCompleted || isCurrent
                              ? colors.primary
                              : colors.surface,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isCompleted || isCurrent ? colors.primary : colors.border,
                            width: 2,
                          ),
                          boxShadow: isCurrent
                              ? [
                                  BoxShadow(
                                    color: colors.primary.withOpacity(0.3),
                                    blurRadius: 12,
                                    spreadRadius: 2,
                                  )
                                ]
                              : null,
                        ),
                        child: Icon(
                          step['icon'],
                          color: isCompleted || isCurrent ? Colors.white : colors.textSecondary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    step['title'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isCompleted || isCurrent ? colors.primary : colors.textSecondary,
                      fontSize: 11,
                      fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons(AppColorsTheme colors) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: 'Navegar',
            icon: Icons.navigation_outlined,
            onPressed: _openGoogleMaps,
            isOutline: false,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CustomButton(
            text: 'Llamar',
            icon: Icons.phone_outlined,
            onPressed: _callClient,
            isOutline: true,
          ),
        ),
      ],
    );
  }

  Widget _buildNextStepButton(AppColorsTheme colors) {
    final isLastStep = _currentStep >= _timelineSteps.length - 1;

    return CustomButton(
      text: isLastStep ? 'Finalizar Entrega' : 'Marcar ${_timelineSteps[_currentStep + 1]['title']}',
      icon: isLastStep ? Icons.check_circle_outline : Icons.arrow_forward_outlined,
      onPressed: _currentStep < _timelineSteps.length - 1
          ? _nextStep
          : () {
              // Navigate to complete delivery screen
            },
    );
  }

  Widget _buildReportIssueButton(AppColorsTheme colors) {
    return SizedBox(
      width: double.infinity,
      child: TextButton.icon(
        onPressed: () {
          // Open report issue modal
        },
        icon: Icon(Icons.report_problem_outlined, color: colors.error, size: 18),
        label: Text(
          'Reportar problema con la entrega',
          style: TextStyle(
            color: colors.error,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
