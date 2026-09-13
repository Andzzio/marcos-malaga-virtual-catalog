import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/presentation/providers/products_provider.dart';
import 'package:marcos_malaga_app/features/crm_inventory/presentation/providers/inventory_screen_provider.dart';
import 'package:marcos_malaga_app/features/crm_inventory/presentation/providers/product_batch_state.dart';
import 'package:marcos_malaga_app/features/crm_inventory/presentation/widgets/product_categories_dialog.dart';

class InventoryPropertiesPanel extends ConsumerWidget {
  const InventoryPropertiesPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryState = ref.watch(inventoryScreenProvider);
    final productsAsync = ref.watch(productsProvider);
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 11);
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
                    orElse: () => products.first,
                  );
                  if (product.id != productId) {
                    return _buildEmptyState(context);
                  }
                  if (product.isDeleted) {
                    return _buildDeletedProductState(context, ref, product);
                  }

                  return _SingleProductPropertiesForm(
                    key: ValueKey(product.id),
                    product: product,
                  );
                } else {
                  final selectedProducts = products
                      .where((p) =>
                          inventoryState.selectedProductIds.contains(p.id))
                      .toList();
                  final allDeleted =
                      selectedProducts.isNotEmpty &&
                      selectedProducts.every((p) => p.isDeleted);
                  if (allDeleted) {
                    return _buildMultipleDeletedState(
                      context,
                      ref,
                      selectedCount,
                      selectedProducts,
                    );
                  }
                  return _buildMultipleSelectedState(
                    context,
                    ref,
                    selectedCount,
                    selectedProducts.where((p) => !p.isDeleted).toList(),
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
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 11);
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

  Widget _buildDeletedProductState(
    BuildContext context,
    WidgetRef ref,
    ProductEntity product,
  ) {
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 11);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.delete_outline, size: 48, color: Colors.red.shade400),
            ),
          ),
          const Gap(16),
          Text(
            product.name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Gap(4),
          Text(
            'ID: ${product.id}',
            textAlign: TextAlign.center,
            style: style?.copyWith(color: Colors.grey.shade600),
          ),
          const Gap(16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 18, color: Colors.red.shade700),
                const Gap(8),
                Expanded(
                  child: Text(
                    'Este producto está en la papelera de reciclaje. No es visible para los clientes.',
                    style: TextStyle(fontSize: 11, color: Colors.red.shade800),
                  ),
                ),
              ],
            ),
          ),
          const Gap(24),
          FilledButton.icon(
            icon: const Icon(Icons.restore, size: 18),
            label: const Text('Restaurar a la tienda'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              await ref.read(productsProvider.notifier).restore(product.id);
              ref.read(inventoryScreenProvider.notifier).clearSelection();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Producto "${product.name}" restaurado con éxito'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMultipleDeletedState(
    BuildContext context,
    WidgetRef ref,
    int count,
    List<ProductEntity> selectedProducts,
  ) {
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 11);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.delete_sweep_outlined, size: 48, color: Colors.red.shade400),
            ),
          ),
          const Gap(16),
          Text(
            '$count productos en la papelera',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const Gap(8),
          Text(
            'Puedes restaurar todos estos productos a la tienda con un solo clic.',
            textAlign: TextAlign.center,
            style: style?.copyWith(color: Colors.grey.shade600),
          ),
          const Gap(24),
          FilledButton.icon(
            icon: const Icon(Icons.restore, size: 18),
            label: Text('Restaurar seleccionados ($count)'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              final ids = selectedProducts.map((p) => p.id).toList();
              await ref.read(productsProvider.notifier).restoreMany(ids);
              ref.read(inventoryScreenProvider.notifier).clearSelection();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$count productos restaurados con éxito'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMultipleSelectedState(
    BuildContext context,
    WidgetRef ref,
    int count,
    List<ProductEntity> selectedProducts,
  ) {
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 11);

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
          // Editar seleccionados
          FilledButton.icon(
            onPressed: () {
              context.go(
                '/admin/inventory/batch',
                extra: {
                  'mode': ProductBatchMode.edit,
                  'products': selectedProducts,
                },
              );
            },
            icon: const Icon(Icons.edit, size: 16),
            label: Text(
              'Editar seleccionados ($count)',
              style: style?.copyWith(color: Colors.white),
            ),
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: const Size(double.infinity, 44),
            ),
          ),
          const Gap(10),
          // Duplicar seleccionados
          OutlinedButton.icon(
            onPressed: () {
              final cloned = selectedProducts.map((p) {
                final draft =
                    ref.read(inventoryScreenProvider).pendingEdits[p.id];
                final effective = draft ?? p;
                return effective.copyWith(
                  id: '${effective.id}-COPIA',
                  name: '${effective.name} (Copia)',
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
            },
            icon: const FaIcon(FontAwesomeIcons.solidClone, size: 14),
            label: Text(
              'Duplicar seleccionados ($count)',
              style: style,
            ),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: const Size(double.infinity, 44),
            ),
          ),
          const Gap(10),
          // Eliminar seleccionados
          OutlinedButton.icon(
            onPressed: () => _confirmDeleteMultiple(context, ref, selectedProducts),
            icon: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
            label: Text(
              'Eliminar seleccionados ($count)',
              style: style?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: const Size(double.infinity, 44),
            ),
          ),
          const Gap(12),
          TextButton(
            onPressed: () {
              ref.read(inventoryScreenProvider.notifier).clearSelection();
            },
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

  void _confirmDeleteMultiple(
    BuildContext context,
    WidgetRef ref,
    List<ProductEntity> selectedProducts,
  ) {
    final count = selectedProducts.length;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Eliminar $count productos'),
        content: Text(
          '¿Estás seguro de que deseas enviar los $count productos seleccionados a la papelera? Podrás recuperarlos más adelante.',
        ),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              final ids = selectedProducts.map((p) => p.id).toList();
              await ref.read(productsProvider.notifier).softDeleteMany(ids);
              for (final id in ids) {
                ref.read(inventoryScreenProvider.notifier).discardDraft(id);
              }
              ref.read(inventoryScreenProvider.notifier).clearSelection();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$count productos enviados a la papelera'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            child: const Text('Eliminar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }
}

class _SingleProductPropertiesForm extends ConsumerStatefulWidget {
  final ProductEntity product;

  const _SingleProductPropertiesForm({
    super.key,
    required this.product,
  });

  @override
  ConsumerState<_SingleProductPropertiesForm> createState() =>
      _SingleProductPropertiesFormState();
}

class _SingleProductPropertiesFormState
    extends ConsumerState<_SingleProductPropertiesForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _basePriceController;
  late final TextEditingController _discountPriceController;

  @override
  void initState() {
    super.initState();
    final draft =
        ref.read(inventoryScreenProvider).pendingEdits[widget.product.id];
    final effectiveProduct = draft ?? widget.product;
    _nameController = TextEditingController(text: effectiveProduct.name);
    _descriptionController =
        TextEditingController(text: effectiveProduct.description);
    _basePriceController = TextEditingController(
      text: effectiveProduct.basePrice > 0
          ? effectiveProduct.basePrice.toStringAsFixed(2)
          : '',
    );
    _discountPriceController = TextEditingController(
      text: effectiveProduct.discountPrice != null &&
              effectiveProduct.discountPrice! > 0
          ? effectiveProduct.discountPrice!.toStringAsFixed(2)
          : '',
    );
  }

  @override
  void didUpdateWidget(covariant _SingleProductPropertiesForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product.id != widget.product.id) {
      final draft =
          ref.read(inventoryScreenProvider).pendingEdits[widget.product.id];
      _updateControllers(draft ?? widget.product);
    } else if (oldWidget.product != widget.product) {
      final hasDraft = ref
          .read(inventoryScreenProvider)
          .pendingEdits
          .containsKey(widget.product.id);
      if (!hasDraft) {
        _updateControllers(widget.product);
      }
    }
  }

  void _updateControllers(ProductEntity product) {
    _nameController.text = product.name;
    _descriptionController.text = product.description;
    _basePriceController.text = product.basePrice > 0
        ? product.basePrice.toStringAsFixed(2)
        : '';
    _discountPriceController.text = product.discountPrice != null &&
            product.discountPrice! > 0
        ? product.discountPrice!.toStringAsFixed(2)
        : '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _basePriceController.dispose();
    _discountPriceController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    final basePrice =
        double.tryParse(_basePriceController.text) ?? widget.product.basePrice;
    final discountPrice = _discountPriceController.text.trim().isNotEmpty
        ? double.tryParse(_discountPriceController.text)
        : null;

    final currentDraft =
        ref.read(inventoryScreenProvider).pendingEdits[widget.product.id];
    final currentCategories =
        currentDraft?.categoryIds ?? widget.product.categoryIds;

    final updated = widget.product.copyWith(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      basePrice: basePrice,
      discountPrice: discountPrice,
      categoryIds: currentCategories,
    );

    final isBackToOriginal =
        updated.name == widget.product.name &&
        updated.description == widget.product.description &&
        (updated.basePrice - widget.product.basePrice).abs() < 0.001 &&
        updated.discountPrice == widget.product.discountPrice &&
        listEquals(updated.categoryIds, widget.product.categoryIds);

    if (isBackToOriginal) {
      ref.read(inventoryScreenProvider.notifier).discardDraft(widget.product.id);
    } else {
      ref.read(inventoryScreenProvider.notifier).updateProductDraft(updated);
    }
  }

  void _updateCategories(List<String> newCategories) {
    final basePrice =
        double.tryParse(_basePriceController.text) ?? widget.product.basePrice;
    final discountPrice = _discountPriceController.text.trim().isNotEmpty
        ? double.tryParse(_discountPriceController.text)
        : null;

    final updated = widget.product.copyWith(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      basePrice: basePrice,
      discountPrice: discountPrice,
      categoryIds: newCategories,
    );

    final isBackToOriginal =
        updated.name == widget.product.name &&
        updated.description == widget.product.description &&
        (updated.basePrice - widget.product.basePrice).abs() < 0.001 &&
        updated.discountPrice == widget.product.discountPrice &&
        listEquals(updated.categoryIds, widget.product.categoryIds);

    if (isBackToOriginal) {
      ref.read(inventoryScreenProvider.notifier).discardDraft(widget.product.id);
    } else {
      ref.read(inventoryScreenProvider.notifier).updateProductDraft(updated);
    }
  }

  void _discardDraft() {
    ref.read(inventoryScreenProvider.notifier).discardDraft(widget.product.id);
    _updateControllers(widget.product);
  }

  void _confirmDeleteSingle(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text(
          '¿Estás seguro de que deseas enviar "${widget.product.name}" a la papelera? Podrás recuperarlo más adelante.',
        ),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
            onPressed: () async {
              Navigator.of(ctx).pop();
              await ref
                  .read(productsProvider.notifier)
                  .softDelete(widget.product.id);
              ref
                  .read(inventoryScreenProvider.notifier)
                  .discardDraft(widget.product.id);
              ref.read(inventoryScreenProvider.notifier).clearSelection();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Producto enviado a la papelera'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
              }
            },
            child: const Text('Eliminar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 11);
    final hasPending = ref.watch(
      inventoryScreenProvider.select(
        (s) => s.pendingEdits.containsKey(widget.product.id),
      ),
    );
    final currentDraft = ref.watch(
      inventoryScreenProvider.select(
        (s) => s.pendingEdits[widget.product.id],
      ),
    );
    final effectiveProduct = currentDraft ?? widget.product;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner de cambios pendientes
          if (hasPending) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.edit_note,
                        size: 18,
                        color: Colors.amber.shade900,
                      ),
                      const Gap(8),
                      Expanded(
                        child: Text(
                          'Cambios sin guardar',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: _discardDraft,
                        child: const Text(
                          'Descartar',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(4),
                  Text(
                    'Para persistir las modificaciones en la base de datos, pulsa el botón Guardar (icono 💾) en la barra superior.',
                    style: TextStyle(fontSize: 11, color: Colors.amber.shade900),
                  ),
                ],
              ),
            ),
            const Gap(16),
          ],

          // ID (ReadOnly)
          _buildFieldContainer(
            label: 'Identificador (ID)',
            child: TextFormField(
              initialValue: widget.product.id,
              readOnly: true,
              style: style?.copyWith(color: Colors.grey.shade700),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const Gap(16),

          // Nombre Comercial
          _buildFieldContainer(
            label: 'Nombre Comercial',
            child: TextFormField(
              controller: _nameController,
              style: style,
              onChanged: (_) => _onFieldChanged(),
              decoration: const InputDecoration(
                hintText: 'Ej. Vestido Floral',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
          ),
          const Gap(16),

          // Descripción
          _buildFieldContainer(
            label: 'Descripción',
            child: TextFormField(
              controller: _descriptionController,
              style: style,
              maxLines: 3,
              onChanged: (_) => _onFieldChanged(),
              decoration: const InputDecoration(
                hintText: 'Detalles de la prenda...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
          ),
          const Gap(16),

          // Precios
          Row(
            children: [
              Expanded(
                child: _buildFieldContainer(
                  label: 'Precio Base',
                  child: TextFormField(
                    controller: _basePriceController,
                    style: style,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    onChanged: (_) => _onFieldChanged(),
                    decoration: const InputDecoration(
                      hintText: '0.00',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ),
              ),
              const Gap(16),
              Expanded(
                child: _buildFieldContainer(
                  label: 'Precio Descuento',
                  child: TextFormField(
                    controller: _discountPriceController,
                    style: style,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    onChanged: (_) => _onFieldChanged(),
                    decoration: const InputDecoration(
                      hintText: '0.00',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Gap(16),

          // Categorías Reales
          _buildCategories(context, effectiveProduct),

          const Gap(24),
          const Divider(height: 1),
          const Gap(16),

          // ACCIONES RÁPIDAS
          Text(
            'ACCIONES RÁPIDAS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
          const Gap(12),

          // 1. Edición avanzada
          FilledButton.icon(
            onPressed: () {
              context.go(
                '/admin/inventory/batch',
                extra: {
                  'mode': ProductBatchMode.edit,
                  'products': [effectiveProduct],
                },
              );
            },
            icon: const FaIcon(FontAwesomeIcons.penToSquare, size: 14),
            label: Text(
              'Edición avanzada',
              style: style?.copyWith(color: Colors.white),
            ),
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: const Size(double.infinity, 44),
            ),
          ),
          const Gap(8),

          // 2. Duplicar producto
          OutlinedButton.icon(
            onPressed: () {
              final clone = effectiveProduct.copyWith(
                id: '${effectiveProduct.id}-COPIA',
                name: '${effectiveProduct.name} (Copia)',
                createdAt: DateTime.now(),
                deletedAt: null,
              );
              context.go(
                '/admin/inventory/batch',
                extra: {
                  'mode': ProductBatchMode.create,
                  'products': [clone],
                },
              );
            },
            icon: const FaIcon(FontAwesomeIcons.solidClone, size: 14),
            label: Text('Duplicar producto', style: style),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: const Size(double.infinity, 44),
            ),
          ),
          const Gap(8),

          // 3. Eliminar producto (destructive)
          OutlinedButton.icon(
            onPressed: () => _confirmDeleteSingle(context),
            icon: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
            label: Text(
              'Eliminar producto',
              style: style?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: const Size(double.infinity, 44),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldContainer({required String label, required Widget child}) {
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 11);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: style?.copyWith(color: Colors.grey.shade700)),
        const Gap(6),
        child,
      ],
    );
  }

  Widget _buildCategories(
    BuildContext context,
    ProductEntity effectiveProduct,
  ) {
    final style =
        Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 11);
    final categories = effectiveProduct.categoryIds;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Categorías', style: style?.copyWith(color: Colors.grey.shade700)),
            if (categories.isNotEmpty)
              Text(
                '${categories.length} asignada(s)',
                style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
              ),
          ],
        ),
        const Gap(8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ...categories.map((cat) {
              return Chip(
                label: Text(cat, style: style),
                deleteIcon: const Icon(Icons.close, size: 14),
                onDeleted: () {
                  final newCategories = List<String>.from(categories)
                    ..remove(cat);
                  _updateCategories(newCategories);
                },
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withValues(alpha: 0.3),
                side: BorderSide(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.2),
                ),
                visualDensity: VisualDensity.compact,
              );
            }),
            ActionChip(
              avatar: const Icon(Icons.add, size: 14),
              label: Text(
                categories.isEmpty ? 'Añadir categoría' : 'Gestionar',
                style: style?.copyWith(fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                ProductCategoriesDialog.show(
                  context: context,
                  initialCategories: categories,
                  onSave: (newCats) {
                    _updateCategories(newCats);
                  },
                );
              },
              backgroundColor: Colors.grey.shade100,
              side: BorderSide(color: Colors.grey.shade300),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      ],
    );
  }
}
