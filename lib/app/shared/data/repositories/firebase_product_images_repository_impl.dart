import 'dart:typed_data';

import 'package:marcos_malaga_app/app/shared/data/datasources/firebase_storage_datasource.dart';
import 'package:marcos_malaga_app/app/shared/data/services/image_processing_service_impl.dart';
import 'package:marcos_malaga_app/app/shared/domain/repositories/product_images_repository.dart';
import 'package:marcos_malaga_app/app/shared/domain/services/image_processing_service.dart';

class FirebaseProductImagesRepositoryImpl implements ProductImagesRepository {
  final FirebaseStorageDatasource _datasource;
  final ImageProcessingService _imageService;

  FirebaseProductImagesRepositoryImpl(
    this._datasource, {
    ImageProcessingService? imageService,
  }) : _imageService = imageService ?? const ImageProcessingServiceImpl();

  @override
  Future<String> uploadProductImage({
    required Uint8List bytes,
    required String filename,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // Process image in isolate via service
    final processed = await _imageService.processProductImage(bytes);

    final nameWithoutExt = filename.contains('.')
        ? filename.substring(0, filename.lastIndexOf('.'))
        : filename;
    final safeBase = nameWithoutExt.replaceAll(RegExp(r'[^\w]'), '_');

    final highResPath = 'products/${timestamp}_${safeBase}_800x800.webp';
    final thumbPath = 'products/${timestamp}_${safeBase}_200x200.webp';

    final results = await Future.wait([
      _datasource.uploadFile(
        path: highResPath,
        bytes: processed.highRes800Bytes,
        contentType: 'image/webp',
      ),
      _datasource.uploadFile(
        path: thumbPath,
        bytes: processed.thumbnail200Bytes,
        contentType: 'image/webp',
      ),
    ]);

    // Return the high-res 800x800 URL
    return results[0];
  }

  @override
  Future<void> deleteProductImage(String url) async {
    try {
      if (url.startsWith('https://')) {
        await _datasource.deleteFileByUrl(url);
        if (url.contains('_800x800')) {
          final thumbUrl = url.replaceAll('_800x800', '_200x200');
          await _datasource.deleteFileByUrl(thumbUrl);
        }
      } else {
        await _datasource.deleteFile(url);
        if (url.contains('_800x800')) {
          final thumbPath = url.replaceAll('_800x800', '_200x200');
          await _datasource.deleteFile(thumbPath);
        }
      }
    } catch (_) {
      // Silently fail if file doesn't exist
    }
  }
}

