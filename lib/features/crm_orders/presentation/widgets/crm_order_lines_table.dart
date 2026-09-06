import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/crm_orders_screen_provider.dart';

class CrmOrderLinesTable extends ConsumerWidget {
  const CrmOrderLinesTable({super.key});

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
    final borderColor = Colors.grey.shade400;

    if (selectedOrderId == null) {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: theme.colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text('Seleccione un pedido para ver sus detalles'),
        ),
      );
    }

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
            child: Text(
              'Líneas del Pedido ($selectedOrderId)',
              style: titleStyle,
            ),
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
                        columns: [
                          DataColumn(label: Text('Producto', style: style)),
                          DataColumn(
                            label: Text('Variante/Talla', style: style),
                          ),
                          DataColumn(label: Text('Cant.', style: style)),
                          DataColumn(label: Text('Precio Unit.', style: style)),
                          DataColumn(label: Text('Subtotal', style: style)),
                        ],
                        rows: [
                          DataRow(
                            cells: [
                              DataCell(
                                Text('Vestido Floral Verano', style: style),
                              ),
                              DataCell(Text('M / Rojo', style: style)),
                              DataCell(Text('1')),
                              DataCell(Text('S/ 80.00', style: style)),
                              DataCell(Text('S/ 80.00', style: style)),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text('Blusa Elegante', style: style)),
                              DataCell(Text('S / Blanco', style: style)),
                              DataCell(Text('1', style: style)),
                              DataCell(Text('S/ 40.00', style: style)),
                              DataCell(Text('S/ 40.00', style: style)),
                            ],
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
}
