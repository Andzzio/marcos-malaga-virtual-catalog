import 'package:marcos_malaga_app/app/shared/data/datasources/local_products_datasource.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_design_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_size_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/repositories/products_repository.dart';
import 'package:marcos_malaga_app/features/catalog/data/models/product_model.dart';

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

  @override
  Future<ProductDesignEntity?> getDesignById(
    String productId,
    String designId,
  ) async {
    final designModel = await datasource.fetchDesignById(productId, designId);
    if (designModel == null) return null;
    return designModel.toEntity();
  }

  @override
  Future<ProductSizeEntity?> getSizeByName(
    String productId,
    String designId,
    String sizeName,
  ) async {
    final sizeModel = await datasource.fetchSizeByName(
      productId,
      designId,
      sizeName,
    );
    if (sizeModel == null) return null;
    return sizeModel.toEntity();
  }

  @override
  Future<void> createProduct(ProductEntity product) async {
    await datasource.createProduct(ProductModel.fromEntity(product));
  }

  @override
  Future<void> updateProduct(ProductEntity product) async {
    await datasource.updateProduct(ProductModel.fromEntity(product));
  }

  @override
  Future<void> softDeleteProduct(String productId) async {
    await datasource.softDeleteProduct(productId);
  }

  @override
  Future<void> restoreProduct(String productId) async {
    await datasource.restoreProduct(productId);
  }

  @override
  Future<void> updateStock({
    required String productId,
    required String designId,
    required String sizeName,
    required int newStock,
  }) async {
    await datasource.updateStock(
      productId: productId,
      designId: designId,
      sizeName: sizeName,
      newStock: newStock,
    );
  }
}
