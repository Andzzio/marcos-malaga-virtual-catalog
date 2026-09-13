import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/presentation/providers/products_provider.dart';
import 'package:marcos_malaga_app/app/shared/widgets/image/custom_image.dart';
import 'package:marcos_malaga_app/features/crm_inventory/presentation/providers/inventory_screen_provider.dart';

import 'package:marcos_malaga_app/features/catalog/presentation/widgets/product_price.dart';

class InventoryProductCard extends ConsumerStatefulWidget {
  final ProductEntity product;
  const InventoryProductCard({super.key, required this.product});

  @override
  ConsumerState<InventoryProductCard> createState() =>
      _InventoryProductCardState();
}

class _InventoryProductCardState extends ConsumerState<InventoryProductCard> {
  bool _isTogglingVisibility = false;

  Future<void> _toggleVisibility(
    ProductEntity effectiveProduct,
    bool isVisible,
  ) async {
    setState(() => _isTogglingVisibility = true);
    try {
      final updatedProduct = effectiveProduct.copyWith(
        isVisible: !isVisible,
      );
      await ref.read(productsProvider.notifier).updateProduct(updatedProduct);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cambiar visibilidad: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isTogglingVisibility = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final isSelected = ref.watch(
      inventoryScreenProvider.select(
        (state) => state.selectedProductIds.contains(product.id),
      ),
    );
    final draft = ref.watch(
      inventoryScreenProvider.select((state) => state.pendingEdits[product.id]),
    );
    final effectiveProduct = draft ?? product;
    final isVisible = effectiveProduct.isVisible;
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontSize: 11);
    final styleBold = style?.copyWith(fontWeight: FontWeight.bold);

    return InkWell(
      onTap: () {
        ref.read(inventoryScreenProvider.notifier).toggleSelection(product.id);
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : (draft != null ? Colors.amber.shade700 : Colors.grey.shade300),
            width: isSelected ? 2 : (draft != null ? 1.5 : 1),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(8),
          child: Stack(
            children: [
              Opacity(
                opacity: isVisible ? 1.0 : 0.75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 9,
                      child: CustomImage(
                        effectiveProduct.designs.first.imageUrls.first,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              effectiveProduct.id,
                              style: style?.copyWith(color: Colors.grey.shade600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Gap(4),
                            Text(
                              effectiveProduct.name,
                              style: styleBold,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const Gap(4),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: ProductPrice(
                                  product: effectiveProduct,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (draft != null)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade800,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit, size: 10, color: Colors.white),
                        Gap(3),
                        Text(
                          'Editado',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else if (product.isDeleted)
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.red.shade800,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.delete_outline, size: 10, color: Colors.white),
                        Gap(3),
                        Text(
                          'Eliminado',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (product.isDeleted)
                Positioned(
                  top: 4,
                  right: 4,
                  child: SizedBox(
                    width: 35,
                    height: 35,
                    child: IconButton(
                      icon: Icon(Icons.restore, size: 18, color: Colors.green.shade800),
                      onPressed: () async {
                        await ref.read(productsProvider.notifier).restore(product.id);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Producto "${product.name}" restaurado'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                      tooltip: 'Restaurar a la tienda',
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.95),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(8),
                        ),
                      ),
                    ),
                  ),
                )
              else
                Positioned(
                  top: 4,
                  right: 4,
                  child: SizedBox(
                    width: 35,
                    height: 35,
                    child: IconButton(
                      icon: _isTogglingVisibility
                          ? SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).primaryColor,
                              ),
                            )
                          : FaIcon(
                              isVisible
                                  ? FontAwesomeIcons.eye
                                  : FontAwesomeIcons.eyeSlash,
                              size: 18,
                              color: isVisible
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade400,
                            ),
                      onPressed: _isTogglingVisibility
                          ? null
                          : () => _toggleVisibility(effectiveProduct, isVisible),
                      tooltip: isVisible
                          ? 'Visible en catálogo (clic para ocultar)'
                          : 'Oculto en catálogo (clic para mostrar)',
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
