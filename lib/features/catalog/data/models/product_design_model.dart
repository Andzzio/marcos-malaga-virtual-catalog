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
    int? parsedColor;
    if (hexCode != null && hexCode!.isNotEmpty) {
      final cleanHex = hexCode!.replaceFirst('#', '0xFF');
      parsedColor = int.tryParse(cleanHex);
    }

    return ProductDesignEntity(
      id: id,
      name: name,
      colorValue: parsedColor,
      swatchImageUrl: swatchImageUrl,
      imageUrls: imageUrls,
      sizes: sizes.map((e) => e.toEntity()).toList(),
    );
  }

  factory ProductDesignModel.fromEntity(ProductDesignEntity entity) {
    String? stringHex;
    if (entity.colorValue != null) {
      stringHex = '#${entity.colorValue!.toRadixString(16).substring(2).toUpperCase()}';
    }

    return ProductDesignModel(
      id: entity.id,
      name: entity.name,
      hexCode: stringHex,
      swatchImageUrl: entity.swatchImageUrl,
      imageUrls: entity.imageUrls,
      sizes: entity.sizes.map((e) => ProductSizeModel.fromEntity(e)).toList(),
    );
  }
}
