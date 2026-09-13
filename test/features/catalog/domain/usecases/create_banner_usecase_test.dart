import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/banner_entity.dart';
import 'package:marcos_malaga_app/features/catalog/domain/repositories/banners_repository.dart';
import 'package:marcos_malaga_app/features/catalog/domain/usecases/create_banner_usecase.dart';

class MockBannersRepository extends Mock implements BannersRepository {}

void main() {
  late CreateBannerUsecase usecase;
  late MockBannersRepository mockRepo;

  setUp(() {
    mockRepo = MockBannersRepository();
    usecase = CreateBannerUsecase(repo: mockRepo);
  });

  const tBanner = BannerEntity(
    id: 'BANNER-002',
    desktopUrl: 'https://example.com/desk.mp4',
    desktopMediaType: BannerMediaType.video,
    mobileUrl: 'https://example.com/mob.jpg',
    mobileMediaType: BannerMediaType.image,
    title: 'Summer Sale',
    actionType: BannerActionType.openCategory,
    actionValue: 'faldas',
    isActive: true,
  );

  group('CreateBannerUsecase Tests', () {
    test('should call repository.createBanner with correct banner', () async {
      when(() => mockRepo.createBanner(tBanner)).thenAnswer((_) async {});

      await usecase(tBanner);

      verify(() => mockRepo.createBanner(tBanner)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });
  });
}
