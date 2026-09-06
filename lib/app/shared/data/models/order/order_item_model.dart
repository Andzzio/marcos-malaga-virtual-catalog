import 'package:marcos_malaga_app/app/shared/domain/entities/order/order_item.dart';

import 'package:equatable/equatable.dart';

class OrderItemModel extends Equatable {
  final String productId;
  final String designId;
  final String sizeName;
  final int quantity;
  final String productName;
  final String designName;
  final String imageUrl;
  final double unitPrice;
  final double? discountPrice;

  const OrderItemModel({
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

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      productId: json['productId'] as String? ?? '',
      designId: json['designId'] as String? ?? '',
      sizeName: json['sizeName'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 1,
      productName: json['productName'] as String? ?? '',
      designName: json['designName'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0.0,
      discountPrice: (json['discountPrice'] as num?)?.toDouble(),
    );
  }

  factory OrderItemModel.fromEntity(OrderItem entity) {
    return OrderItemModel(
      productId: entity.productId,
      designId: entity.designId,
      sizeName: entity.sizeName,
      quantity: entity.quantity,
      productName: entity.productName,
      designName: entity.designName,
      imageUrl: entity.imageUrl,
      unitPrice: entity.unitPrice,
      discountPrice: entity.discountPrice,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'designId': designId,
      'sizeName': sizeName,
      'quantity': quantity,
      'productName': productName,
      'designName': designName,
      'imageUrl': imageUrl,
      'unitPrice': unitPrice,
      'discountPrice': discountPrice,
    };
  }

  OrderItemModel copyWith({
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
    return OrderItemModel(
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

  OrderItem toEntity() {
    return OrderItem(
      productId: productId,
      designId: designId,
      sizeName: sizeName,
      quantity: quantity,
      productName: productName,
      designName: designName,
      imageUrl: imageUrl,
      unitPrice: unitPrice,
      discountPrice: discountPrice,
    );
  }
}
