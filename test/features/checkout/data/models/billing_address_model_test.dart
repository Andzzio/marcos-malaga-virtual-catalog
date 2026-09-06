import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/billing_address_model.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/billing_address.dart';

void main() {
  const tBillingAddressModel = BillingAddressModel(
    country: 'PE',
    firstName: 'John',
    lastName: 'Doe',
    dni: '12345678',
    address: 'Av. Prueba 123',
    department: 'Lima',
    province: 'Lima',
    district: 'Miraflores',
    phone: '987654321',
  );

  const tBillingAddress = BillingAddress(
    country: 'PE',
    firstName: 'John',
    lastName: 'Doe',
    dni: '12345678',
    address: 'Av. Prueba 123',
    department: 'Lima',
    province: 'Lima',
    district: 'Miraflores',
    phone: '987654321',
  );

  final tJson = {
    'country': 'PE',
    'firstName': 'John',
    'lastName': 'Doe',
    'dni': '12345678',
    'address': 'Av. Prueba 123',
    'department': 'Lima',
    'province': 'Lima',
    'district': 'Miraflores',
    'phone': '987654321',
  };

  test('should be a subclass of BillingAddress entity', () {
    expect(tBillingAddressModel, isA<BillingAddress>());
  });

  group('fromJson', () {
    test('should return a valid model when JSON is provided', () {
      final result = BillingAddressModel.fromJson(tJson);
      expect(result, equals(tBillingAddressModel));
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () {
      final result = tBillingAddressModel.toJson();
      expect(result, equals(tJson));
    });
  });

  group('fromEntity', () {
    test('should return a valid model when entity is provided', () {
      final result = BillingAddressModel.fromEntity(tBillingAddress);
      expect(result, equals(tBillingAddressModel));
    });
  });

  group('toEntity', () {
    test('should return a valid entity when model is converted', () {
      final result = tBillingAddressModel.toEntity();
      expect(result, equals(tBillingAddress));
    });
  });
}
