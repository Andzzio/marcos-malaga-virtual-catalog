import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:marcos_malaga_app/app/shared/domain/services/image_processing_service.dart';


/// Implementación concreta de [ImageProcessingService] usando [compute] / Isolates y `package:image`.
class ImageProcessingServiceImpl implements ImageProcessingService {
  const ImageProcessingServiceImpl();

  @override
  Future<BannerProcessedImages> processBannerImage(Uint8List bytes) {
    return compute(processBannerImageInIsolate, bytes);
  }

  @override
  Future<ProductProcessedImages> processProductImage(Uint8List bytes) {
    return compute(processProductImageInIsolate, bytes);
  }

  @override
  bool isVideo(String filename, [String? contentType]) {
    if (contentType != null && contentType.startsWith('video/')) return true;
    final lower = filename.toLowerCase();
    return lower.endsWith('.mp4') ||
        lower.endsWith('.mov') ||
        lower.endsWith('.webm');
  }
}

/// Función pura de nivel superior para ejecutarse dentro de un Isolate.
/// Genera:
/// 1. Versión en resolución original codificada en WebP (calidad 85).
/// 2. Versión de miniatura de máx 800px preservando aspect ratio en WebP (calidad 85).
BannerProcessedImages processBannerImageInIsolate(Uint8List rawBytes) {
  try {
    final image = img.decodeImage(rawBytes);
    if (image == null) {
      return BannerProcessedImages(
        originalBytes: rawBytes,
        thumbnail800Bytes: rawBytes,
      );
    }

    // 1. Versión original codificada en WebP
    final originalWebp = img.encodeWebP(image, quality: 85);

    // 2. Versión de 800px preservando aspect ratio
    final thumbImage = fitImageToBounds(image, 800);
    final thumb800Webp = img.encodeWebP(thumbImage, quality: 85);

    return BannerProcessedImages(
      originalBytes: Uint8List.fromList(originalWebp),
      thumbnail800Bytes: Uint8List.fromList(thumb800Webp),
    );
  } catch (_) {
    return BannerProcessedImages(
      originalBytes: rawBytes,
      thumbnail800Bytes: rawBytes,
    );
  }
}

/// Función pura de nivel superior para ejecutarse dentro de un Isolate.
/// Genera:
/// 1. Versión principal de 800x800 máx preservando aspect ratio en WebP (calidad 85).
/// 2. Versión miniatura de 200x200 máx preservando aspect ratio en WebP (calidad 85).
ProductProcessedImages processProductImageInIsolate(Uint8List rawBytes) {
  try {
    final image = img.decodeImage(rawBytes);
    if (image == null) {
      return ProductProcessedImages(
        highRes800Bytes: rawBytes,
        thumbnail200Bytes: rawBytes,
      );
    }

    // 1. Versión de 800x800 máx
    final highResImage = fitImageToBounds(image, 800);
    final highResWebp = img.encodeWebP(highResImage, quality: 85);

    // 2. Versión miniatura de 200x200 máx
    final thumbImage = fitImageToBounds(image, 200);
    final thumbWebp = img.encodeWebP(thumbImage, quality: 85);

    return ProductProcessedImages(
      highRes800Bytes: Uint8List.fromList(highResWebp),
      thumbnail200Bytes: Uint8List.fromList(thumbWebp),
    );
  } catch (_) {
    return ProductProcessedImages(
      highRes800Bytes: rawBytes,
      thumbnail200Bytes: rawBytes,
    );
  }
}


/// Ajusta proporcionalmente una imagen para que quepa dentro de un límite máx [targetMax] x [targetMax].
/// Si la imagen ya es menor o igual al límite, no se altera para preservar nitidez.
img.Image fitImageToBounds(img.Image image, int targetMax) {
  int w = image.width;
  int h = image.height;
  if (w <= targetMax && h <= targetMax) {
    return image;
  }

  if (w > h) {
    h = (h * targetMax / w).round();
    w = targetMax;
  } else {
    w = (w * targetMax / h).round();
    h = targetMax;
  }

  return img.copyResize(
    image,
    width: w,
    height: h,
    interpolation: img.Interpolation.linear,
  );
}
