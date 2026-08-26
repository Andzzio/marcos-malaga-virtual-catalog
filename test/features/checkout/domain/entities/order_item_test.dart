import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/order_item.dart';

void main() {
  group('OrderItem', () {
    const tOrderItem = OrderItem(
      productId: 'prod-001',
      designId: 'des-001',
      sizeName: 'M',
      quantity: 2,
      productName: 'Vestido Floral',
      designName: 'Rojo Carmesí',
      imageUrl: 'https://example.com/img.jpg',
      unitPrice: 89.90,
      discountPrice: 79.90,
    );

    test('supports value equality', () {
      const item1 = OrderItem(
        productId: 'prod-001',
        designId: 'des-001',
        sizeName: 'M',
        quantity: 2,
        productName: 'Vestido Floral',
        designName: 'Rojo Carmesí',
        imageUrl: 'https://example.com/img.jpg',
        unitPrice: 89.90,
        discountPrice: 79.90,
      );
      const item2 = OrderItem(
        productId: 'prod-001',
        designId: 'des-001',
        sizeName: 'M',
        quantity: 2,
        productName: 'Vestido Floral',
        designName: 'Rojo Carmesí',
        imageUrl: 'https://example.com/img.jpg',
        unitPrice: 89.90,
        discountPrice: 79.90,
      );

      expect(item1, equals(item2));
      expect(item1.props, equals(item2.props));
    });

    test('copyWith creates a new instance with updated properties', () {
      final updated = tOrderItem.copyWith(
        quantity: 3,
        discountPrice: 69.90,
      );

      expect(updated.productId, 'prod-001');
      expect(updated.designId, 'des-001');
      expect(updated.sizeName, 'M');
      expect(updated.quantity, 3);
      expect(updated.productName, 'Vestido Floral');
      expect(updated.designName, 'Rojo Carmesí');
      expect(updated.imageUrl, 'https://example.com/img.jpg');
      expect(updated.unitPrice, 89.90);
      expect(updated.discountPrice, 69.90);
      expect(updated, isNot(equals(tOrderItem)));
    });

    test('copyWith returns identical instance when no arguments are passed', () {
      final updated = tOrderItem.copyWith();

      expect(updated, equals(tOrderItem));
    });
  });
}
