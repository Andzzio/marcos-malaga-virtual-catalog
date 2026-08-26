import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/checkout_config_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/payment_method_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/shipping_method_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/shipping_zone_model.dart';

void main() {
  const tZone = ShippingZoneModel(
    id: 'zone-lima',
    name: 'Lima Metropolitana',
    departmentCodes: ['15'],
    freeShippingThreshold: 150.0,
  );

  const tShippingMethod = ShippingMethodModel(
    id: 'olva',
    label: 'Olva Courier',
    enabled: true,
    availableZones: ['zone-lima'],
    prices: {'zone-lima': 10.0},
    estimatedDays: '2-3 días hábiles',
    description: 'Envío por Olva Courier',
  );

  const tPaymentMethod = PaymentMethodModel(
    id: 'yape',
    label: 'Yape / Plin',
    enabled: true,
    type: 'manual',
    instructions: 'Transfiere al 987654321',
    details: {'phoneNumber': '987654321'},
  );

  const tModel = CheckoutConfigModel(
    shippingZones: [tZone],
    shippingMethods: [tShippingMethod],
    paymentMethods: [tPaymentMethod],
  );

  final tJson = {
    'shippingZones': [
      {
        'id': 'zone-lima',
        'name': 'Lima Metropolitana',
        'departmentCodes': ['15'],
        'freeShippingThreshold': 150.0,
      }
    ],
    'shippingMethods': [
      {
        'id': 'olva',
        'label': 'Olva Courier',
        'enabled': true,
        'availableZones': ['zone-lima'],
        'prices': {'zone-lima': 10.0},
        'estimatedDays': '2-3 días hábiles',
        'description': 'Envío por Olva Courier',
      }
    ],
    'paymentMethods': [
      {
        'id': 'yape',
        'label': 'Yape / Plin',
        'enabled': true,
        'type': 'manual',
        'instructions': 'Transfiere al 987654321',
        'details': {'phoneNumber': '987654321'},
      }
    ],
  };

  group('CheckoutConfigModel', () {
    test('supports value equality', () {
      const otherModel = CheckoutConfigModel(
        shippingZones: [tZone],
        shippingMethods: [tShippingMethod],
        paymentMethods: [tPaymentMethod],
      );
      expect(tModel, equals(otherModel));
    });

    test('fromJson returns a valid model from JSON map', () {
      final result = CheckoutConfigModel.fromJson(tJson);
      expect(result, equals(tModel));
    });

    test('toJson returns a JSON map containing the proper data', () {
      final result = tModel.toJson();
      expect(result, equals(tJson));
    });

    test('bidirectional serialization preserves equality', () {
      final json = tModel.toJson();
      final fromJson = CheckoutConfigModel.fromJson(json);
      expect(fromJson, equals(tModel));
    });

    test('copyWith creates a new instance with updated properties', () {
      final updated = tModel.copyWith(
        shippingZones: const [],
      );
      expect(updated.shippingZones, isEmpty);
      expect(updated.shippingMethods, [tShippingMethod]);
      expect(updated.paymentMethods, [tPaymentMethod]);
    });
  });
}
