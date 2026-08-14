import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_design_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_size_entity.dart';
import 'package:marcos_malaga_app/features/cart/domain/entities/cart_item_entity.dart';

void main() {
  final tProduct = ProductEntity(
    id: 'p1',
    name: 'Product 1',
    description: 'Desc 1',
    basePrice: 100.0,
    discountPrice: 80.0,
    categoryIds: const [],
    designs: const [],
    isVisible: true,
    createdAt: DateTime.now(),
  );

  final tDesign = ProductDesignEntity(
    id: 'd1',
    name: 'Red',
    imageUrls: const [],
    sizes: const [],
  );

  final tSize = ProductSizeEntity(
    size: 'M',
    stock: 10,
  );

  test('CartItemEntity should calculate total price prioritizing discountPrice', () {
    final item = CartItemEntity(
      id: 'i1',
      product: tProduct,
      selectedDesign: tDesign,
      selectedSize: tSize,
      quantity: 2,
    );

    // 80.0 * 2 = 160.0
    expect(item.totalPrice, 160.0);
  });
}
