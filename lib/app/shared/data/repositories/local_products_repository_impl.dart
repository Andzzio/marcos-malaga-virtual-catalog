import 'package:marcos_malaga_app/app/shared/data/datasources/local_products_datasource.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/repositories/products_repository.dart';

class LocalProductsRepositoryImpl implements ProductsRepository {
  final LocalProductsDatasource datasource;
  LocalProductsRepositoryImpl({required this.datasource});
  @override
  Future<List<ProductEntity>> getProducts() async {
    final productsModels = await datasource.fetchProducts();
    return productsModels.map((p) => p.toEntity()).toList();
  }

  @override
  Future<ProductEntity?> getProductById(String id) async {
    final productModel = await datasource.fetchProductById(id);
    if (productModel == null) return null;
    return productModel.toEntity();
  }
}
