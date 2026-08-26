import 'package:equatable/equatable.dart';
import 'cart_display_item.dart';

class CartState extends Equatable {
  final List<CartDisplayItem> items;

  const CartState({this.items = const []});

  double get totalAmount =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get totalOriginalAmount =>
      items.fold(0.0, (sum, item) => sum + item.totalOriginalPrice);

  double get totalSavings =>
      items.fold(0.0, (sum, item) => sum + item.totalSavings);

  bool get hasSavings => totalSavings > 0;

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;

  CartState copyWith({List<CartDisplayItem>? items}) {
    return CartState(items: items ?? this.items);
  }

  @override
  List<Object?> get props => [items];
}
