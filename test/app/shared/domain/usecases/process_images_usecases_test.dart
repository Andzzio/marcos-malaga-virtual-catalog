import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/app/shared/domain/services/image_processing_service.dart';
import 'package:marcos_malaga_app/app/shared/domain/usecases/process_banner_image_usecase.dart';
import 'package:marcos_malaga_app/app/shared/domain/usecases/process_product_image_usecase.dart';

class MockImageProcessingService extends Mock
    implements ImageProcessingService {}

void main() {
  late MockImageProcessingService mockService;
  late ProcessBannerImageUsecase processBannerUsecase;
  late ProcessProductImageUsecase processProductUsecase;

  setUp(() {
    mockService = MockImageProcessingService();
    processBannerUsecase = ProcessBannerImageUsecase(service: mockService);
    processProductUsecase = ProcessProductImageUsecase(service: mockService);
  });

  final tBytes = Uint8List.fromList([1, 2, 3]);

  test('ProcessBannerImageUsecase should delegate to service.processBannerImage', () async {
    final expected = BannerProcessedImages(
      originalBytes: tBytes,
      thumbnail800Bytes: tBytes,
    );
    when(() => mockService.processBannerImage(tBytes)).thenAnswer((_) async => expected);

    final result = await processBannerUsecase(tBytes);

    expect(result, equals(expected));
    verify(() => mockService.processBannerImage(tBytes)).called(1);
  });

  test('ProcessProductImageUsecase should delegate to service.processProductImage', () async {
    final expected = ProductProcessedImages(
      highRes800Bytes: tBytes,
      thumbnail200Bytes: tBytes,
    );
    when(() => mockService.processProductImage(tBytes)).thenAnswer((_) async => expected);

    final result = await processProductUsecase(tBytes);

    expect(result, equals(expected));
    verify(() => mockService.processProductImage(tBytes)).called(1);
  });
}
