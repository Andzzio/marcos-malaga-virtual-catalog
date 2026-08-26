import 'package:equatable/equatable.dart';

import 'customer_info.dart';
import 'order_item.dart';
import 'order_status.dart';
import 'shipping_address.dart';
import 'billing_address.dart';

enum DeliveryType { shipping, pickup }

class OrderEntity extends Equatable {
  final String id;
  final String orderCode;
  final CustomerInfo customer;
  final ShippingAddress? shipping;
  final BillingAddress? billing;
  final List<OrderItem> items;
  final double subtotal;
  final double shippingCost;
  final double total;
  final String paymentMethodId;
  final String? shippingMethodId;
  final OrderStatus status;
  final DeliveryType deliveryType;
  final DateTime createdAt;
  final String? notes;

  const OrderEntity({
    required this.id,
    required this.orderCode,
    required this.customer,
    this.shipping,
    this.billing,
    required this.items,
    required this.subtotal,
    required this.shippingCost,
    required this.total,
    required this.paymentMethodId,
    this.shippingMethodId,
    required this.status,
    required this.deliveryType,
    required this.createdAt,
    this.notes,
  });

  OrderEntity copyWith({
    String? id,
    String? orderCode,
    CustomerInfo? customer,
    ShippingAddress? shipping,
    BillingAddress? billing,
    List<OrderItem>? items,
    double? subtotal,
    double? shippingCost,
    double? total,
    String? paymentMethodId,
    String? shippingMethodId,
    OrderStatus? status,
    DeliveryType? deliveryType,
    DateTime? createdAt,
    String? notes,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      orderCode: orderCode ?? this.orderCode,
      customer: customer ?? this.customer,
      shipping: shipping ?? this.shipping,
      billing: billing ?? this.billing,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      shippingCost: shippingCost ?? this.shippingCost,
      total: total ?? this.total,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      shippingMethodId: shippingMethodId ?? this.shippingMethodId,
      status: status ?? this.status,
      deliveryType: deliveryType ?? this.deliveryType,
      createdAt: createdAt ?? this.createdAt,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        orderCode,
        customer,
        shipping,
        billing,
        items,
        subtotal,
        shippingCost,
        total,
        paymentMethodId,
        shippingMethodId,
        status,
        deliveryType,
        createdAt,
        notes,
      ];
}
