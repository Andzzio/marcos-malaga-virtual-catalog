import 'dart:typed_data';

import 'package:marcos_malaga_app/app/shared/domain/repositories/product_images_repository.dart';

class UploadProductImageUsecase {
  final ProductImagesRepository repo;
  const UploadProductImageUsecase({required this.repo});

  Future<String> call({
    required Uint8List bytes,
    required String filename,
  }) =>
      repo.uploadProductImage(bytes: bytes, filename: filename);
}
