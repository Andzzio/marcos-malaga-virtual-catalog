import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/product_cart_button.dart';
import 'package:marcos_malaga_app/app/shared/widgets/image/custom_image.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/product_price.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key, required this.product});

  final ProductEntity product;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isCardHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onHover: (event) {
        setState(() {
          _isCardHovered = true;
        });
      },
      onExit: (event) {
        setState(() {
          _isCardHovered = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          context.go(
            '/products/${widget.product.id}',
            extra: {'product': widget.product},
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CustomImage(
                    _isCardHovered &&
                            widget.product.designs.first.imageUrls.length > 1
                        ? widget.product.designs.first.imageUrls[1]
                        : widget.product.designs.first.imageUrls.first,
                    fit: BoxFit.cover,
                  ),
                  if (widget.product.discountPrice != null)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadiusGeometry.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: Text(
                            () {
                              final discountPrice =
                                  ((widget.product.basePrice -
                                          widget.product.discountPrice!) /
                                      widget.product.basePrice) *
                                  100;
                              return '-${discountPrice.toStringAsFixed(0)}% DCTO';
                            }(),
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(fontSize: 14, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  if (_isCardHovered)
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: ProductCartButton(),
                    ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(color: Colors.transparent),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.product.name,
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium?.copyWith(fontSize: 14),
                    ),
                    ProductPrice(product: widget.product),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

