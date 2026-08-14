import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';

class AddCartItemUsecase {
  final CartRepository repository;

  AddCartItemUsecase(this.repository);

  Future<void> call(CartItemEntity newItem) async {
    final cart = await repository.getCart();
    final items = List<CartItemEntity>.from(cart.items);

    final existingIndex = items.indexWhere((item) =>
        item.product.id == newItem.product.id &&
        item.selectedDesign.id == newItem.selectedDesign.id &&
        item.selectedSize.size == newItem.selectedSize.size);

    if (existingIndex >= 0) {
      final existingItem = items[existingIndex];
      items[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + newItem.quantity,
      );
    } else {
      items.add(newItem);
    }

    await repository.saveCart(cart.copyWith(items: items));
  }
}
