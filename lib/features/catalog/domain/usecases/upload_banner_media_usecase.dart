import 'dart:typed_data';
import 'package:marcos_malaga_app/app/shared/data/datasources/firebase_storage_datasource.dart';
import 'package:marcos_malaga_app/app/shared/data/services/image_processing_service_impl.dart';
import 'package:marcos_malaga_app/app/shared/domain/services/image_processing_service.dart';

class UploadBannerMediaUsecase {
  final FirebaseStorageDatasource storage;
  final ImageProcessingService imageService;

  const UploadBannerMediaUsecase({
    required this.storage,
    this.imageService = const ImageProcessingServiceImpl(),
  });

  Future<String> call({
    required Uint8List bytes,
    required String filename,
    required String contentType,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final isVideo = imageService.isVideo(filename, contentType);

    if (isVideo) {
      final safeName = filename.replaceAll(RegExp(r'[^\w.]'), '_');
      final path = 'banners/${timestamp}_$safeName';
      return await storage.uploadFile(
        path: path,
        bytes: bytes,
        contentType: contentType,
      );
    }

    // Process image in isolate
    final processed = await imageService.processBannerImage(bytes);

    // Extract base name without extension and sanitize
    final nameWithoutExt = filename.contains('.')
        ? filename.substring(0, filename.lastIndexOf('.'))
        : filename;
    final safeBase = nameWithoutExt.replaceAll(RegExp(r'[^\w]'), '_');

    final originalPath = 'banners/${timestamp}_${safeBase}_original.webp';
    final thumbnailPath = 'banners/${timestamp}_${safeBase}_800.webp';

    final results = await Future.wait([
      storage.uploadFile(
        path: originalPath,
        bytes: processed.originalBytes,
        contentType: 'image/webp',
      ),
      storage.uploadFile(
        path: thumbnailPath,
        bytes: processed.thumbnail800Bytes,
        contentType: 'image/webp',
      ),
    ]);

    // Return the original URL
    return results[0];
  }
}


