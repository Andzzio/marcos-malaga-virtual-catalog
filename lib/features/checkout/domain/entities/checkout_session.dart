import 'package:equatable/equatable.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/order/order_item.dart';

class CheckoutSession extends Equatable {
  final String id;
  final List<OrderItem> items;
  final bool clearCartOnSuccess;
  final DateTime createdAt;

  const CheckoutSession({
    required this.id,
    required this.items,
    required this.clearCartOnSuccess,
    required this.createdAt,
  });

  CheckoutSession copyWith({
    String? id,
    List<OrderItem>? items,
    bool? clearCartOnSuccess,
    DateTime? createdAt,
  }) {
    return CheckoutSession(
      id: id ?? this.id,
      items: items ?? this.items,
      clearCartOnSuccess: clearCartOnSuccess ?? this.clearCartOnSuccess,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, items, clearCartOnSuccess, createdAt];
}
