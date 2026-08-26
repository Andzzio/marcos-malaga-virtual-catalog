class CartItemModel {
  final String id;
  final String productId;
  final String designId;
  final String sizeName;
  final int quantity;

  const CartItemModel({
    required this.id,
    required this.productId,
    required this.designId,
    required this.sizeName,
    required this.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      productId: json['productId'] as String,
      designId: json['designId'] as String,
      sizeName: json['sizeName'] as String,
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'designId': designId,
      'sizeName': sizeName,
      'quantity': quantity,
    };
  }
}
