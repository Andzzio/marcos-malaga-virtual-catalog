import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/features/catalog/domain/repositories/products_repository.dart';
import 'package:marcos_malaga_app/features/catalog/domain/usecases/get_product_by_id_usecase.dart';

class MockProductsRepository extends Mock implements ProductsRepository {}

void main() {
  late GetProductByIdUsecase usecase;
  late MockProductsRepository mockRepository;

  setUp(() {
    mockRepository = MockProductsRepository();
    usecase = GetProductByIdUsecase(repo: mockRepository);
  });

  group('GetProductByIdUsecase Tests', () {
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

    test('should get a product from the repository by ID', () async {
      when(
        () => mockRepository.getProductById(any()),
      ).thenAnswer((_) async => tProductEntity);

      final result = await usecase('PROD-001');

      expect(result, equals(tProductEntity));
      verify(() => mockRepository.getProductById('PROD-001')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return null when the repository does not find the product', () async {
      when(
        () => mockRepository.getProductById(any()),
      ).thenAnswer((_) async => null);

      final result = await usecase('NON-EXISTENT-ID');

      expect(result, isNull);
      verify(() => mockRepository.getProductById('NON-EXISTENT-ID')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
