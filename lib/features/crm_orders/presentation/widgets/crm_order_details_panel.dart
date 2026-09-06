import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import '../providers/crm_orders_screen_provider.dart';

class CrmOrderDetailsPanel extends ConsumerWidget {
  const CrmOrderDetailsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final selectedOrderId = ref.watch(crmOrdersScreenProvider).selectedOrderId;
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontSize: 11);
    final titleStyle = style?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );
    if (selectedOrderId == null) {
      return Container(
        width: 400,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(
            left: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
        ),
        child: Center(
          child: Text(
            'Seleccione un pedido para ver sus detalles',
            style: style,
          ),
        ),
      );
    }

    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          left: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Column(
        children: [
          // Encabezado
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('DETALLES DEL PEDIDO', style: titleStyle),
                Row(
                  children: [
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.solidFloppyDisk, size: 18),
                      onPressed: () {},
                      tooltip: 'Guardar',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Contenido
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, 'Identificación'),
                  _buildDetailRow(
                    'Número de documento',
                    selectedOrderId,
                    style: style,
                  ),
                  _buildDetailRow(
                    'Fecha de Orden',
                    '28/08/2026 14:30',
                    style: style,
                  ),
                  const Gap(24),
                  _buildSectionTitle(context, 'Cliente'),
                  _buildDetailRow('Nombre completo', 'Ana Pérez', style: style),
                  _buildDetailRow('DNI', '12345678', style: style),
                  _buildDetailRow('Teléfono', '+51 987654321', style: style),
                  const Gap(24),

                  _buildSectionTitle(context, 'Logística'),
                  _buildDetailRow(
                    'Dirección de Entrega',
                    'Av. Larco 123, Miraflores, Lima',
                    style: style,
                  ),
                  const Gap(24),

                  _buildSectionTitle(context, 'Finanzas'),
                  _buildDetailRow(
                    'Método de pago',
                    'Tarjeta de Crédito',
                    style: style,
                  ),
                  _buildDetailRow('Subtotal', 'S/ 100.00', style: style),
                  _buildDetailRow('Costo de Envío', 'S/ 20.00', style: style),
                  const Divider(),
                  _buildDetailRow(
                    'Total General',
                    'S/ 120.00',
                    isTotal: true,
                    style: style,
                  ),
                  const Gap(24),

                  _buildSectionTitle(context, 'Control de Estado'),
                  DropdownButtonFormField<String>(
                    initialValue: 'Pendiente',
                    style: style,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: theme.colorScheme.primary.withAlpha(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'Pendiente',
                        child: Text('Pendiente', style: style),
                      ),
                      DropdownMenuItem(
                        value: 'Enviado',
                        child: Text('Enviado', style: style),
                      ),
                      DropdownMenuItem(
                        value: 'Entregado',
                        child: Text('Entregado', style: style),
                      ),
                      DropdownMenuItem(
                        value: 'Cancelado',
                        child: Text('Cancelado', style: style),
                      ),
                    ],
                    onChanged: (value) {},
                  ),
                  const Gap(32),

                  _buildSectionTitle(context, 'Historial del Cliente'),
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(10),
                      borderRadius: BorderRadiusGeometry.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          _buildHistoryRow(
                            'ORD-50100',
                            'Entregado',
                            '15/07/2026',
                            style,
                          ),
                          const Divider(),
                          _buildHistoryRow(
                            'ORD-49021',
                            'Entregado',
                            '10/05/2026',
                            style,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final titlePrimaryStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
      color: Theme.of(context).colorScheme.primary,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title, style: titlePrimaryStyle),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool isTotal = false,
    TextStyle? style,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: style?.copyWith(
                color: Colors.grey.shade600,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: style?.copyWith(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                fontSize: isTotal ? 14 : 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryRow(
    String order,
    String status,
    String date,
    TextStyle? style,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(order, style: style),
        Text(status, style: style?.copyWith(color: Colors.greenAccent)),
        Text(date, style: style),
      ],
    );
  }
}
