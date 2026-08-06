import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/banner_entity.dart';
import 'package:marcos_malaga_app/features/catalog/domain/repositories/banners_repository.dart';
import 'package:marcos_malaga_app/features/catalog/domain/usecases/get_banners_usecase.dart';

class MockBannersRepository extends Mock implements BannersRepository {}

void main() {
  late GetBannersUsecase usecase;
  late MockBannersRepository mockRepo;

  setUp(() {
    mockRepo = MockBannersRepository();
    usecase = GetBannersUsecase(repo: mockRepo);
  });

  const tBanner = BannerEntity(
    id: 'BANNER-001',
    desktopImageUrl: 'assets/images/banners/banner_1.png',
    mobileImageUrl: 'assets/images/banners/banner_1.png',
    title: 'New Arrivals',
    actionType: BannerActionType.openCategory,
    actionValue: 'vestidos',
    isActive: true,
  );

  final tBannersList = [tBanner];

  group('GetBannersUsecase Tests', () {
    test('should get a list of banners from the repository', () async {
      when(() => mockRepo.getBanners()).thenAnswer((_) async => tBannersList);

      final result = await usecase();

      expect(result, equals(tBannersList));
      verify(() => mockRepo.getBanners()).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('should get an empty list from the repository when no banners are available', () async {
      when(() => mockRepo.getBanners()).thenAnswer((_) async => []);

      final result = await usecase();

      expect(result, isEmpty);
      verify(() => mockRepo.getBanners()).called(1);
    });
  });
}
