import 'dart:typed_data';
import 'package:marcos_malaga_app/app/shared/domain/services/image_processing_service.dart';

/// Caso de uso para delegar el procesamiento de imágenes de producto al servicio.
class ProcessProductImageUsecase {
  final ImageProcessingService service;

  const ProcessProductImageUsecase({required this.service});

  Future<ProductProcessedImages> call(Uint8List bytes) {
    return service.processProductImage(bytes);
  }
}
