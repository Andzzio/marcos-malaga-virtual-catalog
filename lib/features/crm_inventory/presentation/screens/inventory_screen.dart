import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/features/crm_inventory/presentation/providers/inventory_screen_provider.dart';
import 'package:marcos_malaga_app/features/crm_inventory/presentation/widgets/inventory_product_card.dart';
import 'package:marcos_malaga_app/features/crm_inventory/presentation/widgets/inventory_properties_panel.dart';
import 'package:marcos_malaga_app/features/crm_inventory/presentation/widgets/inventory_top_bar.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredProductsAsync = ref.watch(filteredInventoryProductsProvider);
    final selectedCount = ref.watch(
      inventoryScreenProvider.select((s) => s.selectedProductIds.length),
    );
    final selectedFilter = ref.watch(
      inventoryScreenProvider.select((s) => s.selectedFilter),
    );
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontSize: 11);

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const InventoryTopBar(),
                  const Gap(24),
                  Text('Seleccionados: $selectedCount', style: style),
                  const Gap(16),
                  Expanded(
                    child: filteredProductsAsync.when(
                      data: (filteredProducts) {
                        if (filteredProducts.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  selectedFilter == 'Papelera'
                                      ? Icons.delete_outline
                                      : Icons.search_off,
                                  size: 48,
                                  color: Colors.grey.shade400,
                                ),
                                const Gap(12),
                                Text(
                                  selectedFilter == 'Papelera'
                                      ? 'No hay productos en la papelera'
                                      : 'No se encontraron productos con los filtros actuales',
                                  style: style?.copyWith(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 250,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.8,
                              ),
                          itemCount: filteredProducts.length,
                          itemBuilder: (context, index) {
                            return InventoryProductCard(
                              product: filteredProducts[index],
                            );
                          },
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, stack) =>
                          Center(child: Text('Error: $error', style: style)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const InventoryPropertiesPanel(),
        ],
      ),
    );
  }
}
