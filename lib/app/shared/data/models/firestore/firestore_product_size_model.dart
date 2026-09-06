import 'package:equatable/equatable.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_size_entity.dart';

class FirestoreProductSizeModel extends Equatable {
  final String size;
  final String sku;
  final int stock;

  const FirestoreProductSizeModel({
    required this.size,
    required this.sku,
    required this.stock,
  });

  factory FirestoreProductSizeModel.fromFirestore(Map<String, dynamic> json) {
    return FirestoreProductSizeModel(
      size: json['size'] as String,
      sku: json['sku'] as String? ?? '',
      stock: (json['stock'] as num).toInt(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'size': size,
      'sku': sku,
      'stock': stock,
    };
  }

  ProductSizeEntity toEntity() {
    return ProductSizeEntity(
      size: size,
      sku: sku.isEmpty ? null : sku,
      stock: stock,
    );
  }

  factory FirestoreProductSizeModel.fromEntity(ProductSizeEntity entity) {
    return FirestoreProductSizeModel(
      size: entity.size,
      sku: entity.sku ?? '',
      stock: entity.stock,
    );
  }

  @override
  List<Object?> get props => [size, sku, stock];
}
