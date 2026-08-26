import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/repositories/products_repository.dart';
import 'package:marcos_malaga_app/features/crm_inventory/domain/usecases/update_product_usecase.dart';

class MockProductsRepository extends Mock implements ProductsRepository {}

void main() {
  late UpdateProductUsecase usecase;
  late MockProductsRepository mockRepository;

  setUp(() {
    mockRepository = MockProductsRepository();
    usecase = UpdateProductUsecase(repo: mockRepository);
  });

  group('UpdateProductUsecase Tests', () {
    final tProduct = ProductEntity(
      id: 'NEW-001',
      name: 'Vestido Nuevo',
      description: 'Descripción',
      basePrice: 150.0,
      categoryIds: const ['vestidos'],
      designs: const [],
      isVisible: true,
      createdAt: DateTime.parse('2025-01-01T00:00:00Z'),
      deletedAt: null,
    );

    test('should call repository.updateProduct with the given product', () async {
      when(() => mockRepository.updateProduct(tProduct)).thenAnswer((_) async {});

      await usecase(tProduct);

      verify(() => mockRepository.updateProduct(tProduct)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
