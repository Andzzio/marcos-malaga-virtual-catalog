import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';

abstract class ProductsRepository {
  Future<List<ProductEntity>> getProducts();
  Future<ProductEntity?> getProductById(String id);
}
