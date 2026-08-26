import 'package:marcos_malaga_app/features/checkout/domain/entities/order_item.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.productId,
    required super.designId,
    required super.sizeName,
    required super.quantity,
    required super.productName,
    required super.designName,
    required super.imageUrl,
    required super.unitPrice,
    super.discountPrice,
  });

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

  @override
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
