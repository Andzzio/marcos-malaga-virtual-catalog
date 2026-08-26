import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/shipping_zone_model.dart';

void main() {
  const tModel = ShippingZoneModel(
    id: 'zone-lima',
    name: 'Lima Metropolitana',
    departmentCodes: ['15'],
    freeShippingThreshold: 150.0,
  );

  final tJson = {
    'id': 'zone-lima',
    'name': 'Lima Metropolitana',
    'departmentCodes': ['15'],
    'freeShippingThreshold': 150.0,
  };

  group('ShippingZoneModel', () {
    test('supports value equality', () {
      const otherModel = ShippingZoneModel(
        id: 'zone-lima',
        name: 'Lima Metropolitana',
        departmentCodes: ['15'],
        freeShippingThreshold: 150.0,
      );
      expect(tModel, equals(otherModel));
    });

    test('fromJson returns a valid model from JSON map', () {
      final result = ShippingZoneModel.fromJson(tJson);
      expect(result, equals(tModel));
    });

    test('toJson returns a JSON map containing the proper data', () {
      final result = tModel.toJson();
      expect(result, equals(tJson));
    });

    test('bidirectional serialization preserves equality', () {
      final json = tModel.toJson();
      final fromJson = ShippingZoneModel.fromJson(json);
      expect(fromJson, equals(tModel));
    });

    test('copyWith creates a new instance with updated properties', () {
      final updated = tModel.copyWith(
        name: 'Lima y Callao',
        departmentCodes: ['15', '07'],
      );
      expect(updated.name, 'Lima y Callao');
      expect(updated.departmentCodes, ['15', '07']);
      expect(updated.id, tModel.id);
      expect(updated.freeShippingThreshold, tModel.freeShippingThreshold);
    });
  });
}
