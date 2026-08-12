import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/providers/features/catalog/catalog_providers.dart';

class SingleProductProvider extends AsyncNotifier<ProductEntity?> {
  final String productId;
  SingleProductProvider(this.productId);
  @override
  Future<ProductEntity?> build() async {
    final product = await ref
        .watch(getProductByIdUsecaseProvider)
        .call(productId);
    return product;
  }
}

final singleProductProvider = AsyncNotifierProvider.family
    .autoDispose<SingleProductProvider, ProductEntity?, String>(
      SingleProductProvider.new,
    );
