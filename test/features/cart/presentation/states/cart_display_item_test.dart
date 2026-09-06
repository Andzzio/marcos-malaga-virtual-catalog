import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/cart/presentation/states/cart_display_item.dart';

void main() {
  group('CartDisplayItem', () {
    test('supports value equality', () {
      const item1 = CartDisplayItem(
        cartItemId: '1_1_S',
        productId: '1',
        designId: '1',
        productName: 'Vestido Flor',
        designName: 'Rojo',
        sizeName: 'S',
        thumbnailUrl: 'url',
        basePrice: 100.0,
        discountPrice: 80.0,
        unitPrice: 80.0,
        quantity: 2,
        stock: 5,
      );

      const item2 = CartDisplayItem(
        cartItemId: '1_1_S',
        productId: '1',
        designId: '1',
        productName: 'Vestido Flor',
        designName: 'Rojo',
        sizeName: 'S',
        thumbnailUrl: 'url',
        basePrice: 100.0,
        discountPrice: 80.0,
        unitPrice: 80.0,
        quantity: 2,
        stock: 5,
      );

      expect(item1, equals(item2));
    });

    test(
      'calculates hasDiscount, totalPrice, totalOriginalPrice, totalSavings correctly with discount',
      () {
        const item = CartDisplayItem(
          cartItemId: '1_1_S',
          productId: '1',
          designId: '1',
          productName: 'Vestido Flor',
          designName: 'Rojo',
          sizeName: 'S',
          thumbnailUrl: 'url',
          basePrice: 100.0,
          discountPrice: 75.0,
          unitPrice: 75.0,
          quantity: 3,
          stock: 5,
        );

        expect(item.hasDiscount, isTrue);
        expect(item.totalPrice, equals(225.0));
        expect(item.totalOriginalPrice, equals(300.0));
        expect(item.totalSavings, equals(75.0));
      },
    );

    test(
      'calculates hasDiscount, totalPrice, totalOriginalPrice, totalSavings correctly without discount',
      () {
        const item = CartDisplayItem(
          cartItemId: '1_1_S',
          productId: '1',
          designId: '1',
          productName: 'Vestido Flor',
          designName: 'Rojo',
          sizeName: 'S',
          thumbnailUrl: 'url',
          basePrice: 100.0,
          discountPrice: null,
          unitPrice: 100.0,
          quantity: 2,
          stock: 5,
        );

        expect(item.hasDiscount, isFalse);
        expect(item.totalPrice, equals(200.0));
        expect(item.totalOriginalPrice, equals(200.0));
        expect(item.totalSavings, equals(0.0));
      },
    );
  });
}
