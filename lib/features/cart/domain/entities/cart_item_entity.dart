import 'package:equatable/equatable.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_design_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_size_entity.dart';

class CartItemEntity extends Equatable {
  final String id;
  final ProductEntity product;
  final ProductDesignEntity selectedDesign;
  final ProductSizeEntity selectedSize;
  final int quantity;

  const CartItemEntity({
    required this.id,
    required this.product,
    required this.selectedDesign,
    required this.selectedSize,
    required this.quantity,
  });

  double get totalPrice {
    final price = product.discountPrice ?? product.basePrice;
    return price * quantity;
  }

  CartItemEntity copyWith({
    String? id,
    ProductEntity? product,
    ProductDesignEntity? selectedDesign,
    ProductSizeEntity? selectedSize,
    int? quantity,
  }) {
    return CartItemEntity(
      id: id ?? this.id,
      product: product ?? this.product,
      selectedDesign: selectedDesign ?? this.selectedDesign,
      selectedSize: selectedSize ?? this.selectedSize,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [id, product, selectedDesign, selectedSize, quantity];
}
