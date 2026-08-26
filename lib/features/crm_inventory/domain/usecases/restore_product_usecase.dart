import 'package:marcos_malaga_app/app/shared/domain/repositories/products_repository.dart';

class RestoreProductUsecase {
  final ProductsRepository repo;
  const RestoreProductUsecase({required this.repo});

  Future<void> call(String productId) => repo.restoreProduct(productId);
}
