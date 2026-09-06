import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/checkout_session.dart';
import 'package:marcos_malaga_app/features/checkout/domain/repositories/checkout_session_repository.dart';
import 'package:marcos_malaga_app/features/checkout/domain/usecases/get_checkout_session_usecase.dart';

class MockCheckoutSessionRepository extends Mock
    implements CheckoutSessionRepository {}

void main() {
  late MockCheckoutSessionRepository mockRepository;
  late GetCheckoutSessionUseCase useCase;

  final tSession = CheckoutSession(
    id: 'cs_123',
    items: const [],
    clearCartOnSuccess: false,
    createdAt: DateTime(2026, 1, 1),
  );

  setUp(() {
    mockRepository = MockCheckoutSessionRepository();
    useCase = GetCheckoutSessionUseCase(mockRepository);
  });

  test('should call repository.getSession with correct id', () async {
    when(
      () => mockRepository.getSession('cs_123'),
    ).thenAnswer((_) async => tSession);

    final result = await useCase('cs_123');

    expect(result, equals(tSession));
    verify(() => mockRepository.getSession('cs_123')).called(1);
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return null when repository returns null', () async {
    when(
      () => mockRepository.getSession('cs_not_found'),
    ).thenAnswer((_) async => null);

    final result = await useCase('cs_not_found');

    expect(result, isNull);
    verify(() => mockRepository.getSession('cs_not_found')).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
