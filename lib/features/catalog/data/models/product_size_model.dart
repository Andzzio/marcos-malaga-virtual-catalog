import 'package:marcos_malaga_app/app/shared/domain/entities/product_size_entity.dart';

class ProductSizeModel {
  final String size;
  final int stock;
  final String? sku;

  const ProductSizeModel({required this.size, required this.stock, this.sku});

  factory ProductSizeModel.fromJson(Map<String, dynamic> json) {
    return ProductSizeModel(
      size: json['size'] as String? ?? '',
      stock: json['stock'] as int? ?? 0,
      sku: json['sku'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'size': size, 'stock': stock, 'sku': sku};
  }

  ProductSizeEntity toEntity() {
    return ProductSizeEntity(size: size, stock: stock, sku: sku);
  }

  factory ProductSizeModel.fromEntity(ProductSizeEntity entity) {
    return ProductSizeModel(
      size: entity.size,
      stock: entity.stock,
      sku: entity.sku,
    );
  }
}
