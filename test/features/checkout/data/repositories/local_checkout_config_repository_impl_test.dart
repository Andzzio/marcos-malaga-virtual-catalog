import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/features/checkout/data/datasources/local_checkout_config_datasource.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/checkout_config_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/department_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/district_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/payment_method_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/province_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/shipping_method_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/shipping_zone_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/ubigeo_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/repositories/local_checkout_config_repository_impl.dart';

class MockLocalCheckoutConfigDatasource extends Mock
    implements LocalCheckoutConfigDatasource {}

void main() {
  late MockLocalCheckoutConfigDatasource mockDatasource;
  late LocalCheckoutConfigRepositoryImpl repository;

  setUp(() {
    mockDatasource = MockLocalCheckoutConfigDatasource();
    repository = LocalCheckoutConfigRepositoryImpl(mockDatasource);
  });

  group('LocalCheckoutConfigRepositoryImpl', () {
    test('getUbigeo should return UbigeoModel from datasource', () async {
      const tUbigeo = UbigeoModel(
        departments: [DepartmentModel(code: '15', name: 'Lima')],
        provinces: [
          ProvinceModel(code: '1501', name: 'Lima', departmentCode: '15'),
        ],
        districts: [
          DistrictModel(code: '150101', name: 'Lima', provinceCode: '1501'),
        ],
      );

      when(() => mockDatasource.getUbigeo()).thenAnswer((_) async => tUbigeo);

      final result = await repository.getUbigeo();

      expect(result, equals(tUbigeo.toEntity()));
      verify(() => mockDatasource.getUbigeo()).called(1);
    });

    test(
      'getCheckoutConfig should return CheckoutConfigModel from datasource',
      () async {
        const tConfig = CheckoutConfigModel(
          shippingZones: [
            ShippingZoneModel(
              id: 'zone-1',
              name: 'Lima',
              departmentCodes: ['15'],
            ),
          ],
          shippingMethods: [
            ShippingMethodModel(
              id: 'reg',
              label: 'Regular',
              enabled: true,
              availableZones: ['zone-1'],
              prices: {'zone-1': 10.0},
              estimatedDays: '2 días',
              description: 'Envío Regular',
            ),
          ],
          paymentMethods: [
            PaymentMethodModel(
              id: 'yape',
              label: 'Yape',
              enabled: true,
              type: 'wallet',
              instructions: 'Paga',
              details: {},
            ),
          ],
        );

        when(
          () => mockDatasource.getCheckoutConfig(),
        ).thenAnswer((_) async => tConfig);

        final result = await repository.getCheckoutConfig();

        expect(result, equals(tConfig.toEntity()));
        verify(() => mockDatasource.getCheckoutConfig()).called(1);
      },
    );
  });
}
