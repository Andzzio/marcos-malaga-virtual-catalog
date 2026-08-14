import 'package:equatable/equatable.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/stock_availability.dart';
import 'product_design_entity.dart';

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double basePrice;
  final double? discountPrice;
  final List<String> categoryIds;
  final List<ProductDesignEntity> designs;
  final bool isVisible;
  final String? sizeChartImageUrl;
  final DateTime createdAt;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    this.discountPrice,
    required this.categoryIds,
    required this.designs,
    required this.isVisible,
    this.sizeChartImageUrl,
    required this.createdAt,
  });
  int get totalStock => designs.fold(
    0,
    (sum, design) =>
        sum + design.sizes.fold(0, (sizeSum, size) => sizeSum + size.stock),
  );

  StockAvailability get stockAvailability {
    if (totalStock == 0) return StockAvailability.outOfStock;
    if (totalStock <= 5) return StockAvailability.lowStock;
    return StockAvailability.inStock;
  }

  ProductEntity copyWith({
    String? id,
    String? name,
    String? description,
    double? basePrice,
    double? discountPrice,
    List<String>? categoryIds,
    List<ProductDesignEntity>? designs,
    bool? isVisible,
    String? sizeChartImageUrl,
    DateTime? createdAt,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      basePrice: basePrice ?? this.basePrice,
      discountPrice: discountPrice ?? this.discountPrice,
      categoryIds: categoryIds ?? this.categoryIds,
      designs: designs ?? this.designs,
      isVisible: isVisible ?? this.isVisible,
      sizeChartImageUrl: sizeChartImageUrl ?? this.sizeChartImageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    basePrice,
    discountPrice,
    categoryIds,
    designs,
    isVisible,
    sizeChartImageUrl,
    createdAt,
  ];
}
