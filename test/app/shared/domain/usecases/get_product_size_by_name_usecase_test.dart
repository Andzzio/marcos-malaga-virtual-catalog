import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_size_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/repositories/products_repository.dart';
import 'package:marcos_malaga_app/app/shared/domain/usecases/get_product_size_by_name_usecase.dart';

class MockProductsRepository extends Mock implements ProductsRepository {}

void main() {
  late MockProductsRepository mockRepo;
  late GetProductSizeByNameUseCase useCase;

  setUp(() {
    mockRepo = MockProductsRepository();
    useCase = GetProductSizeByNameUseCase(repo: mockRepo);
  });

  test('should return ProductSizeEntity when found in repo', () async {
    const tSize = ProductSizeEntity(size: 'M', stock: 10);

    when(
      () => mockRepo.getSizeByName('p1', 'd1', 'M'),
    ).thenAnswer((_) async => tSize);

    final result = await useCase('p1', 'd1', 'M');

    expect(result, tSize);
    verify(() => mockRepo.getSizeByName('p1', 'd1', 'M')).called(1);
  });

  test('should return null when not found in repo', () async {
    when(
      () => mockRepo.getSizeByName('p1', 'd1', 'M'),
    ).thenAnswer((_) async => null);

    final result = await useCase('p1', 'd1', 'M');

    expect(result, isNull);
    verify(() => mockRepo.getSizeByName('p1', 'd1', 'M')).called(1);
  });
}
