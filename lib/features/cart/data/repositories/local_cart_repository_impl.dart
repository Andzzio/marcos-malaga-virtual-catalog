import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/local_cart_datasource.dart';
import '../models/cart_item_model.dart';
import '../models/cart_model.dart';

class LocalCartRepositoryImpl implements CartRepository {
  final LocalCartDatasource datasource;

  LocalCartRepositoryImpl(this.datasource);

  @override
  Future<CartEntity> getCart() async {
    final cartModel = await datasource.getCart();
    final items = cartModel.items
        .map(
          (m) => CartItemEntity(
            id: m.id,
            productId: m.productId,
            designId: m.designId,
            sizeName: m.sizeName,
            quantity: m.quantity,
          ),
        )
        .toList();
    return CartEntity(items: items);
  }

  @override
  Future<void> saveCart(CartEntity cart) async {
    final itemsModel = cart.items
        .map(
          (e) => CartItemModel(
            id: e.id,
            productId: e.productId,
            designId: e.designId,
            sizeName: e.sizeName,
            quantity: e.quantity,
          ),
        )
        .toList();
    final cartModel = CartModel(items: itemsModel);
    await datasource.saveCart(cartModel);
  }
}
