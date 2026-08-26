import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/shipping_address.dart';

void main() {
  group('ShippingAddress', () {
    const tShippingAddress = ShippingAddress(
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

    test('supports value equality', () {
      const address1 = ShippingAddress(
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
      const address2 = ShippingAddress(
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

      expect(address1, equals(address2));
      expect(address1.props, equals(address2.props));
    });

    test('copyWith creates a new instance with updated properties', () {
      final updated = tShippingAddress.copyWith(
        district: 'San Isidro',
        districtCode: '150131',
        address: 'Av. Javier Prado 456',
      );

      expect(updated.department, 'Lima');
      expect(updated.province, 'Lima');
      expect(updated.district, 'San Isidro');
      expect(updated.departmentCode, '15');
      expect(updated.provinceCode, '1501');
      expect(updated.districtCode, '150131');
      expect(updated.address, 'Av. Javier Prado 456');
      expect(updated.reference, 'Frente al parque');
      expect(updated.shippingZone, 'LIMA_METROPOLITANA');
      expect(updated, isNot(equals(tShippingAddress)));
    });

    test('copyWith returns identical instance when no arguments are passed', () {
      final updated = tShippingAddress.copyWith();

      expect(updated, equals(tShippingAddress));
    });
  });
}
