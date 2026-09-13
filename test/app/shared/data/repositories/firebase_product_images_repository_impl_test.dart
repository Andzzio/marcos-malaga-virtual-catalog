import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/app/shared/data/datasources/firebase_storage_datasource.dart';
import 'package:marcos_malaga_app/app/shared/data/repositories/firebase_product_images_repository_impl.dart';
import 'package:marcos_malaga_app/app/shared/domain/services/image_processing_service.dart';

class MockFirebaseStorageDatasource extends Mock
    implements FirebaseStorageDatasource {}

class MockImageProcessingService extends Mock
    implements ImageProcessingService {}

void main() {
  late FirebaseProductImagesRepositoryImpl repository;
  late MockFirebaseStorageDatasource mockDatasource;
  late MockImageProcessingService mockImageService;

  setUp(() {
    mockDatasource = MockFirebaseStorageDatasource();
    mockImageService = MockImageProcessingService();
    repository = FirebaseProductImagesRepositoryImpl(
      mockDatasource,
      imageService: mockImageService,
    );
  });

  final tBytes = Uint8List.fromList([1, 2, 3, 4]);

  group('FirebaseProductImagesRepositoryImpl Tests', () {
    test('uploadProductImage should process product image and upload _800x800 and _200x200 versions in webp', () async {
      const tFilename = 'polo_negro.jpg';
      final tHighResBytes = Uint8List.fromList([10, 20]);
      final tThumbBytes = Uint8List.fromList([30, 40]);
      const tHighResUrl = 'https://firebasestorage.googleapis.com/v0/b/.../polo_negro_800x800.webp';
      const tThumbUrl = 'https://firebasestorage.googleapis.com/v0/b/.../polo_negro_200x200.webp';

      when(() => mockImageService.processProductImage(tBytes)).thenAnswer(
        (_) async => ProductProcessedImages(
          highRes800Bytes: tHighResBytes,
          thumbnail200Bytes: tThumbBytes,
        ),
      );

      when(
        () => mockDatasource.uploadFile(
          path: any(named: 'path', that: contains('_800x800.webp')),
          bytes: tHighResBytes,
          contentType: 'image/webp',
        ),
      ).thenAnswer((_) async => tHighResUrl);

      when(
        () => mockDatasource.uploadFile(
          path: any(named: 'path', that: contains('_200x200.webp')),
          bytes: tThumbBytes,
          contentType: 'image/webp',
        ),
      ).thenAnswer((_) async => tThumbUrl);

      final result = await repository.uploadProductImage(
        bytes: tBytes,
        filename: tFilename,
      );

      expect(result, equals(tHighResUrl));
      verify(() => mockImageService.processProductImage(tBytes)).called(1);
      verify(
        () => mockDatasource.uploadFile(
          path: any(
            named: 'path',
            that: predicate<String>((p) => p.startsWith('products/') && p.endsWith('_polo_negro_800x800.webp')),
          ),
          bytes: tHighResBytes,
          contentType: 'image/webp',
        ),
      ).called(1);
      verify(
        () => mockDatasource.uploadFile(
          path: any(
            named: 'path',
            that: predicate<String>((p) => p.startsWith('products/') && p.endsWith('_polo_negro_200x200.webp')),
          ),
          bytes: tThumbBytes,
          contentType: 'image/webp',
        ),
      ).called(1);
    });

    test('deleteProductImage should delete both high-res and thumbnail by URL', () async {
      const tUrl = 'https://firebasestorage.googleapis.com/v0/b/.../products%2Fpolo_800x800.webp?alt=media';
      const tThumbUrl = 'https://firebasestorage.googleapis.com/v0/b/.../products%2Fpolo_200x200.webp?alt=media';

      when(() => mockDatasource.deleteFileByUrl(tUrl)).thenAnswer((_) async {});
      when(() => mockDatasource.deleteFileByUrl(tThumbUrl)).thenAnswer((_) async {});

      await repository.deleteProductImage(tUrl);

      verify(() => mockDatasource.deleteFileByUrl(tUrl)).called(1);
      verify(() => mockDatasource.deleteFileByUrl(tThumbUrl)).called(1);
    });
  });
}
