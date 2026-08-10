import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:marcos_malaga_app/app/config/theme/responsive_theme.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/stock_availability.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/providers/product_detail_provider.dart';
import 'package:marcos_malaga_app/app/shared/widgets/buttons/no_filled_button.dart';
import 'package:marcos_malaga_app/app/shared/widgets/buttons/yes_filled_button.dart';

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
        Row(
          spacing: 10,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.secondary.withValues(alpha: 0.5),
                  ),
                  borderRadius: BorderRadiusGeometry.circular(8),
                ),
                child: Padding(
                  padding: ResponsiveTheme.isMobile(context)
                      ? const EdgeInsetsGeometry.symmetric(
                          horizontal: 0,
                          vertical: 10,
                        )
                      : const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                  child: Row(
                    children: [
                      IconButton(
                        iconSize: ResponsiveTheme.isMobile(context) ? 11 : 14,
                        color: Theme.of(context).colorScheme.secondary,
                        icon: FaIcon(FontAwesomeIcons.minus),
                        onPressed: () {
                          final newQuantity = productDetailState.quantity - 1;
                          productDetailNotifier.selectQuantity(newQuantity);
                        },
                      ),
                      Expanded(
                        child: Text(
                          productDetailState.quantity.toString(),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                fontSize: ResponsiveTheme.isMobile(context)
                                    ? 11
                                    : 14,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                      ),
                      IconButton(
                        iconSize: ResponsiveTheme.isMobile(context) ? 11 : 14,
                        color: Theme.of(context).colorScheme.secondary,
                        icon: FaIcon(FontAwesomeIcons.plus),
                        onPressed: () {
                          final newQuantity = productDetailState.quantity + 1;
                          productDetailNotifier.selectQuantity(newQuantity);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: NoFilledButton(
                icon: FontAwesomeIcons.cartPlus,
                height: 60,
                label: 'Agregar al carrito',
                mainAxisAlignment: MainAxisAlignment.center,
                reverse: true,
                borderColor: Theme.of(context).colorScheme.secondary,
                textColor: Theme.of(context).colorScheme.secondary,
                iconColor: Theme.of(context).colorScheme.secondary,
                enabled:
                    productDetailState.quantity > 0 &&
                    productDetailState.product.stockAvailability !=
                        StockAvailability.outOfStock,
                onPressed: () {},
              ),
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
            context.go('/checkout');
          },
        ),
      ],
    );
  }
}
