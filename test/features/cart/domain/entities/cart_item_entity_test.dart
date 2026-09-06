import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/cart/domain/entities/cart_item_entity.dart';

void main() {
  test('CartItemEntity should have correct properties', () {
    const item = CartItemEntity(
      id: 'i1',
      productId: 'p1',
      designId: 'd1',
      sizeName: 'M',
      quantity: 2,
    );

    expect(item.id, 'i1');
    expect(item.productId, 'p1');
    expect(item.designId, 'd1');
    expect(item.sizeName, 'M');
    expect(item.quantity, 2);
  });
}
