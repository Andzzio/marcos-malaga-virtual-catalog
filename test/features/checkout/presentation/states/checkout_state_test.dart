import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/customer_info.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/shipping_address.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/checkout_session.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/states/checkout_state.dart';

void main() {
  group('CheckoutState', () {
    const tCustomer = CustomerInfo(
      firstName: 'Ana',
      lastName: 'Pérez',
      dni: '87654321',
      phone: '912345678',
    );

    const tAddress = ShippingAddress(
      department: 'Lima',
      province: 'Lima',
      district: 'San Isidro',
      departmentCode: '15',
      provinceCode: '1501',
      districtCode: '150131',
      address: 'Av. Conquistadores 456',
      reference: 'Dpto 302',
      shippingZone: 'lima_metropolitana',
    );

    final tSession = CheckoutSession(
      id: 'session-123',
      items: const [],
      clearCartOnSuccess: true,
      createdAt: DateTime(2023, 1, 1),
    );

    test('supports value equality', () {
      final state1 = CheckoutState(
        customerInfo: tCustomer,
        shippingAddress: tAddress,
        paymentMethodId: 'yape',
        session: tSession,
      );

      final state2 = CheckoutState(
        customerInfo: tCustomer,
        shippingAddress: tAddress,
        paymentMethodId: 'yape',
        session: tSession,
      );

      expect(state1, equals(state2));
    });

    test('has default values when instantiated with no arguments', () {
      const state = CheckoutState();

      expect(state.customerInfo, isNull);
      expect(state.shippingAddress, isNull);
      expect(state.paymentMethodId, isNull);
      expect(state.session, isNull);
    });

    test('copyWith creates a new instance with updated properties', () {
      const state = CheckoutState();

      final updated = state.copyWith(
        customerInfo: tCustomer,
        shippingAddress: tAddress,
        paymentMethodId: 'culqi',
        session: tSession,
      );

      expect(updated.customerInfo, equals(tCustomer));
      expect(updated.shippingAddress, equals(tAddress));
      expect(updated.paymentMethodId, equals('culqi'));
      expect(updated.session, equals(tSession));
    });

    test(
      'copyWith returns identical instance when no arguments are passed',
      () {
        final state = CheckoutState(
          customerInfo: tCustomer,
          shippingAddress: tAddress,
          paymentMethodId: 'yape',
          session: tSession,
        );

        final copy = state.copyWith();

        expect(copy, equals(state));
      },
    );
  });
}
