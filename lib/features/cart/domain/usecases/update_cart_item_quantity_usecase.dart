import '../repositories/cart_repository.dart';

class UpdateCartItemQuantityUsecase {
  final CartRepository repository;

  UpdateCartItemQuantityUsecase(this.repository);

  Future<void> call(String itemId, int newQuantity) async {
    final cart = await repository.getCart();
    final items = cart.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(quantity: newQuantity);
      }
      return item;
    }).toList();

    await repository.saveCart(cart.copyWith(items: items));
  }
}
