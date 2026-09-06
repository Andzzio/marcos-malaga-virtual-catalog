import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/app/shared/data/datasources/order/local_order_datasource.dart';
import 'package:marcos_malaga_app/app/shared/data/models/order/order_model.dart';
import 'package:marcos_malaga_app/app/shared/data/repositories/order/local_order_repository_impl.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/customer_info.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/order/order_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/order/order_item.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/order/order_status.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/shipping_address.dart';

class MockLocalOrderDatasource extends Mock implements LocalOrderDatasource {}

class FakeOrderModel extends Fake implements OrderModel {}

void main() {
  late MockLocalOrderDatasource mockDatasource;
  late LocalOrderRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(FakeOrderModel());
  });

  setUp(() {
    mockDatasource = MockLocalOrderDatasource();
    repository = LocalOrderRepositoryImpl(mockDatasource);
  });

  group('LocalOrderRepositoryImpl', () {
    final tOrderEntity = OrderEntity(
      id: 'ord-001',
      orderCode: 'MM-2026-0001',
      customer: const CustomerInfo(
        firstName: 'María',
        lastName: 'Pérez',
        dni: '12345678',
        phone: '987654321',
      ),
      shipping: const ShippingAddress(
        department: 'Lima',
        province: 'Lima',
        district: 'Miraflores',
        departmentCode: '15',
        provinceCode: '1501',
        districtCode: '150101',
        address: 'Av. Larco 123',
        reference: 'Frente al parque',
        shippingZone: 'zone-lima',
      ),
      items: const [
        OrderItem(
          productId: 'PROD-001',
          designId: 'des-01',
          sizeName: 'M',
          quantity: 1,
          productName: 'Vestido Floreado',
          designName: 'Floral',
          imageUrl: 'https://example.com/img.png',
          unitPrice: 120.0,
        ),
      ],
      subtotal: 120.0,
      shippingCost: 10.0,
      total: 130.0,
      paymentMethodId: 'yape-plin',
      shippingMethodId: 'regular',
      status: OrderStatus.pending,
      deliveryType: DeliveryType.shipping,
      createdAt: DateTime(2026, 8, 18, 20, 0, 0),
      notes: 'Entregar de tarde',
    );

    test(
      'createOrder should convert OrderEntity to OrderModel and call datasource.saveOrder',
      () async {
        when(() => mockDatasource.saveOrder(any())).thenAnswer((_) async {});

        await repository.createOrder(tOrderEntity);

        final captured = verify(
          () => mockDatasource.saveOrder(captureAny()),
        ).captured;
        expect(captured.length, 1);
        final savedOrder = captured.first as OrderModel;
        expect(savedOrder.id, 'ord-001');
        expect(savedOrder.orderCode, 'MM-2026-0001');
        expect(savedOrder.customer.firstName, 'María');
        expect(savedOrder.customer.lastName, 'Pérez');
        expect(savedOrder.shipping?.address, 'Av. Larco 123');
        expect(savedOrder.items.first.productId, 'PROD-001');
        expect(savedOrder.total, 130.0);
      },
    );
  });
}
