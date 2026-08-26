import 'package:equatable/equatable.dart';

class CartDisplayItem extends Equatable {
  final String cartItemId;
  final String productId;
  final String designId;
  final String productName;
  final String designName;
  final String sizeName;
  final String thumbnailUrl;
  final double basePrice;
  final double? discountPrice;
  final double unitPrice;
  final int quantity;
  final int stock;

  const CartDisplayItem({
    required this.cartItemId,
    required this.productId,
    required this.designId,
    required this.productName,
    required this.designName,
    required this.sizeName,
    required this.thumbnailUrl,
    required this.basePrice,
    this.discountPrice,
    required this.unitPrice,
    required this.quantity,
    required this.stock,
  });

  bool get hasDiscount => discountPrice != null && discountPrice! < basePrice;
  double get totalPrice => unitPrice * quantity;
  double get totalOriginalPrice => basePrice * quantity;
  double get totalSavings =>
      hasDiscount ? (basePrice - unitPrice) * quantity : 0.0;

  @override
  List<Object?> get props => [
    cartItemId,
    productId,
    designId,
    productName,
    designName,
    sizeName,
    thumbnailUrl,
    basePrice,
    discountPrice,
    unitPrice,
    quantity,
    stock,
  ];
}
