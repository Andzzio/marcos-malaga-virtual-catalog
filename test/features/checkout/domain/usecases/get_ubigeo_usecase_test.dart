import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/ubigeo_entities.dart';
import 'package:marcos_malaga_app/features/checkout/domain/repositories/checkout_config_repository.dart';
import 'package:marcos_malaga_app/features/checkout/domain/usecases/get_ubigeo_usecase.dart';

class MockCheckoutConfigRepository extends Mock
    implements CheckoutConfigRepository {}

void main() {
  late MockCheckoutConfigRepository mockRepository;
  late GetUbigeoUseCase useCase;

  setUp(() {
    mockRepository = MockCheckoutConfigRepository();
    useCase = GetUbigeoUseCase(mockRepository);
  });

  const tUbigeo = UbigeoEntity(
    departments: [],
  );

  test('should get ubigeo from repository', () async {
    when(() => mockRepository.getUbigeo())
        .thenAnswer((_) async => tUbigeo);

    final result = await useCase();

    expect(result, tUbigeo);
    verify(() => mockRepository.getUbigeo()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
