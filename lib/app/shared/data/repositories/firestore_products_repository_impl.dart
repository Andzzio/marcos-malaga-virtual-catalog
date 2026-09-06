import 'package:marcos_malaga_app/app/shared/data/datasources/firestore_products_datasource.dart';
import 'package:marcos_malaga_app/app/shared/data/models/firestore/firestore_product_model.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_design_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_size_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/repositories/products_repository.dart';

class FirestoreProductsRepositoryImpl implements ProductsRepository {
  final FirestoreProductsDatasource datasource;

  FirestoreProductsRepositoryImpl(this.datasource);

  @override
  Future<List<ProductEntity>> getProducts() async {
    final models = await datasource.fetchProducts();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<ProductEntity?> getProductById(String id) async {
    final model = await datasource.fetchProductById(id);
    return model?.toEntity();
  }

  @override
  Future<ProductDesignEntity?> getDesignById(String productId, String designId) async {
    final model = await datasource.fetchDesignById(productId, designId);
    return model?.toEntity();
  }

  @override
  Future<ProductSizeEntity?> getSizeByName(
    String productId,
    String designId,
    String sizeName,
  ) async {
    final model = await datasource.fetchSizeByName(productId, designId, sizeName);
    return model?.toEntity();
  }

  @override
  Future<void> createProduct(ProductEntity product) async {
    final model = FirestoreProductModel.fromEntity(product);
    await datasource.createProduct(model);
  }

  @override
  Future<void> updateProduct(ProductEntity product) async {
    final model = FirestoreProductModel.fromEntity(product);
    await datasource.updateProduct(model);
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
