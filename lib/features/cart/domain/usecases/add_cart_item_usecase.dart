import 'package:marcos_malaga_app/features/cart/domain/entities/add_to_cart_result.dart';
import 'package:marcos_malaga_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:marcos_malaga_app/features/cart/domain/repositories/cart_repository.dart';

class AddCartItemUsecase {
  final CartRepository repository;

  AddCartItemUsecase(this.repository);

  Future<AddToCartResult> call(
    CartItemEntity newItem, {
    required int maxStock,
  }) async {
    if (maxStock <= 0) {
      return AddToCartResult.alreadyAtMax;
    }

    final cart = await repository.getCart();
    final items = List<CartItemEntity>.from(cart.items);
    final existingIndex = items.indexWhere((item) => item.id == newItem.id);

    if (existingIndex >= 0) {
      final existingItem = items[existingIndex];
      if (existingItem.quantity >= maxStock) {
        return AddToCartResult.alreadyAtMax;
      }

      final totalQuantity = existingItem.quantity + newItem.quantity;
      if (totalQuantity > maxStock) {
        final newQuantity = totalQuantity.clamp(1, maxStock);
        items[existingIndex] = existingItem.copyWith(quantity: newQuantity);
        await repository.saveCart(cart.copyWith(items: items));
        return AddToCartResult.cappedToMax;
      }

      items[existingIndex] = existingItem.copyWith(quantity: totalQuantity);
      await repository.saveCart(cart.copyWith(items: items));
      return AddToCartResult.added;
    }

    final newQuantity = newItem.quantity.clamp(1, maxStock);
    items.add(newItem.copyWith(quantity: newQuantity));
    await repository.saveCart(cart.copyWith(items: items));

    return newQuantity < newItem.quantity
        ? AddToCartResult.cappedToMax
        : AddToCartResult.added;
  }
}
