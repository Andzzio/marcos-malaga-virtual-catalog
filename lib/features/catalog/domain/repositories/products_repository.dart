import 'package:marcos_malaga_app/features/catalog/domain/entities/product_entity.dart';

abstract class ProductsRepository {
  Future<List<ProductEntity>> getProducts();
}
