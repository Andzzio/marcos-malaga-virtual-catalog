import 'package:marcos_malaga_app/app/shared/domain/repositories/products_repository.dart';

class RestoreProductsUsecase {
  final ProductsRepository repo;
  const RestoreProductsUsecase({required this.repo});

  Future<void> call(List<String> ids) async {
    for (final id in ids) {
      await repo.restoreProduct(id);
    }
  }
}
