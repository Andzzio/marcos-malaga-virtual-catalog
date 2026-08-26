import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/customer_info.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/order_entity.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/order_status.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/shipping_address.dart';
import 'package:marcos_malaga_app/features/checkout/domain/repositories/order_repository.dart';
import 'package:marcos_malaga_app/features/checkout/domain/usecases/create_order_usecase.dart';

class MockOrderRepository extends Mock implements OrderRepository {}

class FakeOrderEntity extends Fake implements OrderEntity {}

void main() {
  late MockOrderRepository mockRepository;
  late CreateOrderUseCase useCase;

  final tOrder = OrderEntity(
    id: 'ord_1',
    orderCode: 'ORD-12345',
    customer: const CustomerInfo(
      firstName: 'María',
      lastName: 'López',
      dni: '12345678',
      phone: '987654321',
          ),
    shipping: const ShippingAddress(
      department: 'Lima',
      province: 'Lima',
      district: 'Miraflores',
      departmentCode: '15',
      provinceCode: '1501',
      districtCode: '150122',
      address: 'Av. Larco 123',
      reference: 'Frente al parque',
      shippingZone: 'lima_metropolitana',
    ),
    items: const [],
    subtotal: 100.0,
    shippingCost: 10.0,
    total: 110.0,
    paymentMethodId: 'yape',
    shippingMethodId: 'express',
    status: OrderStatus.pending,
      deliveryType: DeliveryType.shipping,
    createdAt: DateTime(2026, 1, 1),
  );

  setUpAll(() {
    registerFallbackValue(FakeOrderEntity());
  });

  setUp(() {
    mockRepository = MockOrderRepository();
    useCase = CreateOrderUseCase(mockRepository);
  });

  test('should call repository.createOrder with given order entity', () async {
    when(() => mockRepository.createOrder(any())).thenAnswer((_) async {});

    await useCase(customOrder: tOrder);

    verify(() => mockRepository.createOrder(tOrder)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
