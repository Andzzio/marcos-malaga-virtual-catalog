import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../providers/crm_orders_screen_provider.dart';

class CrmOrdersTopBar extends ConsumerWidget {
  const CrmOrdersTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(crmOrdersScreenProvider);
    final notifier = ref.read(crmOrdersScreenProvider.notifier);

    final dateFormat = DateFormat('dd/MM/yyyy');
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontSize: 11);
    final titleStyle = style?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ADMINISTRADOR DE PEDIDOS', style: titleStyle),
        const Gap(24),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                onChanged: notifier.updateSearchQuery,
                decoration: InputDecoration(
                  labelText: 'Buscar por DNI o Nombre',
                  labelStyle: style,
                  prefixIcon: const Icon(Icons.search, size: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const Gap(16),
            Expanded(
              flex: 1,
              child: DropdownButtonFormField<String?>(
                initialValue: state.selectedStatus,
                decoration: InputDecoration(
                  labelText: 'Estado',
                  labelStyle: style,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text('Todos', style: style),
                  ),
                  DropdownMenuItem(
                    value: 'Pendiente',
                    child: Text('Pendiente', style: style),
                  ),
                  DropdownMenuItem(
                    value: 'Confirmado',
                    child: Text('Confirmado', style: style),
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
                onChanged: notifier.updateStatus,
              ),
            ),
            const Gap(16),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(8),
                ),
              ),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: state.startDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (date != null) {
                  notifier.setDateRange(startDate: date);
                }
              },
              icon: FaIcon(FontAwesomeIcons.solidCalendar, color: Colors.white),
              label: Text(
                state.startDate != null
                    ? dateFormat.format(state.startDate!)
                    : 'Fecha Desde',
                style: style?.copyWith(color: Colors.white),
              ),
            ),
            const Gap(8),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(8),
                ),
              ),
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: state.endDate ?? DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (date != null) {
                  notifier.setDateRange(endDate: date);
                }
              },
              icon: FaIcon(FontAwesomeIcons.solidCalendar, color: Colors.white),
              label: Text(
                state.endDate != null
                    ? dateFormat.format(state.endDate!)
                    : 'Fecha Hasta',
                style: style?.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
