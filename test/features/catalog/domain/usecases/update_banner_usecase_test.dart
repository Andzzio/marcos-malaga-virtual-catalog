import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/banner_entity.dart';
import 'package:marcos_malaga_app/features/catalog/domain/repositories/banners_repository.dart';
import 'package:marcos_malaga_app/features/catalog/domain/usecases/update_banner_usecase.dart';

class MockBannersRepository extends Mock implements BannersRepository {}

void main() {
  late UpdateBannerUsecase usecase;
  late MockBannersRepository mockRepo;

  setUp(() {
    mockRepo = MockBannersRepository();
    usecase = UpdateBannerUsecase(repo: mockRepo);
  });

  const tBanner = BannerEntity(
    id: 'BANNER-002',
    desktopUrl: 'https://example.com/desk_updated.mp4',
    desktopMediaType: BannerMediaType.video,
    mobileUrl: 'https://example.com/mob_updated.jpg',
    mobileMediaType: BannerMediaType.image,
    title: 'Summer Sale Updated',
    actionType: BannerActionType.openCategory,
    actionValue: 'faldas',
    isActive: false,
  );

  group('UpdateBannerUsecase Tests', () {
    test('should call repository.updateBanner with updated banner', () async {
      when(() => mockRepo.updateBanner(tBanner)).thenAnswer((_) async {});

      await usecase(tBanner);

      verify(() => mockRepo.updateBanner(tBanner)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });
  });
}
