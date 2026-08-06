import 'package:equatable/equatable.dart';
import 'product_size_entity.dart';

class ProductDesignEntity extends Equatable {
  final String id;
  final String name;
  final String? hexCode;
  final String? swatchImageUrl;
  final List<String> imageUrls;
  final List<ProductSizeEntity> sizes;

  const ProductDesignEntity({
    required this.id,
    required this.name,
    this.hexCode,
    this.swatchImageUrl,
    required this.imageUrls,
    required this.sizes,
  });

  ProductDesignEntity copyWith({
    String? id,
    String? name,
    String? hexCode,
    String? swatchImageUrl,
    List<String>? imageUrls,
    List<ProductSizeEntity>? sizes,
  }) {
    return ProductDesignEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      hexCode: hexCode ?? this.hexCode,
      swatchImageUrl: swatchImageUrl ?? this.swatchImageUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      sizes: sizes ?? this.sizes,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    hexCode,
    swatchImageUrl,
    imageUrls,
    sizes,
  ];
}
