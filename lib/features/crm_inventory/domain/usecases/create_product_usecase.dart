import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/repositories/products_repository.dart';

class CreateProductUsecase {
  final ProductsRepository repo;
  const CreateProductUsecase({required this.repo});

  Future<void> call(ProductEntity product) => repo.createProduct(product);
}
