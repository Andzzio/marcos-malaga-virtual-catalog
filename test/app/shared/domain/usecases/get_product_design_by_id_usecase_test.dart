import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_design_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/repositories/products_repository.dart';
import 'package:marcos_malaga_app/app/shared/domain/usecases/get_product_design_by_id_usecase.dart';

class MockProductsRepository extends Mock implements ProductsRepository {}

void main() {
  late MockProductsRepository mockRepo;
  late GetProductDesignByIdUseCase useCase;

  setUp(() {
    mockRepo = MockProductsRepository();
    useCase = GetProductDesignByIdUseCase(repo: mockRepo);
  });

  test('should return ProductDesignEntity when found in repo', () async {
    const tDesign = ProductDesignEntity(
      id: 'd1',
      name: 'Design 1',
      imageUrls: [],
      sizes: [],
    );

    when(
      () => mockRepo.getDesignById('p1', 'd1'),
    ).thenAnswer((_) async => tDesign);

    final result = await useCase('p1', 'd1');

    expect(result, tDesign);
    verify(() => mockRepo.getDesignById('p1', 'd1')).called(1);
  });

  test('should return null when not found in repo', () async {
    when(
      () => mockRepo.getDesignById('p1', 'd1'),
    ).thenAnswer((_) async => null);

    final result = await useCase('p1', 'd1');

    expect(result, isNull);
    verify(() => mockRepo.getDesignById('p1', 'd1')).called(1);
  });
}
