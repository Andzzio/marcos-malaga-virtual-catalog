import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/states/product_filters_state.dart';

class ProductFiltersNotifier extends Notifier<ProductFiltersState> {
  final CatalogCategory category;
  ProductFiltersNotifier(this.category);

  @override
  ProductFiltersState build() {
    return const ProductFiltersState();
  }

  void updateQuery(String query) {
    state = state.copyWith(query: query);
  }

  void updateCategory(String? category) {
    state = state.copyWith(category: category);
  }

  void setPriceRange(double? min, double? max) {
    state = state.copyWith(
      minPrice: min,
      maxPrice: max,
      clearMinPrice: min == null,
      clearMaxPrice: max == null,
    );
  }

  void setAvailability({bool? showInStock, bool? showOutOfStock}) {
    state = state.copyWith(
      showInStock: showInStock,
      showOutOfStock: showOutOfStock,
    );
  }

  void setSortOrder(CatalogSortOrder order) {
    state = state.copyWith(sortOrder: order);
  }
}

final productFiltersProvider =
    NotifierProvider.autoDispose.family<ProductFiltersNotifier, ProductFiltersState, CatalogCategory>(
      ProductFiltersNotifier.new,
    );
