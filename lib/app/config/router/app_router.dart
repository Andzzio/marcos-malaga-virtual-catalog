import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/screens/home_screen.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/screens/product_detail_screen.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/screens/new_arrivals_screen.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/screens/catalog_screen.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/screens/xl_sizes_screen.dart';
import 'package:marcos_malaga_app/features/auth/presentation/screens/login_screen.dart';
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
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'new-arrivals',
            name: 'new-arrivals',
            builder: (context, state) => const NewArrivalsScreen(),
          ),
          GoRoute(
            path: 'catalog',
            name: 'catalog',
            builder: (context, state) => const CatalogScreen(),
          ),
          GoRoute(
            path: 'xl-sizes',
            name: 'xl-sizes',
            builder: (context, state) => const XlSizesScreen(),
          ),
          GoRoute(
            path: 'login',
            name: 'login',
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: 'checkout',
            name: 'checkout',
            builder: (context, state) => const CheckoutScreen(),
          ),
          GoRoute(
            path: 'legal',
            name: 'legal',
            redirect: (context, state) => 'legal/terms',
            routes: [
              GoRoute(
                path: 'privacy-policy',
                name: 'privacy-policy',
                builder: (context, state) => const PrivacyPolicyScreen(),
              ),
              GoRoute(
                path: 'refund-policy',
                name: 'refund-policy',
                builder: (context, state) => const RefundPolicyScreen(),
              ),
              GoRoute(
                path: 'shipping-policy',
                name: 'shipping-policy',
                builder: (context, state) => const ShippingPolicyScreen(),
              ),
              GoRoute(
                path: 'terms',
                name: 'terms',
                builder: (context, state) => const TermsScreen(),
              ),
              GoRoute(
                path: 'complaints-book',
                name: 'complaints-book',
                builder: (context, state) => const ComplaintsBookScreen(),
              ),
            ],
          ),
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
