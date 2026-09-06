import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/checkout_session.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/order/order_item.dart';
import 'package:marcos_malaga_app/features/checkout/domain/repositories/checkout_session_repository.dart';
import 'package:marcos_malaga_app/features/checkout/domain/usecases/create_checkout_session_usecase.dart';

class MockCheckoutSessionRepository extends Mock
    implements CheckoutSessionRepository {}

void main() {
  late MockCheckoutSessionRepository mockRepository;
  late CreateCheckoutSessionUseCase useCase;

  final tSession = CheckoutSession(
    id: 'cs_123',
    items: const [
      OrderItem(
        productId: 'prod-1',
        designId: 'des-1',
        sizeName: 'M',
        quantity: 1,
        productName: 'Producto',
        designName: 'Diseño',
        imageUrl: 'http://example.com/img.png',
        unitPrice: 50.0,
      ),
    ],
    clearCartOnSuccess: true,
    createdAt: DateTime(2026, 1, 1),
  );

  setUp(() {
    mockRepository = MockCheckoutSessionRepository();
    useCase = CreateCheckoutSessionUseCase(mockRepository);
  });

  test(
    'should call repository.createSession with correct parameters',
    () async {
      when(
        () => mockRepository.createSession(
          items: any(named: 'items'),
          clearCartOnSuccess: any(named: 'clearCartOnSuccess'),
        ),
      ).thenAnswer((_) async => tSession);

      final result = await useCase(
        items: tSession.items,
        clearCartOnSuccess: true,
      );

      expect(result, equals(tSession));
      verify(
        () => mockRepository.createSession(
          items: tSession.items,
          clearCartOnSuccess: true,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
