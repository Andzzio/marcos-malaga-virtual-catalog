import 'package:equatable/equatable.dart';
import 'product_size_entity.dart';

class ProductDesignEntity extends Equatable {
  final String id;
  final String name;
  final int? colorValue;
  final String? swatchImageUrl;
  final List<String> imageUrls;
  final List<ProductSizeEntity> sizes;

  const ProductDesignEntity({
    required this.id,
    required this.name,
    this.colorValue,
    this.swatchImageUrl,
    required this.imageUrls,
    required this.sizes,
  });

  ProductDesignEntity copyWith({
    String? id,
    String? name,
    int? colorValue,
    String? swatchImageUrl,
    List<String>? imageUrls,
    List<ProductSizeEntity>? sizes,
  }) {
    return ProductDesignEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      colorValue: colorValue ?? this.colorValue,
      swatchImageUrl: swatchImageUrl ?? this.swatchImageUrl,
      imageUrls: imageUrls ?? this.imageUrls,
      sizes: sizes ?? this.sizes,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    colorValue,
    swatchImageUrl,
    imageUrls,
    sizes,
  ];
}
