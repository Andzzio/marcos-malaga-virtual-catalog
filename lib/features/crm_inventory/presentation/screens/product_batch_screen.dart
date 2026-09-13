import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/features/crm_inventory/presentation/providers/product_batch_provider.dart';
import 'package:marcos_malaga_app/features/crm_inventory/presentation/providers/product_batch_state.dart';
import 'package:marcos_malaga_app/features/crm_inventory/presentation/widgets/product_batch_table.dart';

class ProductBatchScreen extends ConsumerStatefulWidget {
  final ProductBatchMode mode;
  final List<ProductEntity> initialProducts;

  const ProductBatchScreen({
    super.key,
    required this.mode,
    this.initialProducts = const [],
  });

  @override
  ConsumerState<ProductBatchScreen> createState() => _ProductBatchScreenState();
}

class _ProductBatchScreenState extends ConsumerState<ProductBatchScreen> {
  @override
  void initState() {
    super.initState();
    _initProvider();
  }

  @override
  void didUpdateWidget(ProductBatchScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mode != widget.mode ||
        oldWidget.initialProducts != widget.initialProducts) {
      _initProvider();
    }
  }

  void _initProvider() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final notifier = ref.read(productBatchProvider.notifier);
      if (widget.mode == ProductBatchMode.create) {
        notifier.initCreate(widget.initialProducts);
      } else {
        notifier.initEdit(widget.initialProducts);
      }
    });
  }

  @override
  void dispose() {
    ref.invalidate(productBatchProvider);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final batchState = ref.watch(productBatchProvider);
    final style = Theme.of(context).textTheme.labelMedium?.copyWith(
      fontSize: 11,
    );
    final titleStyle = style?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isCreate = batchState.mode == ProductBatchMode.create;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => context.go('/admin/inventory'),
                  icon: const Icon(Icons.arrow_back, size: 20),
                  tooltip: 'Volver al inventario',
                ),
                const Gap(8),
                Text(
                  isCreate ? 'CREAR PRODUCTOS' : 'EDITAR PRODUCTOS',
                  style: titleStyle,
                ),
                const Gap(16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${batchState.rows.length} ${batchState.rows.length == 1 ? 'Producto' : 'Productos'}',
                    style: style?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                if (batchState.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text(
                      batchState.errorMessage!,
                      style: style?.copyWith(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),

          // Table
          Expanded(
            child: ProductBatchTable(
              rows: batchState.rows,
              isEditMode: !isCreate,
              onIdChanged: (tempId) => (value) =>
                  ref.read(productBatchProvider.notifier).updateRowId(tempId, value),
              onNameChanged: (tempId) => (value) =>
                  ref.read(productBatchProvider.notifier).updateRowName(tempId, value),
              onDescriptionChanged: (tempId) => (value) =>
                  ref.read(productBatchProvider.notifier).updateRowDescription(tempId, value),
              onBasePriceChanged: (tempId) => (value) =>
                  ref.read(productBatchProvider.notifier).updateRowBasePrice(tempId, value),
              onDiscountPriceChanged: (tempId) => (value) =>
                  ref.read(productBatchProvider.notifier).updateRowDiscountPrice(tempId, value),
              onVisibilityChanged: (tempId) => (value) =>
                  ref.read(productBatchProvider.notifier).updateRowVisibility(tempId, value),
              onDesignsChanged: (tempId) => (designs) =>
                  ref.read(productBatchProvider.notifier).updateRowDesigns(tempId, designs),
              onCategoriesChanged: (tempId) => (cats) =>
                  ref.read(productBatchProvider.notifier).updateRowCategories(tempId, cats),
              onRemoveRow: (tempId) =>
                  ref.read(productBatchProvider.notifier).removeRow(tempId),
            ),
          ),

          // Bottom bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Row(
              children: [
                if (isCreate)
                  OutlinedButton.icon(
                    onPressed: batchState.isSubmitting
                        ? null
                        : () => ref.read(productBatchProvider.notifier).addRow(),
                    icon: const Icon(Icons.add, size: 16),
                    label: Text('Añadir fila', style: style),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                const Spacer(),
                TextButton(
                  onPressed: batchState.isSubmitting
                      ? null
                      : () => context.go('/admin/inventory'),
                  child: Text('Cancelar', style: style),
                ),
                const Gap(12),
                FilledButton(
                  onPressed: batchState.canSubmit && !batchState.isSubmitting
                      ? () => _handleSubmit()
                      : null,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: batchState.isSubmitting
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            const Gap(8),
                            Text(
                              batchState.submitStatusMessage ?? 'Guardando...',
                              style: style?.copyWith(color: Colors.white),
                            ),
                          ],
                        )
                      : Text(
                          isCreate
                              ? 'Crear productos (${batchState.rows.length})'
                              : 'Actualizar productos (${batchState.rows.length})',
                          style: style?.copyWith(color: Colors.white),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSubmit() async {
    final success = await ref.read(productBatchProvider.notifier).submit();
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.mode == ProductBatchMode.create
                ? 'Productos creados exitosamente'
                : 'Productos actualizados exitosamente',
          ),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/admin/inventory');
    }
  }
}
