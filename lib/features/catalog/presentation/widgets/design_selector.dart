import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/providers/product_detail_provider.dart';
import 'package:marcos_malaga_app/app/shared/widgets/image/custom_image.dart';

class DesignSelector extends ConsumerStatefulWidget {
  final ProductEntity product;
  const DesignSelector({super.key, required this.product});

  @override
  ConsumerState<DesignSelector> createState() => _DesignSelectorState();
}

class _DesignSelectorState extends ConsumerState<DesignSelector> {
  int? _designHovered;
  int? _sizeHovered;
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final productDetailState = ref.watch(productDetailProvider(widget.product));
    final productDetailNotifier = ref.read(
      productDetailProvider(widget.product).notifier,
    );
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color / ${productDetailState.selectedDesign.name}',
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(fontSize: 15),
        ),
        Wrap(
          spacing: 5,
          runSpacing: 5,
          children: List.generate(widget.product.designs.length, (index) {
            final design = widget.product.designs[index];
            final isSelected = productDetailState.selectedDesignIndex == index;
            final isDesignHovered = _designHovered == index;
            return MouseRegion(
              onHover: ((event) {
                setState(() {
                  _designHovered = index;
                });
              }),
              onExit: ((event) {
                setState(() {
                  _designHovered = null;
                });
              }),
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  productDetailNotifier.selectDesign(index);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? secondaryColor
                          : !isSelected && isDesignHovered
                          ? secondaryColor.withValues(alpha: 0.5)
                          : Colors.transparent,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: design.colorValue != null
                            ? Color(design.colorValue ?? 0xffffffff)
                            : null,
                        shape: BoxShape.circle,
                      ),
                      child: design.swatchImageUrl != null
                          ? ClipOval(
                              child: CustomImage(
                                design.swatchImageUrl!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        Text(
          'Talla',
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(fontSize: 15),
        ),
        Wrap(
          spacing: 5,
          runSpacing: 5,
          children: List.generate(
            productDetailState.selectedDesign.sizes.length,
            (index) {
              final sizeEntity = productDetailState.selectedDesign.sizes[index];
              final isSelected = productDetailState.selectedSizeIndex == index;
              widget.product.stockAvailability;
              final isSizeHovered = _sizeHovered == index;
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                onHover: (event) {
                  setState(() {
                    _sizeHovered = index;
                  });
                },
                onExit: ((event) {
                  setState(() {
                    _sizeHovered = null;
                  });
                }),
                child: GestureDetector(
                  onTap: () {
                    productDetailNotifier.selectSize(index);
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOutCubicEmphasized,
                    decoration: BoxDecoration(
                      color: isSelected && isSizeHovered
                          ? primaryColor.withValues(alpha: 0.8)
                          : !isSelected && isSizeHovered
                          ? primaryColor.withValues(alpha: 0.1)
                          : isSelected
                          ? primaryColor
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : secondaryColor.withValues(alpha: 0.5),
                      ),
                      borderRadius: BorderRadiusGeometry.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Text(
                        sizeEntity.size,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: isSelected ? Colors.white : primaryColor,
                              fontSize: 14,
                            ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
