import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/repositories/products_repository.dart';
import 'package:marcos_malaga_app/app/shared/domain/usecases/get_products_usecase.dart';

class MockProductsRepository extends Mock implements ProductsRepository {}

void main() {
  late GetProductsUsecase usecase;
  late MockProductsRepository mockRepository;

  setUp(() {
    mockRepository = MockProductsRepository();
    usecase = GetProductsUsecase(repo: mockRepository);
  });

  group('GetProductsUsecase Tests', () {
    final tProductEntity = ProductEntity(
      id: 'PROD-001',
      name: 'Pantalón Palazzo',
      description: 'Bello pantalón',
      basePrice: 120.0,
      categoryIds: ['pantalones'],
      designs: [],
      isVisible: true,
      createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
    );

    final tProductsList = [tProductEntity];

    test('should get a list of products from the repository', () async {
      when(
        () => mockRepository.getProducts(),
      ).thenAnswer((_) async => tProductsList);

      final result = await usecase();

      expect(result, tProductsList);
      verify(() => mockRepository.getProducts()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
