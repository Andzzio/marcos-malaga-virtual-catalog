import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/customer_info.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/order/order_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/order/order_item.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/order/order_status.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/shipping_address.dart';

void main() {
  group('OrderEntity', () {
    const tCustomer = CustomerInfo(
      firstName: 'Ana',
      lastName: 'Pérez',
      dni: '12345678',
      phone: '987654321',
    );

    const tShipping = ShippingAddress(
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

    const tOrderItem = OrderItem(
      productId: 'prod-001',
      designId: 'des-001',
      sizeName: 'M',
      quantity: 2,
      productName: 'Vestido Floral',
      designName: 'Rojo Carmesí',
      imageUrl: 'https://example.com/img.jpg',
      unitPrice: 89.90,
    );

    final tCreatedAt = DateTime.parse('2026-08-18T10:00:00.000Z');

    final tOrder = OrderEntity(
      id: 'ord-001',
      orderCode: '#ORD-12345',
      customer: tCustomer,
      shipping: tShipping,
      items: const [tOrderItem],
      subtotal: 179.80,
      shippingCost: 10.00,
      total: 189.80,
      paymentMethodId: 'yape',
      shippingMethodId: 'olva',
      status: OrderStatus.pending,
      deliveryType: DeliveryType.shipping,
      createdAt: tCreatedAt,
      notes: 'Entregar por la tarde',
    );

    test('supports value equality', () {
      final order1 = OrderEntity(
        id: 'ord-001',
        orderCode: '#ORD-12345',
        customer: tCustomer,
        shipping: tShipping,
        items: const [tOrderItem],
        subtotal: 179.80,
        shippingCost: 10.00,
        total: 189.80,
        paymentMethodId: 'yape',
        shippingMethodId: 'olva',
        status: OrderStatus.pending,
        deliveryType: DeliveryType.shipping,
        createdAt: tCreatedAt,
        notes: 'Entregar por la tarde',
      );

      final order2 = OrderEntity(
        id: 'ord-001',
        orderCode: '#ORD-12345',
        customer: tCustomer,
        shipping: tShipping,
        items: const [tOrderItem],
        subtotal: 179.80,
        shippingCost: 10.00,
        total: 189.80,
        paymentMethodId: 'yape',
        shippingMethodId: 'olva',
        status: OrderStatus.pending,
        deliveryType: DeliveryType.shipping,
        createdAt: tCreatedAt,
        notes: 'Entregar por la tarde',
      );

      expect(order1, equals(order2));
      expect(order1.props, equals(order2.props));
    });

    test('copyWith creates a new instance with updated properties', () {
      final updated = tOrder.copyWith(
        status: OrderStatus.confirmed,
        notes: 'Entregar en conserjería',
      );

      expect(updated.id, 'ord-001');
      expect(updated.orderCode, '#ORD-12345');
      expect(updated.customer, tCustomer);
      expect(updated.shipping, tShipping);
      expect(updated.items, const [tOrderItem]);
      expect(updated.subtotal, 179.80);
      expect(updated.shippingCost, 10.00);
      expect(updated.total, 189.80);
      expect(updated.paymentMethodId, 'yape');
      expect(updated.shippingMethodId, 'olva');
      expect(updated.status, OrderStatus.confirmed);
      expect(updated.createdAt, tCreatedAt);
      expect(updated.notes, 'Entregar en conserjería');
      expect(updated, isNot(equals(tOrder)));
    });

    test(
      'copyWith returns identical instance when no arguments are passed',
      () {
        final updated = tOrder.copyWith();

        expect(updated, equals(tOrder));
      },
    );

    test('OrderStatus enum has all required values', () {
      expect(
        OrderStatus.values,
        containsAll([
          OrderStatus.pending,
          OrderStatus.confirmed,
          OrderStatus.shipped,
          OrderStatus.delivered,
          OrderStatus.cancelled,
        ]),
      );
    });
  });
}
