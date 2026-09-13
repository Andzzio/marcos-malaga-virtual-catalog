import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/app/shared/data/datasources/firebase_storage_datasource.dart';
import 'package:marcos_malaga_app/app/shared/domain/services/image_processing_service.dart';
import 'package:marcos_malaga_app/features/catalog/domain/usecases/upload_banner_media_usecase.dart';

class MockFirebaseStorageDatasource extends Mock
    implements FirebaseStorageDatasource {}

class MockImageProcessingService extends Mock
    implements ImageProcessingService {}

void main() {
  late UploadBannerMediaUsecase usecase;
  late MockFirebaseStorageDatasource mockStorage;
  late MockImageProcessingService mockImageService;

  setUpAll(() {
    registerFallbackValue(Uint8List(0));
  });

  setUp(() {
    mockStorage = MockFirebaseStorageDatasource();
    mockImageService = MockImageProcessingService();
    usecase = UploadBannerMediaUsecase(
      storage: mockStorage,
      imageService: mockImageService,
    );
  });

  final tBytes = Uint8List.fromList([1, 2, 3, 4]);

  group('UploadBannerMediaUsecase Tests', () {
    test('should upload video directly without resizing when file is video', () async {
      const tFilename = 'hero_video.mp4';
      const tContentType = 'video/mp4';
      const tDownloadUrl = 'https://firebasestorage.googleapis.com/v0/b/.../hero_video.mp4';

      when(() => mockImageService.isVideo(any(), any())).thenReturn(true);
      when(
        () => mockStorage.uploadFile(
          path: any(named: 'path'),
          bytes: tBytes,
          contentType: tContentType,
        ),
      ).thenAnswer((_) async => tDownloadUrl);

      final result = await usecase(
        bytes: tBytes,
        filename: tFilename,
        contentType: tContentType,
      );

      expect(result, equals(tDownloadUrl));
      verify(() => mockImageService.isVideo(tFilename, tContentType)).called(1);
      verifyNever(() => mockImageService.processBannerImage(any()));
      verify(
        () => mockStorage.uploadFile(
          path: any(
            named: 'path',
            that: predicate<String>((p) => p.startsWith('banners/') && p.endsWith('_hero_video.mp4')),
          ),
          bytes: tBytes,
          contentType: tContentType,
        ),
      ).called(1);
    });

    test('should process image in isolate and upload dual resolutions (_original and _800) in webp format', () async {
      const tFilename = 'promo_banner.png';
      const tContentType = 'image/png';
      final tOrigBytes = Uint8List.fromList([10, 20]);
      final tThumbBytes = Uint8List.fromList([30, 40]);
      const tOrigUrl = 'https://firebasestorage.googleapis.com/v0/b/.../promo_banner_original.webp';
      const tThumbUrl = 'https://firebasestorage.googleapis.com/v0/b/.../promo_banner_800.webp';

      when(() => mockImageService.isVideo(any(), any())).thenReturn(false);
      when(() => mockImageService.processBannerImage(tBytes)).thenAnswer(
        (_) async => BannerProcessedImages(
          originalBytes: tOrigBytes,
          thumbnail800Bytes: tThumbBytes,
        ),
      );

      when(
        () => mockStorage.uploadFile(
          path: any(named: 'path', that: contains('_original.webp')),
          bytes: tOrigBytes,
          contentType: 'image/webp',
        ),
      ).thenAnswer((_) async => tOrigUrl);

      when(
        () => mockStorage.uploadFile(
          path: any(named: 'path', that: contains('_800.webp')),
          bytes: tThumbBytes,
          contentType: 'image/webp',
        ),
      ).thenAnswer((_) async => tThumbUrl);

      final result = await usecase(
        bytes: tBytes,
        filename: tFilename,
        contentType: tContentType,
      );

      expect(result, equals(tOrigUrl));
      verify(() => mockImageService.processBannerImage(tBytes)).called(1);
      verify(
        () => mockStorage.uploadFile(
          path: any(
            named: 'path',
            that: predicate<String>((p) => p.startsWith('banners/') && p.endsWith('_promo_banner_original.webp')),
          ),
          bytes: tOrigBytes,
          contentType: 'image/webp',
        ),
      ).called(1);
      verify(
        () => mockStorage.uploadFile(
          path: any(
            named: 'path',
            that: predicate<String>((p) => p.startsWith('banners/') && p.endsWith('_promo_banner_800.webp')),
          ),
          bytes: tThumbBytes,
          contentType: 'image/webp',
        ),
      ).called(1);
    });
  });
}
