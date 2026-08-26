import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/shipping_method_model.dart';

void main() {
  const tModel = ShippingMethodModel(
    id: 'olva',
    label: 'Olva Courier',
    enabled: true,
    availableZones: ['zone-lima', 'zone-provinces'],
    prices: {'zone-lima': 10.0, 'zone-provinces': 15.0},
    estimatedDays: '2-3 días hábiles',
    description: 'Envío regular',
  );

  final tJson = {
    'id': 'olva',
    'label': 'Olva Courier',
    'enabled': true,
    'availableZones': ['zone-lima', 'zone-provinces'],
    'prices': {'zone-lima': 10.0, 'zone-provinces': 15.0},
    'estimatedDays': '2-3 días hábiles',
    'description': 'Envío regular',
  };

  group('ShippingMethodModel', () {
    test('supports value equality', () {
      const otherModel = ShippingMethodModel(
        id: 'olva',
        label: 'Olva Courier',
        enabled: true,
        availableZones: ['zone-lima', 'zone-provinces'],
        prices: {'zone-lima': 10.0, 'zone-provinces': 15.0},
        estimatedDays: '2-3 días hábiles',
        description: 'Envío regular',
      );
      expect(tModel, equals(otherModel));
    });

    test('fromJson returns a valid model from JSON map', () {
      final result = ShippingMethodModel.fromJson(tJson);
      expect(result, equals(tModel));
    });

    test('toJson returns a JSON map containing the proper data', () {
      final result = tModel.toJson();
      expect(result, equals(tJson));
    });

    test('bidirectional serialization preserves equality', () {
      final json = tModel.toJson();
      final fromJson = ShippingMethodModel.fromJson(json);
      expect(fromJson, equals(tModel));
    });

    test('copyWith creates a new instance with updated properties', () {
      final updated = tModel.copyWith(
        enabled: false,
        prices: {'zone-lima': 12.0},
      );
      expect(updated.enabled, false);
      expect(updated.prices, {'zone-lima': 12.0});
      expect(updated.id, tModel.id);
      expect(updated.label, tModel.label);
    });
  });
}
