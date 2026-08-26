import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/customer_info_model.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/customer_info.dart';

void main() {
  const tModel = CustomerInfoModel(
    firstName: 'Ana',
    lastName: 'Pérez',
    dni: '12345678',
    phone: '987654321',
  );

  const tEntity = CustomerInfo(
    firstName: 'Ana',
    lastName: 'Pérez',
    dni: '12345678',
    phone: '987654321',
  );

  final tJson = {
    'firstName': 'Ana',
    'lastName': 'Pérez',
    'dni': '12345678',
    'phone': '987654321',
  };

  group('CustomerInfoModel', () {
    test('is a subclass of CustomerInfo entity', () {
      expect(tModel, isA<CustomerInfo>());
    });

    test('fromJson returns a valid model from JSON map', () {
      final result = CustomerInfoModel.fromJson(tJson);
      expect(result, equals(tModel));
    });

    test('toJson returns a JSON map containing the proper data', () {
      final result = tModel.toJson();
      expect(result, equals(tJson));
    });

    test('bidirectional serialization preserves equality', () {
      final json = tModel.toJson();
      final fromJson = CustomerInfoModel.fromJson(json);
      expect(fromJson, equals(tModel));
    });

    test('fromEntity converts entity to model correctly', () {
      final result = CustomerInfoModel.fromEntity(tEntity);
      expect(result, equals(tModel));
    });

    test('toEntity converts model to entity correctly', () {
      final result = tModel.toEntity();
      expect(result, equals(tEntity));
    });

    test('copyWith creates a new instance with updated properties', () {
      final updated = tModel.copyWith(firstName: 'Lucía');
      expect(updated.firstName, 'Lucía');
      expect(updated.lastName, tModel.lastName);
      expect(updated.dni, tModel.dni);
      expect(updated.phone, tModel.phone);
    });
  });
}
