import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/checkout_session_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/order_item_model.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/checkout_session.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/order_item.dart';

void main() {
  const tOrderItemModel = OrderItemModel(
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

  final tModel = CheckoutSessionModel(
    id: 'cs_123456',
    items: const [tOrderItemModel],
    clearCartOnSuccess: true,
    createdAt: DateTime(2026, 8, 19, 20, 0, 0),
  );

  final tEntity = CheckoutSession(
    id: 'cs_123456',
    items: const [tOrderItem],
    clearCartOnSuccess: true,
    createdAt: DateTime(2026, 8, 19, 20, 0, 0),
  );

  final tJson = {
    'id': 'cs_123456',
    'items': [
      {
        'productId': 'prod-001',
        'designId': 'des-001',
        'sizeName': 'M',
        'quantity': 2,
        'productName': 'Vestido Floral',
        'designName': 'Rojo Carmesí',
        'imageUrl': 'https://example.com/img.jpg',
        'unitPrice': 89.90,
        'discountPrice': 79.90,
      }
    ],
    'clearCartOnSuccess': true,
    'createdAt': '2026-08-19T20:00:00.000',
  };

  group('CheckoutSessionModel', () {
    test('is a subclass of CheckoutSession entity', () {
      expect(tModel, isA<CheckoutSession>());
    });

    test('fromJson returns a valid model from JSON map', () {
      final result = CheckoutSessionModel.fromJson(tJson);
      expect(result, equals(tModel));
    });

    test('toJson returns a JSON map containing the proper data', () {
      final result = tModel.toJson();
      expect(result, equals(tJson));
    });

    test('bidirectional serialization preserves equality', () {
      final json = tModel.toJson();
      final fromJson = CheckoutSessionModel.fromJson(json);
      expect(fromJson, equals(tModel));
    });

    test('fromEntity converts entity to model correctly', () {
      final result = CheckoutSessionModel.fromEntity(tEntity);
      expect(result, equals(tModel));
    });

    test('toEntity converts model to entity correctly', () {
      final result = tModel.toEntity();
      expect(result, equals(tEntity));
    });

    test('copyWith creates a new instance with updated properties', () {
      final updated = tModel.copyWith(clearCartOnSuccess: false);
      expect(updated.clearCartOnSuccess, false);
      expect(updated.id, tModel.id);
      expect(updated.items, tModel.items);
      expect(updated.createdAt, tModel.createdAt);
    });
  });
}
