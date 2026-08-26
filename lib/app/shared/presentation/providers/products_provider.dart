import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/providers/core/core_providers.dart';

class ProductsProvider extends AsyncNotifier<List<ProductEntity>> {
  @override
  Future<List<ProductEntity>> build() async {
    return await ref.watch(getProductsUsecaseProvider).call();
  }

  // --- Write methods (usados por el CRM) ---

  Future<void> createProduct(ProductEntity product) async {
    await ref.read(createProductUsecaseProvider)(product);
    ref.invalidateSelf();
  }

  Future<void> createMany(List<ProductEntity> products) async {
    await ref.read(createProductsUsecaseProvider)(products);
    ref.invalidateSelf();
  }

  Future<void> updateProduct(ProductEntity product) async {
    await ref.read(updateProductUsecaseProvider)(product);
    ref.invalidateSelf();
  }

  Future<void> softDelete(String id) async {
    await ref.read(softDeleteProductUsecaseProvider)(id);
    ref.invalidateSelf();
  }

  Future<void> softDeleteMany(List<String> ids) async {
    await ref.read(softDeleteProductsUsecaseProvider)(ids);
    ref.invalidateSelf();
  }

  Future<void> restore(String id) async {
    await ref.read(restoreProductUsecaseProvider)(id);
    ref.invalidateSelf();
  }

  Future<void> restoreMany(List<String> ids) async {
    await ref.read(restoreProductsUsecaseProvider)(ids);
    ref.invalidateSelf();
  }

  Future<void> updateStock({
    required String productId,
    required String designId,
    required String sizeName,
    required int newStock,
  }) async {
    await ref.read(updateStockUsecaseProvider).call(
      productId: productId,
      designId: designId,
      sizeName: sizeName,
      newStock: newStock,
    );
    ref.invalidateSelf();
  }
}

final productsProvider =
    AsyncNotifierProvider<ProductsProvider, List<ProductEntity>>(
      ProductsProvider.new,
    );
