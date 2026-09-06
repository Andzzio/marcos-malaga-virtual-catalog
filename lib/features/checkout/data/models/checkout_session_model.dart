import 'package:marcos_malaga_app/app/shared/data/models/order/order_item_model.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/checkout_session.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/order/order_item.dart';

class CheckoutSessionModel extends CheckoutSession {
  const CheckoutSessionModel({
    required super.id,
    required super.items,
    required super.clearCartOnSuccess,
    required super.createdAt,
  });

  factory CheckoutSessionModel.fromJson(Map<String, dynamic> json) {
    return CheckoutSessionModel(
      id: json['id'] as String? ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map(
            (e) =>
                OrderItemModel.fromJson(e as Map<String, dynamic>).toEntity(),
          )
          .toList(),
      clearCartOnSuccess: json['clearCartOnSuccess'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  factory CheckoutSessionModel.fromEntity(CheckoutSession entity) {
    return CheckoutSessionModel(
      id: entity.id,
      items: entity.items,
      clearCartOnSuccess: entity.clearCartOnSuccess,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((e) => OrderItemModel.fromEntity(e).toJson()).toList(),
      'clearCartOnSuccess': clearCartOnSuccess,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  CheckoutSessionModel copyWith({
    String? id,
    List<OrderItem>? items,
    bool? clearCartOnSuccess,
    DateTime? createdAt,
  }) {
    return CheckoutSessionModel(
      id: id ?? this.id,
      items: items ?? this.items,
      clearCartOnSuccess: clearCartOnSuccess ?? this.clearCartOnSuccess,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  CheckoutSession toEntity() {
    return CheckoutSession(
      id: id,
      items: items,
      clearCartOnSuccess: clearCartOnSuccess,
      createdAt: createdAt,
    );
  }
}
