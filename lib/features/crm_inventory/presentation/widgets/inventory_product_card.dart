import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/presentation/providers/products_provider.dart';
import 'package:marcos_malaga_app/app/shared/widgets/image/custom_image.dart';
import 'package:marcos_malaga_app/features/crm_inventory/presentation/providers/inventory_screen_provider.dart';

import 'package:marcos_malaga_app/features/catalog/presentation/widgets/product_price.dart';

class InventoryProductCard extends ConsumerWidget {
  final ProductEntity product;
  const InventoryProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(
      inventoryScreenProvider.select(
        (state) => state.selectedProductIds.contains(product.id),
      ),
    );
    final isVisible = product.isVisible;
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
                : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(8),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 9,
                    child: CustomImage(
                      product.designs.first.imageUrls.first,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.id,
                            style: style?.copyWith(color: Colors.grey.shade600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Gap(4),
                          Text(
                            product.name,
                            style: styleBold,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Gap(4),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: ProductPrice(
                                product: product,
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
              Positioned(
                top: 4,
                right: 4,
                child: SizedBox(
                  width: 35,
                  height: 35,
                  child: IconButton(
                    icon: FaIcon(
                      isVisible
                          ? FontAwesomeIcons.eye
                          : FontAwesomeIcons.eyeSlash,
                      size: 18,
                      color: isVisible
                          ? Colors.grey.shade700
                          : Colors.grey.shade400,
                    ),
                    onPressed: () {
                      final updatedProduct = product.copyWith(
                        isVisible: !isVisible,
                      );
                      ref
                          .read(productsProvider.notifier)
                          .updateProduct(updatedProduct);
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.8),
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
