import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/checkout_config_entity.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/ubigeo_entities.dart';
import 'package:marcos_malaga_app/features/checkout/domain/usecases/get_checkout_config_usecase.dart';
import 'package:marcos_malaga_app/features/checkout/domain/usecases/get_ubigeo_usecase.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/providers/checkout_config_provider.dart';
import 'package:marcos_malaga_app/providers/features/checkout/checkout_providers.dart';

class MockGetCheckoutConfigUseCase extends Mock
    implements GetCheckoutConfigUseCase {}

class MockGetUbigeoUseCase extends Mock implements GetUbigeoUseCase {}

void main() {
  late MockGetCheckoutConfigUseCase mockGetCheckoutConfig;
  late MockGetUbigeoUseCase mockGetUbigeo;
  late ProviderContainer container;

  const tConfig = CheckoutConfigEntity(
    shippingZones: [],
    shippingMethods: [],
    paymentMethods: [],
  );

  const tUbigeo = UbigeoEntity(
    departments: [],
  );

  setUp(() {
    mockGetCheckoutConfig = MockGetCheckoutConfigUseCase();
    mockGetUbigeo = MockGetUbigeoUseCase();

    container = ProviderContainer(
      overrides: [
        getCheckoutConfigUseCaseProvider
            .overrideWithValue(mockGetCheckoutConfig),
        getUbigeoUseCaseProvider.overrideWithValue(mockGetUbigeo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('should return combined checkout config and ubigeo record', () async {
    when(() => mockGetCheckoutConfig()).thenAnswer((_) async => tConfig);
    when(() => mockGetUbigeo()).thenAnswer((_) async => tUbigeo);

    final result = await container.read(checkoutConfigProvider.future);

    expect(result.config, equals(tConfig));
    expect(result.ubigeo, equals(tUbigeo));
    verify(() => mockGetCheckoutConfig()).called(1);
    verify(() => mockGetUbigeo()).called(1);
  });
}
