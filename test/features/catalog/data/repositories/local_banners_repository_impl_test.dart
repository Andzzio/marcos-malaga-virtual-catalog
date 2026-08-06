import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/features/catalog/data/datasources/local_banners_datasource.dart';
import 'package:marcos_malaga_app/features/catalog/data/models/banner_model.dart';
import 'package:marcos_malaga_app/features/catalog/data/repositories/local_banners_repository_impl.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/banner_entity.dart';

class MockLocalBannersDatasource extends Mock
    implements LocalBannersDatasource {}

void main() {
  late LocalBannersRepositoryImpl repository;
  late MockLocalBannersDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockLocalBannersDatasource();
    repository = LocalBannersRepositoryImpl(datasource: mockDatasource);
  });

  const tBannerModel = BannerModel(
    id: 'BANNER-001',
    desktopImageUrl: 'assets/images/banners/banner_1.png',
    mobileImageUrl: 'assets/images/banners/banner_1.png',
    title: 'New Arrivals',
    actionType: 'openCategory',
    actionValue: 'vestidos',
    isActive: true,
  );

  final tBannerEntity = tBannerModel.toEntity();

  group('LocalBannersRepositoryImpl Tests', () {
    test('should return List<BannerEntity> when datasource succeeds', () async {
      when(
        () => mockDatasource.fetchBanners(),
      ).thenAnswer((_) async => [tBannerModel]);

      final result = await repository.getBanners();

      expect(result, isA<List<BannerEntity>>());
      expect(result.length, 1);
      expect(result.first.id, tBannerEntity.id);
      expect(result.first.actionType, BannerActionType.openCategory);

      verify(() => mockDatasource.fetchBanners()).called(1);
      verifyNoMoreInteractions(mockDatasource);
    });

    test('should return empty list if datasource returns empty list', () async {
      when(() => mockDatasource.fetchBanners()).thenAnswer((_) async => []);

      final result = await repository.getBanners();

      expect(result, isA<List<BannerEntity>>());
      expect(result, isEmpty);
      verify(() => mockDatasource.fetchBanners()).called(1);
    });
  });
}
