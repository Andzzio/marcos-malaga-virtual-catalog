import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/customer_info_model.dart';
import 'package:marcos_malaga_app/app/shared/data/models/order/order_item_model.dart';
import 'package:marcos_malaga_app/app/shared/data/models/order/order_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/shipping_address_model.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/customer_info.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/order/order_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/order/order_item.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/order/order_status.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/shipping_address.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/billing_address_model.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/billing_address.dart';

void main() {
  const tCustomerModel = CustomerInfoModel(
    firstName: 'Ana',
    lastName: 'Pérez',
    dni: '12345678',
    phone: '987654321',
  );

  const tShippingModel = ShippingAddressModel(
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

  const tOrderItemModel = OrderItemModel(
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

  const tBillingModel = BillingAddressModel(
    country: 'PE',
    firstName: 'Ana',
    lastName: 'Pérez',
    dni: '12345678',
    address: 'Av. Larco 123',
    department: 'Lima',
    province: 'Lima',
    district: 'Miraflores',
    phone: '987654321',
  );

  final tOrderModel = OrderModel(
    id: 'ord-001',
    orderCode: '#ORD-12345',
    customer: tCustomerModel,
    shipping: tShippingModel,
    billing: tBillingModel,
    items: const [tOrderItemModel],
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

  final tOrderEntity = OrderEntity(
    id: 'ord-001',
    orderCode: '#ORD-12345',
    customer: const CustomerInfo(
      firstName: 'Ana',
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
      districtCode: '150122',
      address: 'Av. Larco 123',
      reference: 'Frente al parque',
      shippingZone: 'LIMA_METROPOLITANA',
    ),
    billing: const BillingAddress(
      country: 'PE',
      firstName: 'Ana',
      lastName: 'Pérez',
      dni: '12345678',
      address: 'Av. Larco 123',
      department: 'Lima',
      province: 'Lima',
      district: 'Miraflores',
      phone: '987654321',
    ),
    items: const [
      OrderItem(
        productId: 'prod-001',
        designId: 'des-001',
        sizeName: 'M',
        quantity: 2,
        productName: 'Vestido Floral',
        designName: 'Rojo Carmesí',
        imageUrl: 'https://example.com/img.jpg',
        unitPrice: 89.90,
      ),
    ],
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

  final tJson = {
    'id': 'ord-001',
    'orderCode': '#ORD-12345',
    'customer': {
      'firstName': 'Ana',
      'lastName': 'Pérez',
      'dni': '12345678',
      'phone': '987654321',
    },
    'shipping': {
      'department': 'Lima',
      'province': 'Lima',
      'district': 'Miraflores',
      'departmentCode': '15',
      'provinceCode': '1501',
      'districtCode': '150122',
      'address': 'Av. Larco 123',
      'reference': 'Frente al parque',
      'shippingZone': 'LIMA_METROPOLITANA',
    },
    'billing': {
      'country': 'PE',
      'firstName': 'Ana',
      'lastName': 'Pérez',
      'dni': '12345678',
      'address': 'Av. Larco 123',
      'department': 'Lima',
      'province': 'Lima',
      'district': 'Miraflores',
      'phone': '987654321',
    },
    'items': [
      {
        'productId': 'prod-001',
        'designId': 'des-001',
        'sizeName': 'M',
        'quantity': 2,
        'productName': 'Vestido Floral',
        'designName': 'Rojo Carmesí',
        'imageUrl': 'https://example.com/img.jpg',
        'unitPrice': 89.90,
        'discountPrice': null,
      },
    ],
    'subtotal': 179.80,
    'shippingCost': 10.00,
    'total': 189.80,
    'paymentMethodId': 'yape',
    'shippingMethodId': 'olva',
    'status': 'pending',
    'deliveryType': 'shipping',
    'createdAt': '2026-08-18T10:00:00.000Z',
    'notes': 'Entregar por la tarde',
  };

  group('OrderModel', () {
    test('fromJson returns a valid model from JSON map', () {
      final result = OrderModel.fromJson(tJson);
      expect(result, equals(tOrderModel));
    });

    test('toJson returns a JSON map containing the proper data', () {
      final result = tOrderModel.toJson();
      expect(result, equals(tJson));
    });

    test('bidirectional serialization preserves equality', () {
      final json = tOrderModel.toJson();
      final fromJson = OrderModel.fromJson(json);
      expect(fromJson, equals(tOrderModel));
    });

    test('fromEntity converts entity to model correctly', () {
      final result = OrderModel.fromEntity(tOrderEntity);
      expect(result, equals(tOrderModel));
    });

    test('toEntity converts model to entity correctly', () {
      final result = tOrderModel.toEntity();
      expect(result, equals(tOrderEntity));
    });

    test('fromJson handles fallback for invalid status', () {
      final invalidStatusJson = Map<String, dynamic>.from(tJson)
        ..['status'] = 'unknown_status';
      final result = OrderModel.fromJson(invalidStatusJson);
      expect(result.status, OrderStatus.pending);
    });

    test('copyWith creates a new instance with updated properties', () {
      final updated = tOrderModel.copyWith(
        status: OrderStatus.confirmed,
        total: 200.0,
      );
      expect(updated.status, OrderStatus.confirmed);
      expect(updated.total, 200.0);
      expect(updated.id, tOrderModel.id);
    });
  });
}
