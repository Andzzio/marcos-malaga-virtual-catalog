import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marcos_malaga_app/app/shared/widgets/image/custom_image.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/product_price.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/order/order_item.dart';

class OrderRow extends ConsumerWidget {
  const OrderRow({super.key, required this.orderItem, this.style});
  final OrderItem orderItem;
  final TextStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImage(
            orderItem.imageUrl,
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
                  orderItem.productName,
                  overflow: TextOverflow.ellipsis,
                  style: style?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(() {
                  String units = 'unidad';
                  if (orderItem.quantity != 1) {
                    units = 'unidades';
                  }
                  return '${orderItem.sizeName}, ${orderItem.designName}, ${orderItem.quantity} $units';
                }(), style: style),
                ProductPrice(
                  mainAxisAlignment: MainAxisAlignment.start,
                  basePrice: orderItem.unitPrice,
                  discountPrice: orderItem.discountPrice,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'S/. ${orderItem.totalPrice.toStringAsFixed(2)}',
                style: style,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
