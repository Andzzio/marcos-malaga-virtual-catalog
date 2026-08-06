import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/screens/home_screen.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/screens/product_detail_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'products/:id',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>;
              final product = extra['product'] as ProductEntity;
              return ProductDetailScreen(product: product);
            },
          ),
        ],
      ),
    ],
  );
});
