import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/features/checkout/data/datasources/local_checkout_session_datasource.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/checkout_session_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/order_item_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/repositories/local_checkout_session_repository_impl.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/checkout_session.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/order_item.dart';

class MockLocalCheckoutSessionDatasource extends Mock
    implements LocalCheckoutSessionDatasource {}

void main() {
  late MockLocalCheckoutSessionDatasource mockDatasource;
  late LocalCheckoutSessionRepositoryImpl repository;

  const tOrderItem = OrderItem(
    productId: 'prod-001',
    designId: 'des-001',
    sizeName: 'M',
    quantity: 1,
    productName: 'Vestido Floreado',
    designName: 'Floral',
    imageUrl: 'https://example.com/img.png',
    unitPrice: 120.0,
  );

  const tOrderItemModel = OrderItemModel(
    productId: 'prod-001',
    designId: 'des-001',
    sizeName: 'M',
    quantity: 1,
    productName: 'Vestido Floreado',
    designName: 'Floral',
    imageUrl: 'https://example.com/img.png',
    unitPrice: 120.0,
  );

  final tSessionModel = CheckoutSessionModel(
    id: 'cs_001',
    items: const [tOrderItemModel],
    clearCartOnSuccess: true,
    createdAt: DateTime(2026, 8, 19, 20, 0, 0),
  );

  setUp(() {
    mockDatasource = MockLocalCheckoutSessionDatasource();
    repository = LocalCheckoutSessionRepositoryImpl(mockDatasource);
  });

  group('LocalCheckoutSessionRepositoryImpl', () {
    test(
      'createSession should delegate to datasource and return CheckoutSession entity',
      () async {
        when(
          () => mockDatasource.createSession(
            items: any(named: 'items'),
            clearCartOnSuccess: any(named: 'clearCartOnSuccess'),
          ),
        ).thenAnswer((_) async => tSessionModel);

        final result = await repository.createSession(
          items: const [tOrderItem],
          clearCartOnSuccess: true,
        );

        expect(result, isA<CheckoutSession>());
        expect(result.id, 'cs_001');
        expect(result.clearCartOnSuccess, isTrue);
        expect(result.items.first.productId, 'prod-001');
        verify(
          () => mockDatasource.createSession(
            items: const [tOrderItem],
            clearCartOnSuccess: true,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockDatasource);
      },
    );

    test(
      'getSession should return CheckoutSession entity when datasource returns model',
      () async {
        when(() => mockDatasource.getSession('cs_001'))
            .thenAnswer((_) async => tSessionModel);

        final result = await repository.getSession('cs_001');

        expect(result, isNotNull);
        expect(result!.id, 'cs_001');
        expect(result.clearCartOnSuccess, isTrue);
        verify(() => mockDatasource.getSession('cs_001')).called(1);
        verifyNoMoreInteractions(mockDatasource);
      },
    );

    test(
      'getSession should return null when datasource returns null',
      () async {
        when(() => mockDatasource.getSession('cs_not_found'))
            .thenAnswer((_) async => null);

        final result = await repository.getSession('cs_not_found');

        expect(result, isNull);
        verify(() => mockDatasource.getSession('cs_not_found')).called(1);
        verifyNoMoreInteractions(mockDatasource);
      },
    );

    test('deleteSession should delegate to datasource', () async {
      when(() => mockDatasource.deleteSession('cs_001'))
          .thenAnswer((_) async {});

      await repository.deleteSession('cs_001');

      verify(() => mockDatasource.deleteSession('cs_001')).called(1);
      verifyNoMoreInteractions(mockDatasource);
    });
  });
}
