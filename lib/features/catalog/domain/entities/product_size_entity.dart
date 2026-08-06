import 'package:equatable/equatable.dart';

class ProductSizeEntity extends Equatable {
  final String size;
  final int stock;
  final String? sku;

  const ProductSizeEntity({required this.size, required this.stock, this.sku});

  ProductSizeEntity copyWith({String? size, int? stock, String? sku}) {
    return ProductSizeEntity(
      size: size ?? this.size,
      stock: stock ?? this.stock,
      sku: sku ?? this.sku,
    );
  }

  @override
  List<Object?> get props => [size, stock, sku];
}
