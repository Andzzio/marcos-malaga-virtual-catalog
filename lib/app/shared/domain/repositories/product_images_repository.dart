import 'dart:typed_data';

abstract class ProductImagesRepository {
  Future<String> uploadProductImage({
    required Uint8List bytes,
    required String filename,
  });

  Future<void> deleteProductImage(String url);
}
