import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:marcos_malaga_app/app/shared/data/services/image_processing_service_impl.dart';

void main() {
  const service = ImageProcessingServiceImpl();

  group('ImageProcessingService Tests', () {
    test('isVideo should accurately identify video extensions and mime types', () {
      expect(service.isVideo('video.mp4'), isTrue);
      expect(service.isVideo('clip.MOV'), isTrue);
      expect(service.isVideo('clip.webm'), isTrue);
      expect(service.isVideo('file.bin', 'video/mp4'), isTrue);
      expect(service.isVideo('image.jpg'), isFalse);
      expect(service.isVideo('image.png', 'image/png'), isFalse);
      expect(service.isVideo('image.webp'), isFalse);
    });

    test('fitImageToBounds should scale down proportionally when exceeding target bounds', () {
      // Landscape 1600x800 into 800 box -> 800x400
      final landscape = img.Image(width: 1600, height: 800);
      final scaledLandscape = fitImageToBounds(landscape, 800);
      expect(scaledLandscape.width, equals(800));
      expect(scaledLandscape.height, equals(400));

      // Portrait 600x1200 into 800 box -> 400x800
      final portrait = img.Image(width: 600, height: 1200);
      final scaledPortrait = fitImageToBounds(portrait, 800);
      expect(scaledPortrait.width, equals(400));
      expect(scaledPortrait.height, equals(800));

      // Within bounds 500x500 into 800 box -> kept as 500x500
      final small = img.Image(width: 500, height: 500);
      final kept = fitImageToBounds(small, 800);
      expect(kept.width, equals(500));
      expect(kept.height, equals(500));
    });

    test('processBannerImageInIsolate should decode image and return valid WebP variants', () {
      final sample = img.Image(width: 1200, height: 600);
      final pngBytes = Uint8List.fromList(img.encodePng(sample));

      final result = processBannerImageInIsolate(pngBytes);

      expect(result.originalBytes, isNotEmpty);
      expect(result.thumbnail800Bytes, isNotEmpty);

      // Verify outputs are valid decodable WebPs
      final decodedOrig = img.decodeImage(result.originalBytes);
      final decodedThumb = img.decodeImage(result.thumbnail800Bytes);

      expect(decodedOrig, isNotNull);
      expect(decodedOrig!.width, equals(1200));
      expect(decodedOrig.height, equals(600));

      expect(decodedThumb, isNotNull);
      expect(decodedThumb!.width, equals(800));
      expect(decodedThumb.height, equals(400));
    });

    test('processProductImageInIsolate should generate 800x800 and 200x200 variants', () {
      final sample = img.Image(width: 1000, height: 1000);
      final pngBytes = Uint8List.fromList(img.encodePng(sample));

      final result = processProductImageInIsolate(pngBytes);

      final decodedHigh = img.decodeImage(result.highRes800Bytes);
      final decodedThumb = img.decodeImage(result.thumbnail200Bytes);

      expect(decodedHigh, isNotNull);
      expect(decodedHigh!.width, equals(800));
      expect(decodedHigh.height, equals(800));

      expect(decodedThumb, isNotNull);
      expect(decodedThumb!.width, equals(200));
      expect(decodedThumb.height, equals(200));
    });

    test('processBannerImageInIsolate should return fallback bytes if decoding fails', () {
      final invalidBytes = Uint8List.fromList([1, 2, 3, 4]);
      final result = processBannerImageInIsolate(invalidBytes);

      expect(result.originalBytes, equals(invalidBytes));
      expect(result.thumbnail800Bytes, equals(invalidBytes));
    });

    test('processProductImageInIsolate should return fallback bytes if decoding fails', () {
      final invalidBytes = Uint8List.fromList([1, 2, 3, 4]);
      final result = processProductImageInIsolate(invalidBytes);

      expect(result.highRes800Bytes, equals(invalidBytes));
      expect(result.thumbnail200Bytes, equals(invalidBytes));
    });
  });
}
