import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/providers/features/catalog/catalog_providers.dart';

class ProductsProvider extends AsyncNotifier<List<ProductEntity>> {
  @override
  Future<List<ProductEntity>> build() async {
    return await ref.watch(getProductsUsecaseProvider).call();
  }
}

final productsProvider =
    AsyncNotifierProvider<ProductsProvider, List<ProductEntity>>(
      ProductsProvider.new,
    );
