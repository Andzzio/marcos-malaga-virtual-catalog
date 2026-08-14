import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class GetCartUsecase {
  final CartRepository repository;

  GetCartUsecase(this.repository);

  Future<CartEntity> call() {
    return repository.getCart();
  }
}
