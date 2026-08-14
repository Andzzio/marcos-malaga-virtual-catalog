import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_size_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/stock_availability.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/providers/product_detail_provider.dart';

class AvailabilityWidget extends ConsumerWidget {
  final ProductEntity product;
  final double radius;
  const AvailabilityWidget({
    super.key,
    this.radius = 10,
    required this.product,
  });

  Color _calculateColorByStock(ProductSizeEntity size) =>
      switch (size.stockAvailability) {
        StockAvailability.outOfStock => Colors.redAccent,
        StockAvailability.lowStock => Colors.orangeAccent,
        StockAvailability.inStock => Colors.greenAccent,
      };
  String _calculateLabelByStock(ProductSizeEntity size) =>
      switch (size.stockAvailability) {
        StockAvailability.outOfStock => 'No disponible',
        StockAvailability.lowStock => '${size.stock} restante',
        StockAvailability.inStock => 'Disponible',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSize = ref.watch(
      productDetailProvider(product).select((state) => state.selectedSize),
    );
    return Row(
      children: [
        Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            color: _calculateColorByStock(selectedSize).withValues(alpha: 0.4),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: radius * 1.5,
              height: radius * 1.5,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.surface,
                ),
                color: _calculateColorByStock(selectedSize),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        Gap(10),
        Text(
          _calculateLabelByStock(selectedSize),
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(fontSize: 14),
        ),
      ],
    );
  }
}
