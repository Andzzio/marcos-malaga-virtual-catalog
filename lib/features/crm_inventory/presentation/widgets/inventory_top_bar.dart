import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/features/crm_inventory/presentation/providers/inventory_screen_provider.dart';

class InventoryTopBar extends ConsumerWidget {
  const InventoryTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryState = ref.watch(inventoryScreenProvider);
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
        Text('ADMINISTRADOR DE INVENTARIO', style: titleStyle),
        const Gap(16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                onChanged: (value) {
                  ref
                      .read(inventoryScreenProvider.notifier)
                      .updateSearchQuery(value);
                },
                decoration: InputDecoration(
                  hintText: 'Buscar...',
                  hintStyle: style,
                  suffixIcon: Icon(Icons.search, size: 21),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const Gap(16),
            Expanded(
              flex: 1,
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                initialValue: inventoryState.selectedFilter,
                items: [
                  DropdownMenuItem(
                    value: 'Todos',
                    child: Text('Elegir Filtro', style: style),
                  ),
                  DropdownMenuItem(
                    value: 'filter_2',
                    child: Text('Filtro 2', style: style),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    ref
                        .read(inventoryScreenProvider.notifier)
                        .updateFilter(value);
                  }
                },
              ),
            ),
            const Gap(16),
            IconButton(
              onPressed: () {},
              icon: FaIcon(FontAwesomeIcons.solidFloppyDisk, size: 18),
              color: Colors.white,
              style: IconButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              tooltip: 'Guardar',
            ),
            const Gap(8),
            IconButton(
              onPressed: () {},
              icon: FaIcon(FontAwesomeIcons.solidClone, size: 18),
              color: Colors.white,
              style: IconButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              tooltip: 'Duplicar',
            ),
          ],
        ),
      ],
    );
  }
}
