import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/customer_info.dart';

void main() {
  group('CustomerInfo', () {
    const tCustomer = CustomerInfo(
      firstName: 'Ana',
      lastName: 'Pérez',
      dni: '12345678',
      phone: '987654321',
    );

    test('supports value equality', () {
      const customer1 = CustomerInfo(
        firstName: 'Ana',
        lastName: 'Pérez',
        dni: '12345678',
        phone: '987654321',
      );
      const customer2 = CustomerInfo(
        firstName: 'Ana',
        lastName: 'Pérez',
        dni: '12345678',
        phone: '987654321',
      );

      expect(customer1, equals(customer2));
      expect(customer1.props, equals(customer2.props));
    });

    test('copyWith creates a new instance with updated properties', () {
      final updated = tCustomer.copyWith(
        firstName: 'Lucía',
        lastName: 'Gómez',
      );

      expect(updated.firstName, 'Lucía');
      expect(updated.lastName, 'Gómez');
      expect(updated.dni, '12345678');
      expect(updated.phone, '987654321');
      expect(updated, isNot(equals(tCustomer)));
    });

    test('copyWith returns identical instance when no arguments are passed', () {
      final updated = tCustomer.copyWith();

      expect(updated, equals(tCustomer));
    });
  });
}
