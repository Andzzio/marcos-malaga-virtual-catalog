import '../repositories/cart_repository.dart';

class RemoveCartItemUsecase {
  final CartRepository repository;

  RemoveCartItemUsecase(this.repository);

  Future<void> call(String itemId) async {
    final cart = await repository.getCart();
    final items = cart.items.where((item) => item.id != itemId).toList();
    await repository.saveCart(cart.copyWith(items: items));
  }
}
