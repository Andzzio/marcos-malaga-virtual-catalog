import 'package:marcos_malaga_app/features/catalog/domain/entities/product_design_entity.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/product_size_entity.dart';

class ProductDetailState {
  final ProductEntity product;
  final int quantity;
  final int selectedDesignIndex;
  final int selectedSizeIndex;
  ProductDetailState({
    required this.product,
    this.quantity = 0,
    this.selectedDesignIndex = 0,
    this.selectedSizeIndex = 0,
  });
  ProductDesignEntity get selectedDesign =>
      product.designs[selectedDesignIndex];
  ProductSizeEntity get selectedSize => selectedDesign.sizes[selectedSizeIndex];
  ProductDetailState copyWith({
    ProductEntity? product,
    int? quantity,
    int? selectedDesignIndex,
    int? selectedSizeIndex,
  }) {
    return ProductDetailState(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedDesignIndex: selectedDesignIndex ?? this.selectedDesignIndex,
      selectedSizeIndex: selectedSizeIndex ?? this.selectedSizeIndex,
    );
  }
}
