import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/app/shared/data/datasources/firebase_storage_datasource.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/banner_entity.dart';
import 'package:marcos_malaga_app/features/catalog/domain/repositories/banners_repository.dart';
import 'package:marcos_malaga_app/features/catalog/domain/usecases/delete_banner_usecase.dart';

class MockBannersRepository extends Mock implements BannersRepository {}

class MockFirebaseStorageDatasource extends Mock
    implements FirebaseStorageDatasource {}

void main() {
  late DeleteBannerUsecase usecase;
  late MockBannersRepository mockRepo;
  late MockFirebaseStorageDatasource mockStorage;

  setUp(() {
    mockRepo = MockBannersRepository();
    mockStorage = MockFirebaseStorageDatasource();
    usecase = DeleteBannerUsecase(repo: mockRepo, storage: mockStorage);
  });

  const tBanner = BannerEntity(
    id: 'BANNER-003',
    desktopUrl: 'https://firebasestorage.googleapis.com/v0/b/.../banner_3_original.webp?alt=media',
    desktopMediaType: BannerMediaType.image,
    mobileUrl: 'https://firebasestorage.googleapis.com/v0/b/.../banner_3_mobile_original.webp?alt=media',
    mobileMediaType: BannerMediaType.image,
    title: 'Colección Aurora',
    actionType: BannerActionType.openCategory,
    actionValue: 'coleccion_aurora',
    isActive: true,
  );

  group('DeleteBannerUsecase Tests', () {
    test('should call storage.deleteFileByUrl for media and repository.deleteBanner with correct id', () async {
      when(() => mockStorage.deleteFileByUrl(any())).thenAnswer((_) async {});
      when(() => mockRepo.deleteBanner(tBanner.id)).thenAnswer((_) async {});

      await usecase(tBanner);

      verify(() => mockRepo.deleteBanner(tBanner.id)).called(1);
      // Deletes original and 800 thumbnail for desktop, and original and 800 for mobile
      verify(() => mockStorage.deleteFileByUrl(tBanner.desktopUrl)).called(1);
      verify(() => mockStorage.deleteFileByUrl(tBanner.mobileUrl)).called(1);
    });
  });
}
