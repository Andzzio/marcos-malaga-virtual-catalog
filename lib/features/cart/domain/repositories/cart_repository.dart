import '../entities/cart_entity.dart';

abstract class CartRepository {
  Future<CartEntity> getCart();
  Future<void> saveCart(CartEntity cart);
}
