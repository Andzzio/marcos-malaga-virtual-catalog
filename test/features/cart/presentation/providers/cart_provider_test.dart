import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_design_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_size_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/usecases/get_products_usecase.dart';
import 'package:marcos_malaga_app/features/cart/domain/entities/cart_entity.dart';
import 'package:marcos_malaga_app/features/cart/domain/entities/cart_item_entity.dart';
import 'package:marcos_malaga_app/features/cart/domain/usecases/get_cart_usecase.dart';
import 'package:marcos_malaga_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/checkout_session.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/order/order_item.dart';
import 'package:marcos_malaga_app/features/checkout/domain/usecases/create_checkout_session_usecase.dart';
import 'package:marcos_malaga_app/providers/core/core_providers.dart';
import 'package:marcos_malaga_app/providers/features/cart/cart_providers.dart';
import 'package:marcos_malaga_app/providers/features/checkout/checkout_providers.dart';
import 'package:mocktail/mocktail.dart';

class MockGetCartUseCase extends Mock implements GetCartUsecase {}

class MockGetProductsUseCase extends Mock implements GetProductsUsecase {}

class MockCreateCheckoutSessionUseCase extends Mock
    implements CreateCheckoutSessionUseCase {}

void main() {
  late MockGetCartUseCase mockGetCartUseCase;
  late MockGetProductsUseCase mockGetProductsUseCase;
  late MockCreateCheckoutSessionUseCase mockCreateCheckoutSessionUseCase;

  final tProduct = ProductEntity(
    id: 'prod-1',
    name: 'Vestido Elegante',
    description: 'Descripción',
    basePrice: 100.0,
    discountPrice: 80.0,
    categoryIds: const ['cat-1'],
    isVisible: true,
    createdAt: DateTime.now(),
    designs: const [
      ProductDesignEntity(
        id: 'des-1',
        name: 'Rojo Floral',
        imageUrls: ['https://example.com/img.jpg'],
        sizes: [ProductSizeEntity(size: 'M', stock: 5)],
      ),
    ],
    deletedAt: null,
  );

  const tCartItem = CartItemEntity(
    id: 'prod-1_des-1_M',
    productId: 'prod-1',
    designId: 'des-1',
    sizeName: 'M',
    quantity: 2,
  );

  setUp(() {
    mockGetCartUseCase = MockGetCartUseCase();
    mockGetProductsUseCase = MockGetProductsUseCase();
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
          builder: (context, state) =>
              Consumer(builder: (ctx, ref, _) => builder(ctx, ref)),
        ),
        GoRoute(
          path: '/checkout/:sessionId',
          builder: (context, state) =>
              Text('Checkout ${state.pathParameters['sessionId']}'),
        ),
      ],
    );

    return ProviderScope(
      overrides: [for (final o in overrides) o as dynamic],
      child: MaterialApp.router(routerConfig: router),
    );
  }

  group('CartProvider proceedToCheckout', () {
    testWidgets('creates checkout session and navigates when cart has items', (
      tester,
    ) async {
      when(
        () => mockGetCartUseCase(),
      ).thenAnswer((_) async => const CartEntity(items: [tCartItem]));
      when(() => mockGetProductsUseCase()).thenAnswer((_) async => [tProduct]);

      final tSession = CheckoutSession(
        id: 'session-xyz',
        items: const [
          OrderItem(
            productId: 'prod-1',
            designId: 'des-1',
            sizeName: 'M',
            quantity: 2,
            productName: 'Vestido Elegante',
            designName: 'Rojo Floral',
            imageUrl: 'https://example.com/img.jpg',
            unitPrice: 80.0,
            discountPrice: 80.0,
          ),
        ],
        clearCartOnSuccess: true,
        createdAt: DateTime.now(),
      );

      when(
        () => mockCreateCheckoutSessionUseCase.call(
          items: any(named: 'items'),
          clearCartOnSuccess: any(named: 'clearCartOnSuccess'),
        ),
      ).thenAnswer((_) async => tSession);

      await tester.pumpWidget(
        buildTestWidget(
          overrides: [
            getCartUsecaseProvider.overrideWithValue(mockGetCartUseCase),
            getProductsUsecaseProvider.overrideWithValue(
              mockGetProductsUseCase,
            ),
            createCheckoutSessionUseCaseProvider.overrideWithValue(
              mockCreateCheckoutSessionUseCase,
            ),
          ],
          builder: (context, ref) {
            final cartAsync = ref.watch(cartProvider);
            return cartAsync.when(
              data: (data) => ElevatedButton(
                onPressed: () {
                  ref.read(cartProvider.notifier).proceedToCheckout(context);
                },
                child: const Text('Checkout Button'),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (e, st) => Text('Error: $e'),
            );
          },
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Checkout Button'), findsOneWidget);

      await tester.tap(find.text('Checkout Button'));
      await tester.pumpAndSettle();

      verify(
        () => mockCreateCheckoutSessionUseCase.call(
          items: any(named: 'items', that: isNotEmpty),
          clearCartOnSuccess: true,
        ),
      ).called(1);

      expect(find.text('Checkout session-xyz'), findsOneWidget);
    });

    testWidgets('does nothing when cart is empty', (tester) async {
      when(
        () => mockGetCartUseCase(),
      ).thenAnswer((_) async => const CartEntity(items: []));
      when(() => mockGetProductsUseCase()).thenAnswer((_) async => [tProduct]);

      await tester.pumpWidget(
        buildTestWidget(
          overrides: [
            getCartUsecaseProvider.overrideWithValue(mockGetCartUseCase),
            getProductsUsecaseProvider.overrideWithValue(
              mockGetProductsUseCase,
            ),
            createCheckoutSessionUseCaseProvider.overrideWithValue(
              mockCreateCheckoutSessionUseCase,
            ),
          ],
          builder: (context, ref) {
            final cartAsync = ref.watch(cartProvider);
            return cartAsync.when(
              data: (data) => ElevatedButton(
                onPressed: () {
                  ref.read(cartProvider.notifier).proceedToCheckout(context);
                },
                child: const Text('Checkout Button'),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (e, st) => Text('Error: $e'),
            );
          },
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Checkout Button'));
      await tester.pumpAndSettle();

      verifyNever(
        () => mockCreateCheckoutSessionUseCase.call(
          items: any(named: 'items'),
          clearCartOnSuccess: any(named: 'clearCartOnSuccess'),
        ),
      );

      expect(find.text('Checkout Button'), findsOneWidget);
    });
  });
}
