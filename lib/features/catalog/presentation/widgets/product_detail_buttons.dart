import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marcos_malaga_app/app/config/theme/responsive_theme.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/stock_availability.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/providers/product_detail_provider.dart';
import 'package:marcos_malaga_app/app/shared/widgets/buttons/yes_filled_button.dart';
import 'package:marcos_malaga_app/app/shared/widgets/inputs/quantity_selector.dart';
import 'package:marcos_malaga_app/app/shared/widgets/buttons/add_to_cart_button.dart';

class ProductDetailButtons extends ConsumerWidget {
  final ProductEntity product;
  const ProductDetailButtons({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productDetailState = ref.watch(productDetailProvider(product));
    final productDetailNotifier = ref.read(
      productDetailProvider(product).notifier,
    );
    return Column(
      spacing: 10,
      children: [
        if (ResponsiveTheme.isTablet(context)) ...[
          QuantitySelector(
            quantity: productDetailState.quantity,
            onIncrement: () {
              final newQuantity = productDetailState.quantity + 1;
              productDetailNotifier.selectQuantity(newQuantity);
            },
            onDecrement: () {
              final newQuantity = productDetailState.quantity - 1;
              productDetailNotifier.selectQuantity(newQuantity);
            },
          ),
          AddToCartButton(productDetailState: productDetailState),
        ],
        if (!ResponsiveTheme.isTablet(context))
          Row(
            spacing: 10,
            children: [
              Expanded(
                flex: 2,
                child: QuantitySelector(
                  quantity: productDetailState.quantity,
                  onIncrement: () {
                    final newQuantity = productDetailState.quantity + 1;
                    productDetailNotifier.selectQuantity(newQuantity);
                  },
                  onDecrement: () {
                    final newQuantity = productDetailState.quantity - 1;
                    productDetailNotifier.selectQuantity(newQuantity);
                  },
                ),
              ),
              Expanded(
                flex: 5,
                child: AddToCartButton(productDetailState: productDetailState),
              ),
            ],
          ),
        YesFilledButton(
          height: 60,
          icon: FontAwesomeIcons.moneyBill1Wave,
          label: 'Comprar ahora',
          mainAxisAlignment: MainAxisAlignment.center,
          reverse: true,
          filledColor: Theme.of(context).colorScheme.primary,
          enabled:
              productDetailState.quantity > 0 &&
              productDetailState.product.stockAvailability !=
                  StockAvailability.outOfStock,
          onPressed: () {
            productDetailNotifier.buyNow(context);
          },
        ),
      ],
    );
  }
}
