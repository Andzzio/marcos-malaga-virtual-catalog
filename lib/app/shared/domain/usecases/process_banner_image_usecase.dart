import 'dart:typed_data';
import 'package:marcos_malaga_app/app/shared/domain/services/image_processing_service.dart';

/// Caso de uso para delegar el procesamiento de imágenes de banner al servicio.
class ProcessBannerImageUsecase {
  final ImageProcessingService service;

  const ProcessBannerImageUsecase({required this.service});

  Future<BannerProcessedImages> call(Uint8List bytes) {
    return service.processBannerImage(bytes);
  }
}
