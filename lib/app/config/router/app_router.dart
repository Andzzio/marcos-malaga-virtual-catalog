import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marcos_malaga_app/app/core/presentation/shell/app_shell.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/screens/home_screen.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/screens/product_detail_screen.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/states/product_filters_state.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/screens/catalog_screen.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/screens/search_screen.dart';
import 'package:marcos_malaga_app/features/account/presentation/screens/login_screen.dart';
import 'package:marcos_malaga_app/features/checkout/presentation/screens/checkout_screen.dart';
import 'package:marcos_malaga_app/features/legal/presentation/screens/privacy_policy_screen.dart';
import 'package:marcos_malaga_app/features/legal/presentation/screens/refund_policy_screen.dart';
import 'package:marcos_malaga_app/features/legal/presentation/screens/shipping_policy_screen.dart';
import 'package:marcos_malaga_app/features/legal/presentation/screens/terms_screen.dart';
import 'package:marcos_malaga_app/features/legal/presentation/screens/complaints_book_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'checkout',
                    name: 'checkout',
                    builder: (context, state) => const CheckoutScreen(),
                  ),
                  GoRoute(
                    path: 'legal',
                    name: 'legal',
                    redirect: (context, state) {
                      if (state.uri.path == '/legal') {
                        return '/legal/terms';
                      }
                      return null;
                    },
                    routes: [
                      GoRoute(
                        path: 'privacy-policy',
                        name: 'privacy-policy',
                        builder: (context, state) =>
                            const PrivacyPolicyScreen(),
                      ),
                      GoRoute(
                        path: 'refund-policy',
                        name: 'refund-policy',
                        builder: (context, state) => const RefundPolicyScreen(),
                      ),
                      GoRoute(
                        path: 'shipping-policy',
                        name: 'shipping-policy',
                        builder: (context, state) =>
                            const ShippingPolicyScreen(),
                      ),
                      GoRoute(
                        path: 'terms',
                        name: 'terms',
                        builder: (context, state) => const TermsScreen(),
                      ),
                      GoRoute(
                        path: 'complaints-book',
                        name: 'complaints-book',
                        builder: (context, state) =>
                            const ComplaintsBookScreen(),
                      ),
                    ],
                  ),
                  productRoute,
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                name: 'search',
                builder: (context, state) => const SearchScreen(),
                routes: [
                  productRoute,
                  _buildCatalogRoute(
                    path: 'new-arrivals',
                    name: 'new-arrivals',
                    category: CatalogCategory.newArrivals,
                    title: 'Nuevos Ingresos',
                  ),
                  _buildCatalogRoute(
                    path: 'catalog',
                    name: 'catalog',
                    category: CatalogCategory.global,
                    title: 'Catálogo',
                  ),
                  _buildCatalogRoute(
                    path: 'xl-sizes',
                    name: 'xl-sizes',
                    category: CatalogCategory.xlSizes,
                    title: 'Tallas XL',
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/login',
                name: 'login',
                builder: (context, state) => const LoginScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
final GoRoute productRoute = GoRoute(
  path: 'products/:id',
  pageBuilder: (context, state) {
    final extra = state.extra as Map<String, dynamic>?;
    ProductEntity? product;
    if (extra != null) {
      product = extra['product'] as ProductEntity?;
    }
    String? productId = state.pathParameters['id'];
    return MaterialPage(
      key: ValueKey(productId),
      child: ProductDetailScreen(
        product: product,
        productId: productId ??= 'NULL-PRODUCT',
      ),
    );
  },
);

GoRoute _buildCatalogRoute({
  required String path,
  required String name,
  required CatalogCategory category,
  required String title,
}) {
  return GoRoute(
    path: path,
    name: name,
    builder: (context, state) {
      final showInStock = state.uri.queryParameters['inStock'];
      final showOutOfStock = state.uri.queryParameters['outStock'];
      final query = state.uri.queryParameters['q'];
      final categoryName = state.uri.queryParameters['category'];
      final minPrice = state.uri.queryParameters['min'];
      final maxPrice = state.uri.queryParameters['max'];
      final orderBy = state.uri.queryParameters['order'];
      return CatalogScreen(
        category: category,
        title: title,
        showInStock: showInStock,
        showOutOfStock: showOutOfStock,
        query: query,
        categoryName: categoryName,
        minPrice: minPrice,
        maxPrice: maxPrice,
        orderBy: orderBy,
      );
    },
  );
}
