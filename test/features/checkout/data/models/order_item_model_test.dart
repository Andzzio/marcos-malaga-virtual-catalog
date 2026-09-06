import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/app/shared/data/models/order/order_item_model.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/order/order_item.dart';

void main() {
  const tModel = OrderItemModel(
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

  const tEntity = OrderItem(
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

  final tJson = {
    'productId': 'prod-001',
    'designId': 'des-001',
    'sizeName': 'M',
    'quantity': 2,
    'productName': 'Vestido Floral',
    'designName': 'Rojo Carmesí',
    'imageUrl': 'https://example.com/img.jpg',
    'unitPrice': 89.90,
    'discountPrice': 79.90,
  };

  group('OrderItemModel', () {
    test('fromJson returns a valid model from JSON map', () {
      final result = OrderItemModel.fromJson(tJson);
      expect(result, equals(tModel));
    });

    test('toJson returns a JSON map containing the proper data', () {
      final result = tModel.toJson();
      expect(result, equals(tJson));
    });

    test('bidirectional serialization preserves equality', () {
      final json = tModel.toJson();
      final fromJson = OrderItemModel.fromJson(json);
      expect(fromJson, equals(tModel));
    });

    test('fromEntity converts entity to model correctly', () {
      final result = OrderItemModel.fromEntity(tEntity);
      expect(result, equals(tModel));
    });

    test('toEntity converts model to entity correctly', () {
      final result = tModel.toEntity();
      expect(result, equals(tEntity));
    });

    test('copyWith creates a new instance with updated properties', () {
      final updated = tModel.copyWith(quantity: 5, unitPrice: 99.90);
      expect(updated.quantity, 5);
      expect(updated.unitPrice, 99.90);
      expect(updated.productId, tModel.productId);
      expect(updated.discountPrice, tModel.discountPrice);
    });
  });
}
