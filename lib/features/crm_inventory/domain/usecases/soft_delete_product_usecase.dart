import 'package:marcos_malaga_app/app/shared/domain/repositories/products_repository.dart';

class SoftDeleteProductUsecase {
  final ProductsRepository repo;
  const SoftDeleteProductUsecase({required this.repo});

  Future<void> call(String productId) => repo.softDeleteProduct(productId);
}
