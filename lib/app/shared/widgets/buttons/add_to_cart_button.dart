import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/stock_availability.dart';
import 'package:marcos_malaga_app/app/shared/widgets/buttons/no_filled_button.dart';
import 'package:marcos_malaga_app/features/cart/domain/entities/add_to_cart_result.dart';
import 'package:marcos_malaga_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/states/product_detail_state.dart';

class AddToCartButton extends ConsumerWidget {
  const AddToCartButton({super.key, required this.productDetailState});

  final ProductDetailState productDetailState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartNotifier = ref.read(cartProvider.notifier);
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontSize: 14);
    return NoFilledButton(
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
      onPressed: () async {
        final result = await cartNotifier.addItem(
          productId: productDetailState.product.id,
          designId: productDetailState.selectedDesign.id,
          sizeName: productDetailState.selectedSize.size,
          quantity: productDetailState.quantity,
          maxStock: productDetailState.selectedSize.stock,
        );
        if (!context.mounted) return;

        final message = switch (result) {
          AddToCartResult.added => 'PRODUCTO AÑADIDO AL CARRITO',
          AddToCartResult.cappedToMax =>
            'SE AJUSTÓ AL STOCK MÁXIMO (${productDetailState.selectedSize.stock})',
          AddToCartResult.alreadyAtMax =>
            'YA TIENES EL STOCK MÁXIMO EN TU CARRITO',
        };

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text(
                message,
                style: style?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }
}
