import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marcos_malaga_app/features/checkout/data/datasources/local_order_datasource.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/customer_info_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/order_item_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/order_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/shipping_address_model.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/order_status.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/order_entity.dart';

void main() {
  late SharedPreferences prefs;
  late LocalOrderDatasource datasource;

  final tOrder = OrderModel(
    id: 'ord-001',
    orderCode: 'MM-2026-0001',
    customer: const CustomerInfoModel(
      firstName: 'María',
      lastName: 'Pérez',
      dni: '12345678',
      phone: '987654321',
          ),
    shipping: const ShippingAddressModel(
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
      OrderItemModel(
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

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    datasource = LocalOrderDatasource(prefs: prefs);
  });

  group('LocalOrderDatasource', () {
    group('getOrders', () {
      test('should return empty list when no orders exist', () async {
        final result = await datasource.getOrders();
        expect(result, isEmpty);
      });

      test(
        'should return list of orders when data exists in SharedPreferences',
        () async {
          final ordersJson = [tOrder.toJson()];
          await prefs.setString('local_orders', jsonEncode(ordersJson));

          final result = await datasource.getOrders();

          expect(result.length, 1);
          expect(result.first.id, 'ord-001');
          expect(result.first.orderCode, 'MM-2026-0001');
        },
      );

      test(
        'should return empty list when json in SharedPreferences is invalid',
        () async {
          await prefs.setString('local_orders', 'invalid json string');

          final result = await datasource.getOrders();

          expect(result, isEmpty);
        },
      );
    });

    group('saveOrder', () {
      test('should save order to empty SharedPreferences', () async {
        await datasource.saveOrder(tOrder);

        final storedString = prefs.getString('local_orders');
        expect(storedString, isNotNull);

        final decodedList = jsonDecode(storedString!) as List<dynamic>;
        expect(decodedList.length, 1);
        expect(decodedList.first['id'], 'ord-001');
      });

      test(
        'should append order when existing orders are in SharedPreferences',
        () async {
          await datasource.saveOrder(tOrder);

          final secondOrder = tOrder.copyWith(
            id: 'ord-002',
            orderCode: 'MM-2026-0002',
          );
          await datasource.saveOrder(secondOrder);

          final storedString = prefs.getString('local_orders');
          final decodedList = jsonDecode(storedString!) as List<dynamic>;
          expect(decodedList.length, 2);
          expect(decodedList[0]['id'], 'ord-001');
          expect(decodedList[1]['id'], 'ord-002');
        },
      );

      test(
        'should overwrite corrupted data with fresh list containing the order',
        () async {
          await prefs.setString('local_orders', 'corrupted_json');

          await datasource.saveOrder(tOrder);

          final storedString = prefs.getString('local_orders');
          final decodedList = jsonDecode(storedString!) as List<dynamic>;
          expect(decodedList.length, 1);
          expect(decodedList.first['id'], 'ord-001');
        },
      );
    });
  });
}
