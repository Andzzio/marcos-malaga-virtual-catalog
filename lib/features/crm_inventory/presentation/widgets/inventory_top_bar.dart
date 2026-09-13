import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:marcos_malaga_app/app/shared/presentation/providers/products_provider.dart';
import 'package:marcos_malaga_app/features/crm_inventory/presentation/providers/inventory_screen_provider.dart';
import 'package:marcos_malaga_app/features/crm_inventory/presentation/providers/product_batch_state.dart';

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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.inventory_2_outlined, size: 16),
                        const Gap(8),
                        Text('Todos', style: style),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Visibles',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.visibility_outlined, size: 16, color: Colors.green.shade700),
                        const Gap(8),
                        Text('Visibles', style: style),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Ocultos',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.visibility_off_outlined, size: 16, color: Colors.grey.shade600),
                        const Gap(8),
                        Text('Ocultos', style: style),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Con stock',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_outline, size: 16, color: Colors.blue.shade700),
                        const Gap(8),
                        Text('Con stock', style: style),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Sin stock',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.highlight_off, size: 16, color: Colors.orange.shade700),
                        const Gap(8),
                        Text('Sin stock', style: style),
                      ],
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'Papelera',
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.delete_outline, size: 16, color: Colors.red.shade700),
                        const Gap(8),
                        Text('Papelera', style: style),
                      ],
                    ),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    ref.read(inventoryScreenProvider.notifier).clearSelection();
                    ref
                        .read(inventoryScreenProvider.notifier)
                        .updateFilter(value);
                  }
                },
              ),
            ),
            const Gap(16),
            IconButton(
              onPressed: inventoryState.hasPendingEdits && !inventoryState.isSaving
                  ? () async {
                      final count = inventoryState.pendingEditsCount;
                      final success = await ref
                          .read(inventoryScreenProvider.notifier)
                          .saveAllPending();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? 'Se guardaron los cambios de $count producto(s)'
                                  : 'Error al guardar los cambios',
                            ),
                            backgroundColor:
                                success ? Colors.green : Colors.red,
                          ),
                        );
                      }
                    }
                  : null,
              icon: inventoryState.isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Badge(
                      isLabelVisible: inventoryState.hasPendingEdits,
                      label: Text('${inventoryState.pendingEditsCount}'),
                      backgroundColor: Colors.amber.shade800,
                      child: const FaIcon(FontAwesomeIcons.solidFloppyDisk, size: 18),
                    ),
              color: Colors.white,
              style: IconButton.styleFrom(
                backgroundColor: inventoryState.hasPendingEdits
                    ? primaryColor
                    : Colors.grey.shade400,
                disabledBackgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              tooltip: inventoryState.hasPendingEdits
                  ? 'Guardar cambios pendientes (${inventoryState.pendingEditsCount})'
                  : 'Sin cambios pendientes',
            ),
            const Gap(8),
            IconButton(
              onPressed: inventoryState.selectedProductIds.isNotEmpty
                  ? () {
                      final selectedIds = inventoryState.selectedProductIds;
                      final products = ref.read(productsProvider).value ?? [];
                      final selectedProducts = products
                          .where((p) => selectedIds.contains(p.id) && !p.isDeleted)
                          .map((p) => inventoryState.pendingEdits[p.id] ?? p)
                          .toList();

                      final cloned = selectedProducts.map((p) {
                        return p.copyWith(
                          id: '${p.id}-COPIA',
                          name: '${p.name} (Copia)',
                          createdAt: DateTime.now(),
                          deletedAt: null,
                        );
                      }).toList();

                      context.go(
                        '/admin/inventory/batch',
                        extra: {
                          'mode': ProductBatchMode.create,
                          'products': cloned,
                        },
                      );
                    }
                  : null,
              icon: const FaIcon(FontAwesomeIcons.solidClone, size: 18),
              color: Colors.white,
              style: IconButton.styleFrom(
                backgroundColor: inventoryState.selectedProductIds.isNotEmpty
                    ? primaryColor
                    : Colors.grey.shade400,
                disabledBackgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              tooltip: inventoryState.selectedProductIds.isEmpty
                  ? 'Selecciona al menos un producto para duplicar'
                  : 'Duplicar ${inventoryState.selectedProductIds.length} producto(s)',
            ),
            const Gap(8),
            FilledButton.icon(
              onPressed: () {
                context.go(
                  '/admin/inventory/batch',
                  extra: {'mode': ProductBatchMode.create},
                );
              },
              icon: const Icon(Icons.add, size: 16),
              label: Text('Crear Productos', style: style?.copyWith(color: Colors.white)),
              style: FilledButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
