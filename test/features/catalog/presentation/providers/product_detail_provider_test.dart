import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_design_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_size_entity.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/providers/product_detail_provider.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/checkout_session.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/order_item.dart';
import 'package:marcos_malaga_app/features/checkout/domain/usecases/create_checkout_session_usecase.dart';
import 'package:marcos_malaga_app/providers/features/checkout/checkout_providers.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateCheckoutSessionUseCase extends Mock
    implements CreateCheckoutSessionUseCase {}

void main() {
  late MockCreateCheckoutSessionUseCase mockCreateCheckoutSessionUseCase;

  final tProduct = ProductEntity(
    id: 'prod-2',
    name: 'Vestido Fiesta',
    description: 'Hermoso vestido',
    basePrice: 120.0,
    discountPrice: 99.0,
    categoryIds: const ['cat-2'],
    isVisible: true,
    createdAt: DateTime.now(),
    designs: const [
      ProductDesignEntity(
        id: 'des-blue',
        name: 'Azul Noche',
        imageUrls: ['https://example.com/blue.jpg'],
        sizes: [
          ProductSizeEntity(size: 'S', stock: 3),
          ProductSizeEntity(size: 'M', stock: 5),
        ],
      ),
      ProductDesignEntity(
        id: 'des-red',
        name: 'Rojo Pasión',
        imageUrls: ['https://example.com/red.jpg'],
        sizes: [
          ProductSizeEntity(size: 'L', stock: 0),
        ],
      ),
    ],
    deletedAt: null,
  );

  setUp(() {
    mockCreateCheckoutSessionUseCase = MockCreateCheckoutSessionUseCase();
  });

  Widget buildTestWidget({
    required List<dynamic> overrides,
    required Widget Function(BuildContext context, WidgetRef ref) builder,
  }) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Consumer(
            builder: (ctx, ref, _) => builder(ctx, ref),
          ),
        ),
        GoRoute(
          path: '/checkout/:sessionId',
          builder: (context, state) =>
              Text('Checkout ${state.pathParameters['sessionId']}'),
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        for (final o in overrides) o as dynamic,
      ],
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }

  group('ProductDetailProvider', () {
    test('initial state and selection updates correctly', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = container.read(productDetailProvider(tProduct));
      expect(state.product, equals(tProduct));
      expect(state.quantity, equals(1));
      expect(state.selectedDesignIndex, equals(0));
      expect(state.selectedSizeIndex, equals(0));

      final notifier =
          container.read(productDetailProvider(tProduct).notifier);
      notifier.selectSize(1);
      expect(
          container.read(productDetailProvider(tProduct)).selectedSizeIndex, 1);

      notifier.selectQuantity(4);
      expect(container.read(productDetailProvider(tProduct)).quantity, 4);

      notifier.selectDesign(1);
      // Selected design 1 has 0 stock in its only size, so quantity becomes 0
      expect(container.read(productDetailProvider(tProduct)).quantity, 0);
    });

    testWidgets('buyNow creates session and navigates to checkout',
        (tester) async {
      final tSession = CheckoutSession(
        id: 'session-buy-now',
        items: const [
          OrderItem(
            productId: 'prod-2',
            designId: 'des-blue',
            sizeName: 'S',
            quantity: 2,
            productName: 'Vestido Fiesta',
            designName: 'Azul Noche',
            imageUrl: 'https://example.com/blue.jpg',
            unitPrice: 99.0,
            discountPrice: 99.0,
          ),
        ],
        clearCartOnSuccess: false,
        createdAt: DateTime.now(),
      );

      when(() => mockCreateCheckoutSessionUseCase.call(
            items: any(named: 'items'),
            clearCartOnSuccess: any(named: 'clearCartOnSuccess'),
          )).thenAnswer((_) async => tSession);

      await tester.pumpWidget(
        buildTestWidget(
          overrides: [
            createCheckoutSessionUseCaseProvider
                .overrideWithValue(mockCreateCheckoutSessionUseCase),
          ],
          builder: (context, ref) {
            final state = ref.watch(productDetailProvider(tProduct));
            final notifier =
                ref.read(productDetailProvider(tProduct).notifier);
            return Column(
              children: [
                Text('Qty: ${state.quantity}'),
                ElevatedButton(
                  onPressed: () {
                    notifier.selectQuantity(2);
                  },
                  child: const Text('Set Qty 2'),
                ),
                ElevatedButton(
                  onPressed: () {
                    notifier.buyNow(context);
                  },
                  child: const Text('Buy Now Button'),
                ),
              ],
            );
          },
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Set Qty 2'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Buy Now Button'));
      await tester.pumpAndSettle();

      verify(() => mockCreateCheckoutSessionUseCase.call(
            items: any(
              named: 'items',
              that: isA<List<OrderItem>>().having(
                (l) => l.first.productId,
                'productId',
                'prod-2',
              ),
            ),
            clearCartOnSuccess: false,
          )).called(1);

      expect(find.text('Checkout session-buy-now'), findsOneWidget);
    });

    testWidgets('buyNow does nothing when quantity is 0', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          overrides: [
            createCheckoutSessionUseCaseProvider
                .overrideWithValue(mockCreateCheckoutSessionUseCase),
          ],
          builder: (context, ref) {
            final state = ref.watch(productDetailProvider(tProduct));
            final notifier =
                ref.read(productDetailProvider(tProduct).notifier);
            return Column(
              children: [
                Text('Stock: ${state.selectedSize.stock}'),
                ElevatedButton(
                  onPressed: () {
                    notifier.selectDesign(1); // has 0 stock
                  },
                  child: const Text('Select Out of Stock'),
                ),
                ElevatedButton(
                  onPressed: () {
                    notifier.buyNow(context);
                  },
                  child: const Text('Buy Now Button'),
                ),
              ],
            );
          },
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Select Out of Stock'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Buy Now Button'));
      await tester.pumpAndSettle();

      verifyNever(() => mockCreateCheckoutSessionUseCase.call(
            items: any(named: 'items'),
            clearCartOnSuccess: any(named: 'clearCartOnSuccess'),
          ));

      expect(find.text('Buy Now Button'), findsOneWidget);
    });
  });
}
