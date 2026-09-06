import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/cart/presentation/states/cart_display_item.dart';
import 'package:marcos_malaga_app/features/cart/presentation/states/cart_state.dart';

void main() {
  group('CartState', () {
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
      cartItemId: '2_1_M',
      productId: '2',
      designId: '1',
      productName: 'Blusa Seda',
      designName: 'Blanco',
      sizeName: 'M',
      thumbnailUrl: 'url2',
      basePrice: 50.0,
      discountPrice: null,
      unitPrice: 50.0,
      quantity: 1,
      stock: 3,
    );

    test('supports value equality and copyWith', () {
      const state1 = CartState(items: [item1]);
      const state2 = CartState(items: [item1]);
      expect(state1, equals(state2));

      final updated = state1.copyWith(items: [item1, item2]);
      expect(updated.items.length, 2);
    });

    test('computes totals, savings, and flags accurately', () {
      const state = CartState(items: [item1, item2]);

      expect(state.isEmpty, isFalse);
      expect(state.totalItems, equals(3));
      // item1: totalPrice = 160, totalOriginalPrice = 200, savings = 40
      // item2: totalPrice = 50, totalOriginalPrice = 50, savings = 0
      expect(state.totalAmount, equals(210.0));
      expect(state.totalOriginalAmount, equals(250.0));
      expect(state.totalSavings, equals(40.0));
      expect(state.hasSavings, isTrue);
    });

    test('handles empty state correctly', () {
      const state = CartState();
      expect(state.isEmpty, isTrue);
      expect(state.totalItems, equals(0));
      expect(state.totalAmount, equals(0.0));
      expect(state.totalOriginalAmount, equals(0.0));
      expect(state.totalSavings, equals(0.0));
      expect(state.hasSavings, isFalse);
    });
  });
}
