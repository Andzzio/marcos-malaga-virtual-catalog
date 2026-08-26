import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String id; // Composite key: "${productId}_${designId}_${sizeName}"
  final String productId;
  final String designId;
  final String sizeName;
  final int quantity;

  const CartItemEntity({
    required this.id,
    required this.productId,
    required this.designId,
    required this.sizeName,
    required this.quantity,
  });

  CartItemEntity copyWith({
    String? id,
    String? productId,
    String? designId,
    String? sizeName,
    int? quantity,
  }) {
    return CartItemEntity(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      designId: designId ?? this.designId,
      sizeName: sizeName ?? this.sizeName,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [id, productId, designId, sizeName, quantity];
}
