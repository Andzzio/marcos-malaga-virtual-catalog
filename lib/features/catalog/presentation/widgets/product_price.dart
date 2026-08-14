import 'package:flutter/material.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';

class ProductPrice extends StatelessWidget {
  final ProductEntity product;
  final MainAxisAlignment mainAxisAlignment;
  final bool isMobile;
  const ProductPrice({
    super.key,
    required this.product,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    final double fontSize = isMobile ? 11 : 14;
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      spacing: 5,
      children: [
        Text(
          product.discountPrice != null
              ? 'S/. ${product.discountPrice?.toStringAsFixed(2)}'
              : 'S/. ${product.basePrice.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontSize: fontSize,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        if (product.discountPrice != null)
          Text(
            'S/. ${product.basePrice.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontSize: fontSize,
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
      ],
    );
  }
}
