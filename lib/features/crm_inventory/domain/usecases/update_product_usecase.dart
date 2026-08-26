import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/repositories/products_repository.dart';

class UpdateProductUsecase {
  final ProductsRepository repo;
  const UpdateProductUsecase({required this.repo});

  Future<void> call(ProductEntity product) => repo.updateProduct(product);
}
