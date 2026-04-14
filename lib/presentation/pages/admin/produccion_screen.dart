import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movilsurtitela/domain/entities/produccion.dart';
import 'package:movilsurtitela/providers/data_provider.dart';
import 'package:movilsurtitela/utils/app_colors.dart';
import 'package:movilsurtitela/utils/formatters.dart';

class ProduccionScreen extends StatefulWidget {
  const ProduccionScreen({super.key});

  @override
  State<ProduccionScreen> createState() => _ProduccionScreenState();
}

class _ProduccionScreenState extends State<ProduccionScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
          'Producción',
          style: TextStyle(color: colors.text, fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: colors.primary,
          unselectedLabelColor: colors.textTertiary,
          indicatorColor: colors.primary,
          tabs: const [
            Tab(text: 'Corte'),
            Tab(text: 'Confección'),
            Tab(text: 'Estampado'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildEtapaTab(EtapaProduccion.corte, colors),
          _buildEtapaTab(EtapaProduccion.confeccion, colors),
          _buildEtapaTab(EtapaProduccion.estampado, colors),
        ],
      ),
    );
  }

  Widget _buildEtapaTab(EtapaProduccion etapa, dynamic colors) {
    return Consumer<DataProvider>(
      builder: (context, dataProvider, _) {
        final procesos = dataProvider.procesosProduccion.where((p) => p.etapa == etapa).toList();
        
        if (procesos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pending_actions, size: 64, color: colors.textTertiary),
                const SizedBox(height: 16),
                Text(
                  'Sin procesos en ${etapa.name}',
                  style: TextStyle(color: colors.textSecondary),
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: procesos.length,
          itemBuilder: (context, index) {
            return _buildProcesoCard(procesos[index], colors);
          },
        );
      },
    );
  }

  Widget _buildProcesoCard(ProcesoProduccion proceso, dynamic colors) {
    Color statusColor;
    Color statusBg;
    String statusText;
    
    switch (proceso.estado) {
      case EstadoProceso.completado:
        statusColor = colors.success;
        statusBg = colors.successBg;
        statusText = 'Completado';
        break;
      case EstadoProceso.enProceso:
        statusColor = colors.warning;
        statusBg = colors.warningBg;
        statusText = 'En proceso';
        break;
      case EstadoProceso.pendiente:
        statusColor = colors.textTertiary;
        statusBg = colors.surfaceElevated;
        statusText = 'Pendiente';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pedido #${proceso.pedidoId}',
                    style: TextStyle(
                      color: colors.text,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    proceso.etapa.name.toUpperCase(),
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.person, size: 14, color: colors.textTertiary),
              const SizedBox(width: 4),
              Text(
                'Responsable: ${proceso.responsable}',
                style: TextStyle(color: colors.textSecondary, fontSize: 12),
              ),
            ],
          ),
          if (proceso.tallerExterno != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.business, size: 14, color: colors.textTertiary),
                const SizedBox(width: 4),
                Text(
                  'Taller: ${proceso.tallerExterno}',
                  style: TextStyle(color: colors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ],
          const SizedBox(height: 8),
          if (proceso.fechaInicio != null) ...[
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: colors.textTertiary),
                const SizedBox(width: 4),
                Text(
                  'Inicio: ${Formatters.formatDate(proceso.fechaInicio!)}',
                  style: TextStyle(color: colors.textSecondary, fontSize: 12),
                ),
                if (proceso.fechaFin != null) ...[
                  const SizedBox(width: 16),
                  Text(
                    'Fin: ${Formatters.formatDate(proceso.fechaFin!)}',
                    style: TextStyle(color: colors.textSecondary, fontSize: 12),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}