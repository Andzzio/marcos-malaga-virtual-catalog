import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/checkout_config_entity.dart';
import 'package:marcos_malaga_app/features/checkout/domain/repositories/checkout_config_repository.dart';
import 'package:marcos_malaga_app/features/checkout/domain/usecases/get_checkout_config_usecase.dart';

class MockCheckoutConfigRepository extends Mock
    implements CheckoutConfigRepository {}

void main() {
  late MockCheckoutConfigRepository mockRepository;
  late GetCheckoutConfigUseCase useCase;

  setUp(() {
    mockRepository = MockCheckoutConfigRepository();
    useCase = GetCheckoutConfigUseCase(mockRepository);
  });

  const tConfig = CheckoutConfigEntity(
    shippingZones: [],
    shippingMethods: [],
    paymentMethods: [],
  );

  test('should get checkout config from repository', () async {
    when(
      () => mockRepository.getCheckoutConfig(),
    ).thenAnswer((_) async => tConfig);

    final result = await useCase();

    expect(result, tConfig);
    verify(() => mockRepository.getCheckoutConfig()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
