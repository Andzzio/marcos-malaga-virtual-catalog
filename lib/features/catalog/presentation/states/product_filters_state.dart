enum CatalogCategory { global, newArrivals, xlSizes }

enum CatalogSortOrder {
  relevance,
  priceAsc,
  priceDesc,
  nameAsc,
  nameDesc,
  newest,
  oldest,
}

class ProductFiltersState {
  final String query;
  final String? category;
  final double? minPrice;
  final double? maxPrice;
  final bool showInStock;
  final bool showOutOfStock;
  final CatalogSortOrder sortOrder;

  const ProductFiltersState({
    this.query = '',
    this.category,
    this.minPrice,
    this.maxPrice,
    this.showInStock = true,
    this.showOutOfStock = true,
    this.sortOrder = CatalogSortOrder.relevance,
  });

  ProductFiltersState copyWith({
    String? query,
    String? category,
    double? minPrice,
    double? maxPrice,
    bool? showInStock,
    bool? showOutOfStock,
    bool clearMinPrice = false,
    bool clearMaxPrice = false,
    CatalogSortOrder? sortOrder,
  }) {
    return ProductFiltersState(
      query: query ?? this.query,
      category: category ?? this.category,
      minPrice: clearMinPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearMaxPrice ? null : (maxPrice ?? this.maxPrice),
      showInStock: showInStock ?? this.showInStock,
      showOutOfStock: showOutOfStock ?? this.showOutOfStock,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

extension CatalogSortOrderExtension on CatalogSortOrder {
  String get label {
    switch (this) {
      case CatalogSortOrder.relevance:
        return 'Relevancia (Destacados)';
      case CatalogSortOrder.priceAsc:
        return 'Precio: de menor a mayor';
      case CatalogSortOrder.priceDesc:
        return 'Precio: de mayor a menor';
      case CatalogSortOrder.nameAsc:
        return 'Alfabéticamente: A-Z';
      case CatalogSortOrder.nameDesc:
        return 'Alfabéticamente: Z-A';
      case CatalogSortOrder.newest:
        return 'Más recientes';
      case CatalogSortOrder.oldest:
        return 'Más antiguos';
    }
  }
}
