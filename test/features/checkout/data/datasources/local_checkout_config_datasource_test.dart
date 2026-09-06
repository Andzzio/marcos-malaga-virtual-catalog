import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/features/checkout/data/datasources/local_checkout_config_datasource.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/checkout_config_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/ubigeo_model.dart';

class MockAssetBundle extends Mock implements AssetBundle {}

void main() {
  late MockAssetBundle mockAssetBundle;
  late LocalCheckoutConfigDatasource datasource;

  setUp(() {
    mockAssetBundle = MockAssetBundle();
    datasource = LocalCheckoutConfigDatasource(bundle: mockAssetBundle);
  });

  group('LocalCheckoutConfigDatasource', () {
    group('getUbigeo', () {
      final tUbigeoJson = {
        'departments': [
          {'code': '15', 'name': 'Lima'},
        ],
        'provinces': [
          {'code': '1501', 'name': 'Lima', 'departmentCode': '15'},
        ],
        'districts': [
          {'code': '150101', 'name': 'Lima', 'provinceCode': '1501'},
        ],
      };

      test(
        'should return valid UbigeoModel when asset loading succeeds',
        () async {
          when(
            () => mockAssetBundle.loadString('assets/json/ubigeo.json'),
          ).thenAnswer((_) async => jsonEncode(tUbigeoJson));

          final result = await datasource.getUbigeo();

          expect(result.departments.length, 1);
          expect(result.departments.first.name, 'Lima');
          expect(result.provinces.length, 1);
          expect(result.districts.length, 1);
        },
      );

      test(
        'should return empty UbigeoModel when asset loading throws exception',
        () async {
          when(
            () => mockAssetBundle.loadString('assets/json/ubigeo.json'),
          ).thenThrow(Exception('Asset not found'));

          final result = await datasource.getUbigeo();

          expect(result, equals(const UbigeoModel()));
        },
      );
    });

    group('getCheckoutConfig', () {
      final tConfigJson = {
        'shippingZones': [
          {
            'id': 'zone-lima',
            'name': 'Lima Metropolitana',
            'departmentCodes': ['15'],
            'freeShippingThreshold': 200.0,
          },
        ],
        'shippingMethods': [
          {
            'id': 'regular',
            'label': 'Envío Estándar',
            'enabled': true,
            'availableZones': ['zone-lima'],
            'prices': {'zone-lima': 10.0},
            'estimatedDays': '2 a 4 días',
          },
        ],
        'paymentMethods': [
          {
            'id': 'yape-plin',
            'label': 'Yape / Plin',
            'enabled': true,
            'type': 'digital_wallet',
            'instructions': 'Instrucciones...',
            'details': {'phone': '987654321'},
          },
        ],
      };

      test(
        'should return valid CheckoutConfigModel when asset loading succeeds',
        () async {
          when(
            () =>
                mockAssetBundle.loadString('assets/json/checkout_config.json'),
          ).thenAnswer((_) async => jsonEncode(tConfigJson));

          final result = await datasource.getCheckoutConfig();

          expect(result.shippingZones.length, 1);
          expect(result.shippingZones.first.name, 'Lima Metropolitana');
          expect(result.shippingMethods.length, 1);
          expect(result.paymentMethods.length, 1);
        },
      );

      test(
        'should return empty CheckoutConfigModel when asset loading throws exception',
        () async {
          when(
            () =>
                mockAssetBundle.loadString('assets/json/checkout_config.json'),
          ).thenThrow(Exception('Asset not found'));

          final result = await datasource.getCheckoutConfig();

          expect(result, equals(const CheckoutConfigModel()));
        },
      );
    });
  });
}
