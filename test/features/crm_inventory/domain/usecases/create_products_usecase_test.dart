import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/repositories/products_repository.dart';
import 'package:marcos_malaga_app/features/crm_inventory/domain/usecases/create_products_usecase.dart';

class MockProductsRepository extends Mock implements ProductsRepository {}

void main() {
  late CreateProductsUsecase usecase;
  late MockProductsRepository mockRepository;

  final tProduct1 = ProductEntity(
    id: 'PROD-001',
    name: 'Vestido A',
    description: 'Desc',
    basePrice: 100.0,
    categoryIds: const [],
    designs: const [],
    isVisible: true,
    createdAt: DateTime.parse('2025-01-01T00:00:00Z'),
    deletedAt: null,
  );
  final tProduct2 = ProductEntity(
    id: 'PROD-002',
    name: 'Vestido B',
    description: 'Desc',
    basePrice: 120.0,
    categoryIds: const [],
    designs: const [],
    isVisible: true,
    createdAt: DateTime.parse('2025-01-01T00:00:00Z'),
    deletedAt: null,
  );

  setUp(() {
    mockRepository = MockProductsRepository();
    usecase = CreateProductsUsecase(repo: mockRepository);
    registerFallbackValue(tProduct1);
  });

  group('CreateProductsUsecase Tests', () {
    test('should call createProduct for each product in the list', () async {
      when(() => mockRepository.createProduct(any())).thenAnswer((_) async {});

      await usecase([tProduct1, tProduct2]);

      verify(() => mockRepository.createProduct(tProduct1)).called(1);
      verify(() => mockRepository.createProduct(tProduct2)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should do nothing when products list is empty', () async {
      await usecase([]);
      verifyNever(() => mockRepository.createProduct(any()));
    });
  });
}
