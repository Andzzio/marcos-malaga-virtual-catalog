import 'cart_item_model.dart';

class CartModel {
  final List<CartItemModel> items;

  const CartModel({this.items = const []});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>? ?? [];
    final items = itemsList
        .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
        .toList();
    return CartModel(items: items);
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
