import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/banner_entity.dart';
import 'package:marcos_malaga_app/features/catalog/domain/usecases/create_banner_usecase.dart';
import 'package:marcos_malaga_app/features/catalog/domain/usecases/delete_banner_usecase.dart';
import 'package:marcos_malaga_app/features/catalog/domain/usecases/get_banners_usecase.dart';
import 'package:marcos_malaga_app/features/catalog/domain/usecases/reorder_banners_usecase.dart';
import 'package:marcos_malaga_app/features/catalog/domain/usecases/update_banner_usecase.dart';
import 'package:marcos_malaga_app/features/catalog/presentation/providers/banners_provider.dart';
import 'package:marcos_malaga_app/providers/features/catalog/catalog_providers.dart';

class MockGetBannersUsecase extends Mock implements GetBannersUsecase {}

class MockCreateBannerUsecase extends Mock implements CreateBannerUsecase {}

class MockUpdateBannerUsecase extends Mock implements UpdateBannerUsecase {}

class MockDeleteBannerUsecase extends Mock implements DeleteBannerUsecase {}

class MockReorderBannersUsecase extends Mock implements ReorderBannersUsecase {}

void main() {
  late MockGetBannersUsecase mockGetBanners;
  late MockCreateBannerUsecase mockCreateBanner;
  late MockUpdateBannerUsecase mockUpdateBanner;
  late MockDeleteBannerUsecase mockDeleteBanner;
  late MockReorderBannersUsecase mockReorderBanners;

  setUp(() {
    mockGetBanners = MockGetBannersUsecase();
    mockCreateBanner = MockCreateBannerUsecase();
    mockUpdateBanner = MockUpdateBannerUsecase();
    mockDeleteBanner = MockDeleteBannerUsecase();
    mockReorderBanners = MockReorderBannersUsecase();
  });

  const b1 = BannerEntity(
    id: 'B1',
    desktopUrl: 'https://example.com/b1.jpg',
    desktopMediaType: BannerMediaType.image,
    mobileUrl: 'https://example.com/b1_m.jpg',
    mobileMediaType: BannerMediaType.image,
    title: 'Banner 1',
    actionType: BannerActionType.none,
    isActive: true,
  );

  const b2 = BannerEntity(
    id: 'B2',
    desktopUrl: 'https://example.com/b2.mp4',
    desktopMediaType: BannerMediaType.video,
    mobileUrl: 'https://example.com/b2_m.mp4',
    mobileMediaType: BannerMediaType.video,
    title: 'Banner 2',
    actionType: BannerActionType.none,
    isActive: false,
  );

  ProviderContainer createContainer({List<BannerEntity>? initialBanners}) {
    when(() => mockGetBanners()).thenAnswer((_) async => initialBanners ?? [b1, b2]);

    final container = ProviderContainer(
      overrides: [
        getBannersUsecaseProvider.overrideWithValue(mockGetBanners),
        createBannerUsecaseProvider.overrideWithValue(mockCreateBanner),
        updateBannerUsecaseProvider.overrideWithValue(mockUpdateBanner),
        deleteBannerUsecaseProvider.overrideWithValue(mockDeleteBanner),
        reorderBannersUsecaseProvider.overrideWithValue(mockReorderBanners),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('BannersProvider Tests', () {
    test('build() loads banners from getBannersUsecase', () async {
      final container = createContainer();
      final result = await container.read(bannersProvider.future);
      expect(result, equals([b1, b2]));
    });

    test('createBanner calls usecase and invalidates self', () async {
      final container = createContainer();
      await container.read(bannersProvider.future);

      when(() => mockCreateBanner(b1)).thenAnswer((_) async {});

      await container.read(bannersProvider.notifier).createBanner(b1);

      verify(() => mockCreateBanner(b1)).called(1);
    });

    test('updateBanner calls usecase and invalidates self', () async {
      final container = createContainer();
      await container.read(bannersProvider.future);

      when(() => mockUpdateBanner(b1)).thenAnswer((_) async {});

      await container.read(bannersProvider.notifier).updateBanner(b1);

      verify(() => mockUpdateBanner(b1)).called(1);
    });

    test('deleteBanner calls usecase and invalidates self', () async {
      final container = createContainer();
      await container.read(bannersProvider.future);

      when(() => mockDeleteBanner(b1)).thenAnswer((_) async {});

      await container.read(bannersProvider.notifier).deleteBanner(b1);

      verify(() => mockDeleteBanner(b1)).called(1);
    });

    test('toggleActive toggles isActive and calls updateBanner', () async {
      final container = createContainer();
      await container.read(bannersProvider.future);

      final updatedB1 = b1.copyWith(isActive: false);
      when(() => mockUpdateBanner(updatedB1)).thenAnswer((_) async {});

      await container.read(bannersProvider.notifier).toggleActive(b1);

      verify(() => mockUpdateBanner(updatedB1)).called(1);
    });

    test('moveUp swaps with preceding item and calls reorderBanners', () async {
      final container = createContainer();
      await container.read(bannersProvider.future);

      when(() => mockReorderBanners(['B2', 'B1'])).thenAnswer((_) async {});

      await container.read(bannersProvider.notifier).moveUp(1);

      verify(() => mockReorderBanners(['B2', 'B1'])).called(1);
    });

    test('moveDown swaps with next item and calls reorderBanners', () async {
      final container = createContainer();
      await container.read(bannersProvider.future);

      when(() => mockReorderBanners(['B2', 'B1'])).thenAnswer((_) async {});

      await container.read(bannersProvider.notifier).moveDown(0);

      verify(() => mockReorderBanners(['B2', 'B1'])).called(1);
    });

    test('reorder reorganizes list and calls reorderBanners', () async {
      final container = createContainer();
      await container.read(bannersProvider.future);

      when(() => mockReorderBanners(['B2', 'B1'])).thenAnswer((_) async {});

      await container.read(bannersProvider.notifier).reorder(0, 2);

      verify(() => mockReorderBanners(['B2', 'B1'])).called(1);
    });
  });
}
