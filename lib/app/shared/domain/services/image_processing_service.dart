import 'dart:typed_data';

/// Contenedor de variantes de imagen para Banners procesadas en Isolate.
class BannerProcessedImages {
  /// Versión en resolución completa optimizada en formato WebP.
  final Uint8List originalBytes;

  /// Versión miniatura reescalada a máx 800px preservando aspect ratio en formato WebP.
  final Uint8List thumbnail800Bytes;

  const BannerProcessedImages({
    required this.originalBytes,
    required this.thumbnail800Bytes,
  });
}

/// Contenedor de variantes de imagen para Productos procesadas en Isolate.
class ProductProcessedImages {
  /// Versión principal reescalada a máx 800x800px preservando aspect ratio en formato WebP.
  final Uint8List highRes800Bytes;

  /// Versión miniatura reescalada a máx 200x200px preservando aspect ratio en formato WebP.
  final Uint8List thumbnail200Bytes;

  const ProductProcessedImages({
    required this.highRes800Bytes,
    required this.thumbnail200Bytes,
  });
}

/// Contrato del servicio de procesamiento y reescalado de imágenes off-main-thread.
abstract class ImageProcessingService {
  /// Procesa una imagen de banner en segundo plano dentro de un Isolate.
  Future<BannerProcessedImages> processBannerImage(Uint8List bytes);

  /// Procesa una imagen de producto en segundo plano dentro de un Isolate.
  Future<ProductProcessedImages> processProductImage(Uint8List bytes);

  /// Determina si un archivo corresponde a video basado en nombre o contentType.
  bool isVideo(String filename, [String? contentType]);
}
