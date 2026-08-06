import 'package:marcos_malaga_app/features/catalog/data/models/product_design_model.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/product_entity.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double basePrice;
  final double? discountPrice;
  final List<String> categoryIds;
  final List<ProductDesignModel> designs;
  final bool isVisible;
  final DateTime createdAt;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.basePrice,
    this.discountPrice,
    required this.categoryIds,
    required this.designs,
    required this.isVisible,
    required this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      basePrice: (json['basePrice'] as num?)?.toDouble() ?? 0.0,
      discountPrice: (json['discountPrice'] as num?)?.toDouble(),
      categoryIds:
          (json['categoryIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      designs:
          (json['designs'] as List<dynamic>?)
              ?.map(
                (e) => ProductDesignModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      isVisible: json['isVisible'] as bool? ?? true,
      createdAt: DateTime.parse(
        json['createdAt'] as String? ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'basePrice': basePrice,
      'discountPrice': discountPrice,
      'categoryIds': categoryIds,
      'designs': designs.map((e) => e.toJson()).toList(),
      'isVisible': isVisible,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      description: description,
      basePrice: basePrice,
      discountPrice: discountPrice,
      categoryIds: categoryIds,
      designs: designs.map((e) => e.toEntity()).toList(),
      isVisible: isVisible,
      createdAt: createdAt,
    );
  }

  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      basePrice: entity.basePrice,
      discountPrice: entity.discountPrice,
      categoryIds: entity.categoryIds,
      designs: entity.designs
          .map((e) => ProductDesignModel.fromEntity(e))
          .toList(),
      isVisible: entity.isVisible,
      createdAt: entity.createdAt,
    );
  }
}
