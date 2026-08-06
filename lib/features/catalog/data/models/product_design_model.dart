import 'package:marcos_malaga_app/features/catalog/data/models/product_size_model.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/product_design_entity.dart';

class ProductDesignModel {
  final String id;
  final String name;
  final String? hexCode;
  final String? swatchImageUrl;
  final List<String> imageUrls;
  final List<ProductSizeModel> sizes;

  const ProductDesignModel({
    required this.id,
    required this.name,
    this.hexCode,
    this.swatchImageUrl,
    required this.imageUrls,
    required this.sizes,
  });

  factory ProductDesignModel.fromJson(Map<String, dynamic> json) {
    return ProductDesignModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      hexCode: json['hexCode'] as String?,
      swatchImageUrl: json['swatchImageUrl'] as String?,
      imageUrls:
          (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      sizes:
          (json['sizes'] as List<dynamic>?)
              ?.map((e) => ProductSizeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'hexCode': hexCode,
      'swatchImageUrl': swatchImageUrl,
      'imageUrls': imageUrls,
      'sizes': sizes.map((e) => e.toJson()).toList(),
    };
  }

  ProductDesignEntity toEntity() {
    return ProductDesignEntity(
      id: id,
      name: name,
      hexCode: hexCode,
      swatchImageUrl: swatchImageUrl,
      imageUrls: imageUrls,
      sizes: sizes.map((e) => e.toEntity()).toList(),
    );
  }

  factory ProductDesignModel.fromEntity(ProductDesignEntity entity) {
    return ProductDesignModel(
      id: entity.id,
      name: entity.name,
      hexCode: entity.hexCode,
      swatchImageUrl: entity.swatchImageUrl,
      imageUrls: entity.imageUrls,
      sizes: entity.sizes.map((e) => ProductSizeModel.fromEntity(e)).toList(),
    );
  }
}
