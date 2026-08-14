import '../../domain/entities/cart_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/local_cart_datasource.dart';
import '../models/cart_model.dart';

class LocalCartRepositoryImpl implements CartRepository {
  final LocalCartDatasource datasource;

  LocalCartRepositoryImpl(this.datasource);

  @override
  Future<CartEntity> getCart() async {
    return await datasource.getCart();
  }

  @override
  Future<void> saveCart(CartEntity cart) async {
    final cartModel = CartModel.fromEntity(cart);
    await datasource.saveCart(cartModel);
  }
}
