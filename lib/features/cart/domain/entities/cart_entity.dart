import 'package:equatable/equatable.dart';
import 'cart_item_entity.dart';

class CartEntity extends Equatable {
  final List<CartItemEntity> items;

  const CartEntity({this.items = const []});

  double get totalAmount {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get totalItemsCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  CartEntity copyWith({List<CartItemEntity>? items}) {
    return CartEntity(
      items: items ?? this.items,
    );
  }

  @override
  List<Object?> get props => [items];
}
