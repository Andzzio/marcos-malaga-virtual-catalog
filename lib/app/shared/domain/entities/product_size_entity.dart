import 'package:equatable/equatable.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/stock_availability.dart';

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

  StockAvailability get stockAvailability {
    if (stock == 0) return StockAvailability.outOfStock;
    if (stock <= 5) return StockAvailability.lowStock;
    return StockAvailability.inStock;
  }

  @override
  List<Object?> get props => [size, stock, sku];
}
