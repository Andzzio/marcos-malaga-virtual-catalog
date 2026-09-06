import 'package:marcos_malaga_app/features/checkout/data/models/customer_info_model.dart';
import 'package:marcos_malaga_app/app/shared/data/models/order/order_item_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/shipping_address_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/billing_address_model.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/customer_info.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/order/order_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/order/order_status.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/shipping_address.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/billing_address.dart';

import 'package:equatable/equatable.dart';

class OrderModel extends Equatable {
  final String id;
  final String orderCode;
  final CustomerInfo customer;
  final ShippingAddress? shipping;
  final BillingAddress? billing;
  final List<OrderItemModel> items;
  final double subtotal;
  final double shippingCost;
  final double total;
  final String paymentMethodId;
  final String? shippingMethodId;
  final OrderStatus status;
  final DeliveryType deliveryType;
  final DateTime createdAt;
  final String? notes;

  const OrderModel({
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

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String? ?? '',
      orderCode: json['orderCode'] as String? ?? '',
      customer: CustomerInfoModel.fromJson(
        json['customer'] as Map<String, dynamic>,
      ),
      shipping: json['shipping'] != null
          ? ShippingAddressModel.fromJson(
              json['shipping'] as Map<String, dynamic>,
            )
          : null,
      billing: json['billing'] != null
          ? BillingAddressModel.fromJson(
              json['billing'] as Map<String, dynamic>,
            )
          : null,
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      shippingCost: (json['shippingCost'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      paymentMethodId: json['paymentMethodId'] as String? ?? '',
      shippingMethodId: json['shippingMethodId'] as String?,
      status: OrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      deliveryType: DeliveryType.values.firstWhere(
        (e) => e.name == json['deliveryType'],
        orElse: () => DeliveryType.shipping,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      notes: json['notes'] as String?,
    );
  }

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      orderCode: entity.orderCode,
      customer: entity.customer is CustomerInfoModel
          ? entity.customer
          : CustomerInfoModel.fromEntity(entity.customer),
      shipping: entity.shipping == null
          ? null
          : (entity.shipping is ShippingAddressModel
                ? entity.shipping as ShippingAddressModel
                : ShippingAddressModel.fromEntity(entity.shipping!)),
      billing: entity.billing == null
          ? null
          : (entity.billing is BillingAddressModel
                ? entity.billing as BillingAddressModel
                : BillingAddressModel.fromEntity(entity.billing!)),
      items: entity.items.map((e) => OrderItemModel.fromEntity(e)).toList(),
      subtotal: entity.subtotal,
      shippingCost: entity.shippingCost,
      total: entity.total,
      paymentMethodId: entity.paymentMethodId,
      shippingMethodId: entity.shippingMethodId,
      status: entity.status,
      deliveryType: entity.deliveryType,
      createdAt: entity.createdAt,
      notes: entity.notes,
    );
  }

  Map<String, dynamic> toJson() {
    final customerModel = customer is CustomerInfoModel
        ? customer as CustomerInfoModel
        : CustomerInfoModel.fromEntity(customer);
    final shippingModel = shipping == null
        ? null
        : (shipping is ShippingAddressModel
              ? shipping as ShippingAddressModel
              : ShippingAddressModel.fromEntity(shipping!));
    final billingModel = billing == null
        ? null
        : (billing is BillingAddressModel
              ? billing as BillingAddressModel
              : BillingAddressModel.fromEntity(billing!));

    return {
      'id': id,
      'orderCode': orderCode,
      'customer': customerModel.toJson(),
      if (shippingModel != null) 'shipping': shippingModel.toJson(),
      if (billingModel != null) 'billing': billingModel.toJson(),
      'items': items.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'shippingCost': shippingCost,
      'total': total,
      'paymentMethodId': paymentMethodId,
      if (shippingMethodId != null) 'shippingMethodId': shippingMethodId,
      'status': status.name,
      'deliveryType': deliveryType.name,
      'createdAt': createdAt.toIso8601String(),
      if (notes != null) 'notes': notes,
    };
  }

  OrderModel copyWith({
    String? id,
    String? orderCode,
    CustomerInfo? customer,
    ShippingAddress? shipping,
    BillingAddress? billing,
    List<OrderItemModel>? items,
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
    return OrderModel(
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

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      orderCode: orderCode,
      customer: customer is CustomerInfoModel
          ? (customer as CustomerInfoModel).toEntity()
          : customer,
      shipping: shipping == null
          ? null
          : (shipping is ShippingAddressModel
                ? (shipping as ShippingAddressModel).toEntity()
                : shipping),
      billing: billing == null
          ? null
          : (billing is BillingAddressModel
                ? (billing as BillingAddressModel).toEntity()
                : billing),
      items: items.map((e) => e.toEntity()).toList(),
      subtotal: subtotal,
      shippingCost: shippingCost,
      total: total,
      paymentMethodId: paymentMethodId,
      shippingMethodId: shippingMethodId,
      status: status,
      deliveryType: deliveryType,
      createdAt: createdAt,
      notes: notes,
    );
  }
}
