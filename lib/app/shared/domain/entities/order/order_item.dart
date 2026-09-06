import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final String productId;
  final String designId;
  final String sizeName;
  final int quantity;
  final String productName;
  final String designName;
  final String imageUrl;
  final double unitPrice;
  final double? discountPrice;

  const OrderItem({
    required this.productId,
    required this.designId,
    required this.sizeName,
    required this.quantity,
    required this.productName,
    required this.designName,
    required this.imageUrl,
    required this.unitPrice,
    this.discountPrice,
  });
  double get totalPrice => unitPrice * quantity;

  OrderItem copyWith({
    String? productId,
    String? designId,
    String? sizeName,
    int? quantity,
    String? productName,
    String? designName,
    String? imageUrl,
    double? unitPrice,
    double? discountPrice,
  }) {
    return OrderItem(
      productId: productId ?? this.productId,
      designId: designId ?? this.designId,
      sizeName: sizeName ?? this.sizeName,
      quantity: quantity ?? this.quantity,
      productName: productName ?? this.productName,
      designName: designName ?? this.designName,
      imageUrl: imageUrl ?? this.imageUrl,
      unitPrice: unitPrice ?? this.unitPrice,
      discountPrice: discountPrice ?? this.discountPrice,
    );
  }

  @override
  List<Object?> get props => [
    productId,
    designId,
    sizeName,
    quantity,
    productName,
    designName,
    imageUrl,
    unitPrice,
    discountPrice,
  ];
}
