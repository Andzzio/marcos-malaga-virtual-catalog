import 'package:flutter/material.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';

class ProductPrice extends StatelessWidget {
  final ProductEntity? product;
  final double? basePrice;
  final double? discountPrice;
  final MainAxisAlignment mainAxisAlignment;
  final bool isMobile;
  const ProductPrice({
    super.key,
    this.product,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.isMobile = false,
    this.basePrice,
    this.discountPrice,
  });

  @override
  Widget build(BuildContext context) {
    if (product != null) {
      return _buildUIWithProduct(context, product!);
    } else if (basePrice != null) {
      return _buildUIWithoutProduct(context, discountPrice, basePrice!);
    } else {
      throw Exception('Need product or basePrice');
    }
  }

  Widget _buildUIWithProduct(BuildContext context, ProductEntity product) {
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

  Widget _buildUIWithoutProduct(
    BuildContext context,
    double? discountPrice,
    double basePrice,
  ) {
    final double fontSize = isMobile ? 11 : 14;
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      spacing: 5,
      children: [
        Text(
          discountPrice != null
              ? 'S/. ${discountPrice.toStringAsFixed(2)}'
              : 'S/. ${basePrice.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontSize: fontSize,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        if (discountPrice != null)
          Text(
            'S/. ${basePrice.toStringAsFixed(2)}',
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
