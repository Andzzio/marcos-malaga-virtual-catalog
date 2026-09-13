import 'dart:typed_data';
import 'package:marcos_malaga_app/app/shared/data/services/image_processing_service_impl.dart';
import 'package:marcos_malaga_app/app/shared/domain/services/image_processing_service.dart';

export 'package:marcos_malaga_app/app/shared/domain/services/image_processing_service.dart';

/// Fachada utilitaria para el procesamiento de imágenes.
abstract final class ImageProcessor {
  static const ImageProcessingService _service = ImageProcessingServiceImpl();

  /// Procesa una imagen de banner en un Isolate.
  static Future<BannerProcessedImages> processBanner(Uint8List bytes) {
    return _service.processBannerImage(bytes);
  }

  /// Procesa una imagen de producto en un Isolate.
  static Future<ProductProcessedImages> processProduct(Uint8List bytes) {
    return _service.processProductImage(bytes);
  }

  /// Comprueba si el archivo corresponde a video.
  static bool isVideo(String filename, [String? contentType]) {
    return _service.isVideo(filename, contentType);
  }
}
