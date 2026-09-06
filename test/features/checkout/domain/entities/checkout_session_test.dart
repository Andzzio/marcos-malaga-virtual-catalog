import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/checkout_session.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/order/order_item.dart';

void main() {
  group('CheckoutSession', () {
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

    final tSession = CheckoutSession(
      id: 'cs_123456',
      items: const [tOrderItem],
      clearCartOnSuccess: true,
      createdAt: DateTime(2026, 8, 19, 20, 0, 0),
    );

    test('supports value equality', () {
      final session1 = CheckoutSession(
        id: 'cs_123456',
        items: const [tOrderItem],
        clearCartOnSuccess: true,
        createdAt: DateTime(2026, 8, 19, 20, 0, 0),
      );
      final session2 = CheckoutSession(
        id: 'cs_123456',
        items: const [tOrderItem],
        clearCartOnSuccess: true,
        createdAt: DateTime(2026, 8, 19, 20, 0, 0),
      );

      expect(session1, equals(session2));
      expect(session1.props, equals(session2.props));
    });

    test('copyWith creates a new instance with updated properties', () {
      final updated = tSession.copyWith(clearCartOnSuccess: false);

      expect(updated.id, 'cs_123456');
      expect(updated.items, tSession.items);
      expect(updated.clearCartOnSuccess, false);
      expect(updated.createdAt, tSession.createdAt);
      expect(updated, isNot(equals(tSession)));
    });

    test(
      'copyWith returns identical instance when no arguments are passed',
      () {
        final updated = tSession.copyWith();

        expect(updated, equals(tSession));
      },
    );
  });
}
