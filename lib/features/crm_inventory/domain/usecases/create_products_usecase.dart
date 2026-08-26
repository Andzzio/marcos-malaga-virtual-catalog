import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/repositories/products_repository.dart';

class CreateProductsUsecase {
  final ProductsRepository repo;
  const CreateProductsUsecase({required this.repo});

  Future<void> call(List<ProductEntity> products) async {
    for (final product in products) {
      await repo.createProduct(product);
    }
  }
}
