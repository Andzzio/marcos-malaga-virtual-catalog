import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/stock_availability.dart';
import 'package:marcos_malaga_app/app/shared/presentation/providers/products_provider.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/providers/product_filters_provider.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/states/product_filters_state.dart';

class FilteredProductsNotifier extends AsyncNotifier<List<ProductEntity>> {
  final CatalogCategory category;
  FilteredProductsNotifier(this.category);

  @override
  Future<List<ProductEntity>> build() async {
    final filters = ref.watch(productFiltersProvider(category));
    final allProducts = await ref.watch(productsProvider.future);

    var categoryFiltered = allProducts.where((product) {
      if (!product.isVisible) return false;
      if (category == CatalogCategory.xlSizes) {
        bool hasXl = false;
        for (var design in product.designs) {
          for (var size in design.sizes) {
            if (size.size.toLowerCase() == 'xl') {
              hasXl = true;
              break;
            }
          }
          if (hasXl) break;
        }
        if (!hasXl) return false;
      }
      return true;
    }).toList();

    final filteredProducts = categoryFiltered.where((product) {
      if (!filters.showInStock) {
        if (product.stockAvailability == StockAvailability.inStock ||
            product.stockAvailability == StockAvailability.lowStock) {
          return false;
        }
      }
      if (!filters.showOutOfStock) {
        if (product.stockAvailability == StockAvailability.outOfStock) {
          return false;
        }
      }

      final price = product.discountPrice ?? product.basePrice;
      if (filters.minPrice != null && price < filters.minPrice!) return false;
      if (filters.maxPrice != null && price > filters.maxPrice!) return false;

      if (filters.query.isNotEmpty) {
        final q = filters.query.toLowerCase();
        final titleMatch = product.name.toLowerCase().contains(q);
        final descMatch = product.description.toLowerCase().contains(q);
        if (!titleMatch && !descMatch) return false;
      }

      if (filters.category != null && filters.category!.isNotEmpty) {
        final catMatch = product.categoryIds.any(
            (c) => c.toLowerCase() == filters.category!.toLowerCase());
        if (!catMatch) return false;
      }

      return true;
    }).toList();

    filteredProducts.sort((a, b) {
      switch (filters.sortOrder) {
        case CatalogSortOrder.priceAsc:
          final priceA = a.discountPrice ?? a.basePrice;
          final priceB = b.discountPrice ?? b.basePrice;
          return priceA.compareTo(priceB);
        case CatalogSortOrder.priceDesc:
          final priceA = a.discountPrice ?? a.basePrice;
          final priceB = b.discountPrice ?? b.basePrice;
          return priceB.compareTo(priceA);
        case CatalogSortOrder.nameAsc:
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        case CatalogSortOrder.nameDesc:
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        case CatalogSortOrder.newest:
          return b.createdAt.compareTo(a.createdAt);
        case CatalogSortOrder.oldest:
          return a.createdAt.compareTo(b.createdAt);
        case CatalogSortOrder.relevance:
          if (category == CatalogCategory.newArrivals) {
            return b.createdAt.compareTo(a.createdAt);
          }
          return 0;
      }
    });

    return filteredProducts;
  }
}

final filteredProductsProvider = AsyncNotifierProvider.autoDispose
    .family<FilteredProductsNotifier, List<ProductEntity>, CatalogCategory>(
      FilteredProductsNotifier.new,
    );
