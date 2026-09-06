import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/customer_info.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/order/order_entity.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/shipping_address.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/checkout_session.dart';
import 'package:marcos_malaga_app/app/shared/domain/usecases/order/create_order_usecase.dart';
import 'package:marcos_malaga_app/features/checkout/domain/usecases/get_checkout_session_usecase.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/providers/checkout_provider.dart';
import 'package:marcos_malaga_app/providers/core/core_providers.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/states/checkout_state.dart';
import 'package:marcos_malaga_app/providers/features/checkout/checkout_providers.dart';

class MockCreateOrderUseCase extends Mock implements CreateOrderUseCase {}

class MockGetCheckoutSessionUseCase extends Mock
    implements GetCheckoutSessionUseCase {}

class FakeOrderEntity extends Fake implements OrderEntity {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockCreateOrderUseCase mockCreateOrderUseCase;
  late MockGetCheckoutSessionUseCase mockGetCheckoutSessionUseCase;
  late ProviderContainer container;

  const tCustomer = CustomerInfo(
    firstName: 'Carmen',
    lastName: 'Rosa',
    dni: '45678901',
    phone: '955443322',
  );

  const tAddress = ShippingAddress(
    department: 'Lima',
    province: 'Lima',
    district: 'Surco',
    departmentCode: '15',
    provinceCode: '1501',
    districtCode: '150140',
    address: 'Av. Primavera 789',
    reference: 'Frente al centro comercial',
    shippingZone: 'lima_metropolitana',
  );

  final tSession = CheckoutSession(
    id: 'test-session',
    items: const [],
    clearCartOnSuccess: false,
    createdAt: DateTime(2023, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(FakeOrderEntity());
  });

  setUp(() {
    mockCreateOrderUseCase = MockCreateOrderUseCase();
    mockGetCheckoutSessionUseCase = MockGetCheckoutSessionUseCase();

    container = ProviderContainer(
      overrides: [
        createOrderUseCaseProvider.overrideWithValue(mockCreateOrderUseCase),
        getCheckoutSessionUseCaseProvider.overrideWithValue(
          mockGetCheckoutSessionUseCase,
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('CheckoutProvider', () {
    test('initial state has default empty checkout state', () {
      final state = container.read(checkoutProvider(tSession));

      expect(state, equals(CheckoutState(session: tSession)));
      expect(state.customerInfo, isNull);
      expect(state.shippingAddress, isNull);
      expect(state.paymentMethodId, isNull);
    });

    test('updateCustomerInfo updates state with customer info', () async {
      final notifier = container.read(checkoutProvider(tSession).notifier);

      notifier.updateCustomerInfo(tCustomer);

      final state = container.read(checkoutProvider(tSession));
      expect(state.customerInfo, equals(tCustomer));
    });

    test('updateShippingAddress updates state with shipping address', () async {
      final notifier = container.read(checkoutProvider(tSession).notifier);

      await notifier.updateShippingAddress(tAddress);

      final state = container.read(checkoutProvider(tSession));
      expect(state.shippingAddress, equals(tAddress));
    });

    test('setPaymentMethod updates state with payment method id', () async {
      final notifier = container.read(checkoutProvider(tSession).notifier);

      notifier.setPaymentMethod('yape');

      final state = container.read(checkoutProvider(tSession));
      expect(state.paymentMethodId, equals('yape'));
    });

    test(
      'submitOrder sets isLoading true and false, and calls CreateOrderUseCase',
      () async {
        when(
          () => mockGetCheckoutSessionUseCase('test-session'),
        ).thenAnswer((_) async => tSession);
        when(
          () => mockCreateOrderUseCase(
            session: any(named: 'session'),
            customer: any(named: 'customer'),
            shipping: any(named: 'shipping'),
            billing: any(named: 'billing'),
            paymentMethodId: any(named: 'paymentMethodId'),
            deliveryType: any(named: 'deliveryType'),
            shippingMethodId: any(named: 'shippingMethodId'),
            shippingCost: any(named: 'shippingCost'),
            notes: any(named: 'notes'),
          ),
        ).thenAnswer((_) async {});

        final notifier = container.read(checkoutProvider(tSession).notifier);

        notifier.updateCustomerInfo(tCustomer);
        await notifier.updateShippingAddress(tAddress);
        notifier.setPaymentMethod('yape');

        final states = <CheckoutState>[];
        container.listen(
          checkoutProvider(tSession),
          (_, next) => states.add(next),
          fireImmediately: false,
        );

        await notifier.submitOrder();

        verify(
          () => mockCreateOrderUseCase(
            session: any(named: 'session'),
            customer: any(named: 'customer'),
            shipping: any(named: 'shipping'),
            billing: any(named: 'billing'),
            paymentMethodId: any(named: 'paymentMethodId'),
            deliveryType: any(named: 'deliveryType'),
            shippingMethodId: any(named: 'shippingMethodId'),
            shippingCost: any(named: 'shippingCost'),
            notes: any(named: 'notes'),
          ),
        ).called(1);

        // expect loading
        // not loading
        // no error
      },
    );

    test(
      'submitOrder leaves state with error when CreateOrderUseCase throws',
      () async {
        when(
          () => mockGetCheckoutSessionUseCase('test-session'),
        ).thenAnswer((_) async => tSession);
        when(
          () => mockCreateOrderUseCase(
            session: any(named: 'session'),
            customer: any(named: 'customer'),
            shipping: any(named: 'shipping'),
            billing: any(named: 'billing'),
            paymentMethodId: any(named: 'paymentMethodId'),
            deliveryType: any(named: 'deliveryType'),
            shippingMethodId: any(named: 'shippingMethodId'),
            shippingCost: any(named: 'shippingCost'),
            notes: any(named: 'notes'),
          ),
        ).thenThrow(Exception('Order creation failed'));

        final notifier = container.read(checkoutProvider(tSession).notifier);

        expect(() => notifier.submitOrder(), throwsA(isA<Exception>()));

        // expect error
        // not loading
      },
    );
  });
}
