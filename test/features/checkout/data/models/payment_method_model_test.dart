import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/payment_method_model.dart';

void main() {
  const tModel = PaymentMethodModel(
    id: 'yape',
    label: 'Yape / Plin',
    enabled: true,
    type: 'manual',
    instructions: 'Transfiere al número 987654321 y envía el comprobante',
    details: {'phoneNumber': '987654321', 'holderName': 'Marcos Málaga'},
  );

  final tJson = {
    'id': 'yape',
    'label': 'Yape / Plin',
    'enabled': true,
    'type': 'manual',
    'instructions': 'Transfiere al número 987654321 y envía el comprobante',
    'details': {'phoneNumber': '987654321', 'holderName': 'Marcos Málaga'},
  };

  group('PaymentMethodModel', () {
    test('supports value equality', () {
      const otherModel = PaymentMethodModel(
        id: 'yape',
        label: 'Yape / Plin',
        enabled: true,
        type: 'manual',
        instructions: 'Transfiere al número 987654321 y envía el comprobante',
        details: {'phoneNumber': '987654321', 'holderName': 'Marcos Málaga'},
      );
      expect(tModel, equals(otherModel));
    });

    test('fromJson returns a valid model from JSON map', () {
      final result = PaymentMethodModel.fromJson(tJson);
      expect(result, equals(tModel));
    });

    test('toJson returns a JSON map containing the proper data', () {
      final result = tModel.toJson();
      expect(result, equals(tJson));
    });

    test('bidirectional serialization preserves equality', () {
      final json = tModel.toJson();
      final fromJson = PaymentMethodModel.fromJson(json);
      expect(fromJson, equals(tModel));
    });

    test('copyWith creates a new instance with updated properties', () {
      final updated = tModel.copyWith(
        enabled: false,
        instructions: 'Nuevo número 912345678',
      );
      expect(updated.enabled, false);
      expect(updated.instructions, 'Nuevo número 912345678');
      expect(updated.id, tModel.id);
      expect(updated.type, tModel.type);
    });
  });
}
