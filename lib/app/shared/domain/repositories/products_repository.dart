import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_design_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_size_entity.dart';

abstract class ProductsRepository {
  Future<List<ProductEntity>> getProducts();
  Future<ProductEntity?> getProductById(String id);
  Future<ProductDesignEntity?> getDesignById(String productId, String designId);
  Future<ProductSizeEntity?> getSizeByName(
    String productId,
    String designId,
    String sizeName,
  );

  // --- Escritura ---
  Future<void> createProduct(ProductEntity product);
  Future<void> updateProduct(ProductEntity product);
  Future<void> softDeleteProduct(String productId);
  Future<void> restoreProduct(String productId);
  Future<void> updateStock({
    required String productId,
    required String designId,
    required String sizeName,
    required int newStock,
  });
}
