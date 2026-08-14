import 'package:marcos_malaga_app/features/catalog/data/models/product_model.dart';
import 'package:marcos_malaga_app/features/catalog/data/models/product_design_model.dart';
import 'package:marcos_malaga_app/features/catalog/data/models/product_size_model.dart';

import '../../domain/entities/cart_item_entity.dart';

class CartItemModel extends CartItemEntity {
  const CartItemModel({
    required super.id,
    required super.product,
    required super.selectedDesign,
    required super.selectedSize,
    required super.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>).toEntity(),
      selectedDesign: ProductDesignModel.fromJson(json['selectedDesign'] as Map<String, dynamic>).toEntity(),
      selectedSize: ProductSizeModel.fromJson(json['selectedSize'] as Map<String, dynamic>).toEntity(),
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': ProductModel.fromEntity(product).toJson(),
      'selectedDesign': ProductDesignModel.fromEntity(selectedDesign).toJson(),
      'selectedSize': ProductSizeModel.fromEntity(selectedSize).toJson(),
      'quantity': quantity,
    };
  }

  factory CartItemModel.fromEntity(CartItemEntity entity) {
    return CartItemModel(
      id: entity.id,
      product: entity.product,
      selectedDesign: entity.selectedDesign,
      selectedSize: entity.selectedSize,
      quantity: entity.quantity,
    );
  }
}
