import 'package:marcos_malaga_app/app/shared/domain/repositories/products_repository.dart';

class SoftDeleteProductsUsecase {
  final ProductsRepository repo;
  const SoftDeleteProductsUsecase({required this.repo});

  Future<void> call(List<String> ids) async {
    for (final id in ids) {
      await repo.softDeleteProduct(id);
    }
  }
}
