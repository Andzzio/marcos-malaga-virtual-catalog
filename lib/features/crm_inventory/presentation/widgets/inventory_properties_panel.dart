import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/presentation/providers/products_provider.dart';
import 'package:marcos_malaga_app/features/crm_inventory/presentation/providers/inventory_screen_provider.dart';

class InventoryPropertiesPanel extends ConsumerWidget {
  const InventoryPropertiesPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryState = ref.watch(inventoryScreenProvider);
    final productsAsync = ref.watch(productsProvider);
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontSize: 11);
    final titleStyle = style?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );

    final selectedCount = inventoryState.selectedProductIds.length;

    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(left: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text('PROPIEDADES', style: titleStyle),
          ),
          const Divider(height: 1),
          Expanded(
            child: productsAsync.when(
              data: (products) {
                if (selectedCount == 0) {
                  return _buildEmptyState(context);
                } else if (selectedCount == 1) {
                  final productId = inventoryState.selectedProductIds.first;
                  final product = products.firstWhere(
                    (p) => p.id == productId,
                    orElse: () => products.first, // Fallback safe
                  );
                  if (product.id != productId) return _buildEmptyState(context);

                  return _buildFormState(context, product);
                } else {
                  return _buildMultipleSelectedState(
                    context,
                    ref,
                    selectedCount,
                  );
                }
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontSize: 11);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.touch_app, size: 64, color: Colors.grey.shade400),
          const Gap(16),
          Text(
            'Selecciona un producto de la grilla para ver y editar sus propiedades',
            textAlign: TextAlign.center,
            style: style?.copyWith(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  Widget _buildMultipleSelectedState(
    BuildContext context,
    WidgetRef ref,
    int count,
  ) {
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontSize: 11);
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: FaIcon(
              FontAwesomeIcons.solidFolderOpen,
              size: 64,
              color: Colors.grey.shade400,
            ),
          ),
          const Gap(16),
          Text(
            '$count productos seleccionados',
            textAlign: TextAlign.center,
            style: style?.copyWith(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Gap(24),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(8),
              ),
            ),
            child: Text(
              'Editar seleccionados ($count)',
              style: style?.copyWith(color: Colors.white),
            ),
          ),
          const Gap(8),
          OutlinedButton(
            onPressed: () {
              ref.read(inventoryScreenProvider.notifier).clearSelection();
            },
            style: OutlinedButton.styleFrom(),
            child: Text(
              'Deseleccionar todos',
              style: style?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormState(BuildContext context, ProductEntity product) {
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontSize: 11);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(
            context,
            'Identificador (ID)',
            'Ej. PROD-01',
            initialValue: product.id,
          ),
          const Gap(16),
          _buildTextField(
            context,
            'Nombre Comercial',
            'Ej. Vestido Floral',
            initialValue: product.name,
          ),
          const Gap(16),
          _buildTextField(
            context,
            'Descripción',
            'Detalles de la prenda...',
            maxLines: 4,
            initialValue: product.description,
          ),
          const Gap(16),
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  context,
                  'Precio Base',
                  '0.00',
                  initialValue: product.basePrice.toStringAsFixed(2),
                ),
              ),
              const Gap(16),
              Expanded(
                child: _buildTextField(
                  context,
                  'Precio Descuento',
                  '0.00',
                  initialValue:
                      product.discountPrice?.toStringAsFixed(2) ?? '0.00',
                ),
              ),
            ],
          ),
          const Gap(16),
          _buildCategoriesMock(context),
          const Gap(24),
          FilledButton.icon(
            onPressed: () {},
            icon: FaIcon(FontAwesomeIcons.wandMagicSparkles, size: 14),
            label: Text(
              'Gestionar Variantes & Stock',
              style: style?.copyWith(color: Colors.white),
            ),
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(8),
              ),
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String label,
    String hint, {
    int maxLines = 1,
    String? initialValue,
  }) {
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontSize: 11);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: style?.copyWith(color: Colors.grey.shade700)),
        const Gap(8),
        TextFormField(
          initialValue: initialValue,
          style: style,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: style,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesMock(BuildContext context) {
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontSize: 11);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Categorías', style: style?.copyWith(color: Colors.grey.shade700)),
        const Gap(8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(
              label: Text('Vestidos', style: style),
              onDeleted: () {},
            ),
            Chip(
              label: Text('Verano', style: style),
              onDeleted: () {},
            ),
            ActionChip(
              label: Text('Añadir +', style: style),
              onPressed: () {},
              backgroundColor: Colors.grey.shade200,
            ),
          ],
        ),
      ],
    );
  }
}
