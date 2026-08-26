import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/checkout_session.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/providers/checkout_provider.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/widgets/summary/order_row.dart';

class DesktopCheckoutOrderSummary extends ConsumerWidget {
  const DesktopCheckoutOrderSummary({super.key, required this.session});
  final CheckoutSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(checkoutProvider(session));
    final sessionState = state.session;
    final style = Theme.of(
      context,
    ).textTheme.labelMedium?.copyWith(fontSize: 11);
    final titleStyle = style?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );
    if (sessionState == null) return const SizedBox.shrink();
    final total = sessionState.items.fold<double>(
      0,
      (sum, item) =>
          sum + ((item.discountPrice ?? item.unitPrice) * item.quantity),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Resumen del Pedido', style: titleStyle),
        const Gap(20),
        ...sessionState.items
            .map((order) => OrderRow(orderItem: order, style: style))
            .expand((row) => [row, Gap(25)])
            .toList()
          ..removeLast(),
        const Gap(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total', style: titleStyle),
            Text('S/ ${total.toStringAsFixed(2)} PEN', style: titleStyle),
          ],
        ),
      ],
    );
  }
}
