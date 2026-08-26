import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:marcos_malaga_app/app/shared/widgets/buttons/yes_filled_button.dart';
import 'package:marcos_malaga_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:marcos_malaga_app/features/cart/presentation/states/cart_state.dart';
import 'package:marcos_malaga_app/features/cart/presentation/widgets/cart_row.dart';

class CartView extends ConsumerWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartProvider);
    final double fontSize = 14;
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontSize: fontSize);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'CARRITO',
                style: style?.copyWith(fontWeight: FontWeight.bold),
              ),
              Spacer(),
              IconButton(
                icon: FaIcon(FontAwesomeIcons.x),
                iconSize: fontSize,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          cartAsync.when(
            data: (cartState) {
              return cartState.isEmpty
                  ? _buildEmptyUI(context, style: style)
                  : _buildUI(context, state: cartState, style: style, ref: ref);
            },
            loading: () =>
                Expanded(child: Center(child: CircularProgressIndicator())),
            error: (error, stackTrace) => _buildEmptyUI(context, style: style),
          ),
        ],
      ),
    );
  }

  Widget _buildUI(
    BuildContext context, {
    required CartState state,
    required WidgetRef ref,
    TextStyle? style,
  }) {
    final cartNotifier = ref.read(cartProvider.notifier);
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: state.items.length,
              separatorBuilder: (context, index) => Gap(20),
              itemBuilder: (context, index) {
                final item = state.items[index];
                return CartRow(cartItem: item, style: style);
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(),
            child: Column(
              spacing: 10,
              children: [
                Gap(10),
                Row(
                  children: [
                    Text(
                      'Total estimado',
                      style: style?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(
                      'S/. ${state.totalAmount.toStringAsFixed(2)} PEN',
                      style: style?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                Text(
                  'Aranceles e impuestos incluidos. Los gastos de envío se calculan en la página de pago.',
                  style: style?.copyWith(fontSize: 12),
                ),
                Gap(20),
                YesFilledButton(
                  icon: FontAwesomeIcons.cashApp,
                  reverse: true,
                  label: 'Pagar',
                  height: 50,
                  mainAxisAlignment: MainAxisAlignment.center,
                  onPressed: () {
                    cartNotifier.proceedToCheckout(context);
                    Navigator.of(context).pop();
                  },
                ),
                Gap(20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyUI(BuildContext context, {TextStyle? style}) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'CARRITO VACÍO',
              style: style?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Gap(20),
            YesFilledButton(
              icon: FontAwesomeIcons.bagShopping,
              reverse: true,
              label: 'SEGUIR COMPRANDO',
              mainAxisAlignment: MainAxisAlignment.center,
              onPressed: () {
                context.go('/search/catalog');
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
