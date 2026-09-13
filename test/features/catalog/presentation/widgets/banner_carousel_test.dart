import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/app/shared/domain/services/url_launcher_service.dart';
import 'package:marcos_malaga_app/app/shared/domain/usecases/launch_external_url_usecase.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/banner_entity.dart';
import 'package:marcos_malaga_app/features/catalog/domain/usecases/get_banners_usecase.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/widgets/banner_carousel.dart';
import 'package:marcos_malaga_app/providers/core/core_providers.dart';
import 'package:marcos_malaga_app/providers/features/catalog/catalog_providers.dart';

class MockGetBannersUsecase extends Mock implements GetBannersUsecase {}
class MockUrlLauncherService extends Mock implements UrlLauncherService {}

void main() {
  late MockGetBannersUsecase mockGetBanners;
  late MockUrlLauncherService mockUrlLauncherService;

  setUp(() {
    mockGetBanners = MockGetBannersUsecase();
    mockUrlLauncherService = MockUrlLauncherService();
  });

  Widget createWidget({
    required List<BannerEntity> banners,
    required String? Function(String path) onNavigate,
  }) {
    when(() => mockGetBanners()).thenAnswer((_) async => banners);

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(
            body: CustomScrollView(
              slivers: [
                BannerCarousel(),
              ],
            ),
          ),
        ),
        GoRoute(
          path: '/search/catalog',
          builder: (context, state) {
            final cat = state.uri.queryParameters['category'];
            onNavigate('/search/catalog?category=$cat');
            return Text('Search Catalog: $cat');
          },
        ),
        GoRoute(
          path: '/products/:id',
          builder: (context, state) {
            final id = state.pathParameters['id'];
            onNavigate('/products/$id');
            return Text('Product: $id');
          },
        ),
      ],
    );

    return ProviderScope(
      overrides: [
        getBannersUsecaseProvider.overrideWithValue(mockGetBanners),
        urlLauncherServiceProvider.overrideWithValue(mockUrlLauncherService),
        launchExternalUrlUsecaseProvider.overrideWithValue(
          LaunchExternalUrlUsecase(service: mockUrlLauncherService),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }

  testWidgets('tapping banner with openCategory navigates to /search/catalog with capitalized category', (tester) async {
    String? navigatedRoute;
    const banner = BannerEntity(
      id: 'b-cat',
      desktopUrl: 'assets/test.webp',
      mobileUrl: 'assets/test.webp',
      actionType: BannerActionType.openCategory,
      actionValue: 'molduras doradas',
      isActive: true,
    );

    await tester.pumpWidget(createWidget(
      banners: [banner],
      onNavigate: (path) => navigatedRoute = path,
    ));
    await tester.pumpAndSettle();

    expect(find.byType(BannerCarousel), findsOneWidget);

    // Tap on the banner
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pumpAndSettle();

    expect(navigatedRoute, '/search/catalog?category=Molduras doradas');
  });

  testWidgets('tapping banner with openProduct navigates to /products/:id', (tester) async {
    String? navigatedRoute;
    const banner = BannerEntity(
      id: 'b-prod',
      desktopUrl: 'assets/test.webp',
      mobileUrl: 'assets/test.webp',
      actionType: BannerActionType.openProduct,
      actionValue: 'prod-456',
      isActive: true,
    );

    await tester.pumpWidget(createWidget(
      banners: [banner],
      onNavigate: (path) => navigatedRoute = path,
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(GestureDetector).first);
    await tester.pumpAndSettle();

    expect(navigatedRoute, '/products/prod-456');
  });

  testWidgets('tapping banner with openUrl executes LaunchExternalUrlUsecase', (tester) async {
    const testUrl = 'https://instagram.com/marcosmalaga';
    when(() => mockUrlLauncherService.launchUrlString(testUrl))
        .thenAnswer((_) async => true);

    const banner = BannerEntity(
      id: 'b-url',
      desktopUrl: 'assets/test.webp',
      mobileUrl: 'assets/test.webp',
      actionType: BannerActionType.openUrl,
      actionValue: testUrl,
      isActive: true,
    );

    await tester.pumpWidget(createWidget(
      banners: [banner],
      onNavigate: (_) => null,
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(GestureDetector).first);
    await tester.pumpAndSettle();

    verify(() => mockUrlLauncherService.launchUrlString(testUrl)).called(1);
  });

  testWidgets('wraps banner in MouseRegion with click cursor', (tester) async {
    const banner = BannerEntity(
      id: 'b-none',
      desktopUrl: 'assets/test.webp',
      mobileUrl: 'assets/test.webp',
      actionType: BannerActionType.none,
      isActive: true,
    );

    await tester.pumpWidget(createWidget(
      banners: [banner],
      onNavigate: (_) => null,
    ));
    await tester.pumpAndSettle();

    final mouseRegionFinder = find.ancestor(
      of: find.byType(GestureDetector).first,
      matching: find.byType(MouseRegion),
    );
    expect(mouseRegionFinder, findsWidgets);

    final mouseRegion = tester.widget<MouseRegion>(mouseRegionFinder.first);
    expect(mouseRegion.cursor, SystemMouseCursors.click);
  });
}
