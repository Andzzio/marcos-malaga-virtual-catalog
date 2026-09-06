import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marcos_malaga_app/features/crm_orders/presentation/providers/crm_orders_screen_provider.dart';

class CrmOrdersTable extends ConsumerWidget {
  const CrmOrdersTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedOrderId = ref.watch(crmOrdersScreenProvider).selectedOrderId;
    final notifier = ref.read(crmOrdersScreenProvider.notifier);
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontSize: 11);
    final titleStyle = style?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );
    final borderColor = Colors.grey.shade400;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadiusGeometry.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Pedidos Recientes', style: titleStyle),
          ),
          const Divider(height: 1),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: constraints.maxWidth,
                      ),
                      child: DataTable(
                        showCheckboxColumn: false,
                        columns: [
                          DataColumn(label: Text('Número', style: style)),
                          DataColumn(label: Text('Fecha', style: style)),
                          DataColumn(label: Text('Cliente', style: style)),
                          DataColumn(label: Text('Estado', style: style)),
                          DataColumn(label: Text('Total', style: style)),
                        ],
                        rows: [
                          _buildRow(
                            context,
                            number: 'ORD-50251',
                            date: '28/08/2026',
                            client: 'Ana Pérez',
                            status: 'Pendiente',
                            statusColor: Colors.orangeAccent,
                            total: 'S/ 120.00',
                            selected: selectedOrderId == 'ORD-50251',
                            onSelectChanged: (_) =>
                                notifier.selectOrder('ORD-50251'),
                          ),
                          _buildRow(
                            context,
                            number: 'ORD-50250',
                            date: '27/08/2026',
                            client: 'María López',
                            status: 'Enviado',
                            statusColor: Colors.blueAccent,
                            total: 'S/ 350.00',
                            selected: selectedOrderId == 'ORD-50250',
                            onSelectChanged: (_) =>
                                notifier.selectOrder('ORD-50250'),
                          ),
                          _buildRow(
                            context,
                            number: 'ORD-50249',
                            date: '26/08/2026',
                            client: 'Sofía Castro',
                            status: 'Entregado',
                            statusColor: Colors.greenAccent,
                            total: 'S/ 210.00',
                            selected: selectedOrderId == 'ORD-50249',
                            onSelectChanged: (_) =>
                                notifier.selectOrder('ORD-50249'),
                          ),
                          _buildRow(
                            context,
                            number: 'ORD-50248',
                            date: '25/08/2026',
                            client: 'Lucía Mendoza',
                            status: 'Cancelado',
                            statusColor: Colors.redAccent,
                            total: 'S/ 0.00',
                            selected: selectedOrderId == 'ORD-50248',
                            onSelectChanged: (_) =>
                                notifier.selectOrder('ORD-50248'),
                          ),
                          _buildRow(
                            context,
                            number: 'ORD-50247',
                            date: '25/08/2026',
                            client: 'Carla Díaz',
                            status: 'Entregado',
                            statusColor: Colors.greenAccent,
                            total: 'S/ 180.00',
                            selected: selectedOrderId == 'ORD-50247',
                            onSelectChanged: (_) =>
                                notifier.selectOrder('ORD-50247'),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  DataRow _buildRow(
    BuildContext context, {
    required String number,
    required String date,
    required String client,
    required String status,
    required Color statusColor,
    required String total,
    bool selected = false,
    void Function(bool?)? onSelectChanged,
  }) {
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontSize: 11);
    return DataRow(
      selected: selected,
      onSelectChanged: onSelectChanged,
      cells: [
        DataCell(Text(number, style: style)),
        DataCell(Text(date, style: style)),
        DataCell(Text(client, style: style)),
        DataCell(
          Chip(
            label: Text(status, style: style),
            backgroundColor: statusColor.withAlpha(25),
            side: BorderSide(color: statusColor),
            padding: EdgeInsets.zero,
          ),
        ),
        DataCell(Text(total, style: style)),
      ],
    );
  }
}
