import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/repositories/products_repository.dart';
import 'package:marcos_malaga_app/features/crm_inventory/domain/usecases/create_product_usecase.dart';

class MockProductsRepository extends Mock implements ProductsRepository {}

void main() {
  late CreateProductUsecase usecase;
  late MockProductsRepository mockRepository;

  setUp(() {
    mockRepository = MockProductsRepository();
    usecase = CreateProductUsecase(repo: mockRepository);
  });

  group('CreateProductUsecase Tests', () {
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

    test(
      'should call repository.createProduct with the given product',
      () async {
        when(
          () => mockRepository.createProduct(tProduct),
        ).thenAnswer((_) async {});

        await usecase(tProduct);

        verify(() => mockRepository.createProduct(tProduct)).called(1);
        verifyNoMoreInteractions(mockRepository);
      },
    );
  });
}
