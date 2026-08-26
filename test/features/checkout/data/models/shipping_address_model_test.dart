import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/shipping_address_model.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/shipping_address.dart';

void main() {
  const tModel = ShippingAddressModel(
    department: 'Lima',
    province: 'Lima',
    district: 'Miraflores',
    departmentCode: '15',
    provinceCode: '1501',
    districtCode: '150122',
    address: 'Av. Larco 123',
    reference: 'Frente al parque',
    shippingZone: 'LIMA_METROPOLITANA',
  );

  const tEntity = ShippingAddress(
    department: 'Lima',
    province: 'Lima',
    district: 'Miraflores',
    departmentCode: '15',
    provinceCode: '1501',
    districtCode: '150122',
    address: 'Av. Larco 123',
    reference: 'Frente al parque',
    shippingZone: 'LIMA_METROPOLITANA',
  );

  final tJson = {
    'department': 'Lima',
    'province': 'Lima',
    'district': 'Miraflores',
    'departmentCode': '15',
    'provinceCode': '1501',
    'districtCode': '150122',
    'address': 'Av. Larco 123',
    'reference': 'Frente al parque',
    'shippingZone': 'LIMA_METROPOLITANA',
  };

  group('ShippingAddressModel', () {
    test('is a subclass of ShippingAddress entity', () {
      expect(tModel, isA<ShippingAddress>());
    });

    test('fromJson returns a valid model from JSON map', () {
      final result = ShippingAddressModel.fromJson(tJson);
      expect(result, equals(tModel));
    });

    test('toJson returns a JSON map containing the proper data', () {
      final result = tModel.toJson();
      expect(result, equals(tJson));
    });

    test('bidirectional serialization preserves equality', () {
      final json = tModel.toJson();
      final fromJson = ShippingAddressModel.fromJson(json);
      expect(fromJson, equals(tModel));
    });

    test('fromEntity converts entity to model correctly', () {
      final result = ShippingAddressModel.fromEntity(tEntity);
      expect(result, equals(tModel));
    });

    test('toEntity converts model to entity correctly', () {
      final result = tModel.toEntity();
      expect(result, equals(tEntity));
    });

    test('copyWith creates a new instance with updated properties', () {
      final updated = tModel.copyWith(address: 'Av. Benavides 456');
      expect(updated.address, 'Av. Benavides 456');
      expect(updated.department, tModel.department);
      expect(updated.province, tModel.province);
      expect(updated.district, tModel.district);
    });
  });
}
