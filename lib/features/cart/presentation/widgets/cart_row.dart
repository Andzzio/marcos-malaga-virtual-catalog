import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/app/config/theme/responsive_theme.dart';
import 'package:marcos_malaga_app/app/shared/widgets/image/custom_image.dart';
import 'package:marcos_malaga_app/app/shared/widgets/inputs/quantity_selector.dart';
import 'package:marcos_malaga_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:marcos_malaga_app/features/cart/presentation/states/cart_display_item.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/product_price.dart';

class CartRow extends ConsumerWidget {
  const CartRow({super.key, required this.cartItem, this.style});
  final CartDisplayItem cartItem;
  final TextStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImage(
            cartItem.thumbnailUrl,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.productName,
                  overflow: TextOverflow.ellipsis,
                  style: style?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${cartItem.sizeName}, ${cartItem.designName}',
                  style: style,
                ),
                ProductPrice(
                  mainAxisAlignment: MainAxisAlignment.start,
                  basePrice: cartItem.basePrice,
                  discountPrice: cartItem.discountPrice,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: ResponsiveTheme.isMobile(context) ? 100 : 150,
                      child: QuantitySelector(
                        quantity: cartItem.quantity,
                        onDecrement: () {
                          final newQuantity = cartItem.quantity - 1;
                          if (newQuantity < 1) return;
                          ref
                              .read(cartProvider.notifier)
                              .updateQuantity(cartItem.cartItemId, newQuantity);
                        },
                        onIncrement: () {
                          final newQuantity = cartItem.quantity + 1;
                          if (newQuantity > cartItem.stock) return;
                          ref
                              .read(cartProvider.notifier)
                              .updateQuantity(cartItem.cartItemId, newQuantity);
                        },
                      ),
                    ),
                    Gap(10),
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.trashCan),
                      iconSize: 14,
                      onPressed: () {
                        ref
                            .read(cartProvider.notifier)
                            .removeItem(cartItem.cartItemId);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'S/. ${cartItem.totalPrice.toStringAsFixed(2)}',
                style: style,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
