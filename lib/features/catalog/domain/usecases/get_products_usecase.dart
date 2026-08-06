import 'package:marcos_malaga_app/features/catalog/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/features/catalog/domain/repositories/products_repository.dart';

class GetProductsUsecase {
  final ProductsRepository repo;
  GetProductsUsecase({required this.repo});
  Future<List<ProductEntity>> call() async {
    return await repo.getProducts();
  }
}
