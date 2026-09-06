import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/app/shared/data/datasources/local_products_datasource.dart';
import 'package:marcos_malaga_app/features/catalog/data/models/product_model.dart';
import 'package:marcos_malaga_app/app/shared/data/repositories/local_products_repository_impl.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';

class MockLocalProductsDatasource extends Mock
    implements LocalProductsDatasource {}

class FakeProductModel extends Fake implements ProductModel {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeProductModel());
  });
  late LocalProductsRepositoryImpl repository;
  late MockLocalProductsDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockLocalProductsDatasource();
    repository = LocalProductsRepositoryImpl(datasource: mockDatasource);
  });

  group('LocalProductsRepositoryImpl Tests', () {
    final tProductModel = ProductModel(
      id: 'PROD-001',
      name: 'Pantalón Palazzo',
      description: 'Bello pantalón',
      basePrice: 120.0,
      categoryIds: ['pantalones'],
      designs: [],
      isVisible: true,
      createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
    );

    final tProductEntity = tProductModel.toEntity();

    test(
      'should return List<ProductEntity> when datasource succeeds',
      () async {
        when(
          () => mockDatasource.fetchProducts(),
        ).thenAnswer((_) async => [tProductModel]);

        final result = await repository.getProducts();

        verify(() => mockDatasource.fetchProducts()).called(1);
        expect(result, isA<List<ProductEntity>>());
        expect(result.length, 1);
        expect(result.first, equals(tProductEntity));
      },
    );

    test('should return empty list if datasource returns empty list', () async {
      when(() => mockDatasource.fetchProducts()).thenAnswer((_) async => []);

      final result = await repository.getProducts();

      verify(() => mockDatasource.fetchProducts()).called(1);
      expect(result, isA<List<ProductEntity>>());
      expect(result, isEmpty);
    });

    test(
      'should return ProductEntity when getProductById finds a product',
      () async {
        when(
          () => mockDatasource.fetchProductById(any()),
        ).thenAnswer((_) async => tProductModel);

        final result = await repository.getProductById('PROD-001');

        verify(() => mockDatasource.fetchProductById('PROD-001')).called(1);
        expect(result, isA<ProductEntity>());
        expect(result, equals(tProductEntity));
      },
    );

    test(
      'should return null when getProductById does not find a product',
      () async {
        when(
          () => mockDatasource.fetchProductById(any()),
        ).thenAnswer((_) async => null);

        final result = await repository.getProductById('NON-EXISTENT-ID');

        verify(
          () => mockDatasource.fetchProductById('NON-EXISTENT-ID'),
        ).called(1);
        expect(result, isNull);
      },
    );
  });

  group('LocalProductsRepositoryImpl Write Tests', () {
    final tProductEntity = ProductEntity(
      id: 'PROD-001',
      name: 'Pantalón Palazzo',
      description: 'Bello pantalón',
      basePrice: 120.0,
      categoryIds: ['pantalones'],
      designs: [],
      isVisible: true,
      createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
      deletedAt: null,
    );

    test(
      'createProduct calls datasource.createProduct with converted model',
      () async {
        when(
          () => mockDatasource.createProduct(any()),
        ).thenAnswer((_) async {});

        await repository.createProduct(tProductEntity);

        verify(() => mockDatasource.createProduct(any())).called(1);
        verifyNoMoreInteractions(mockDatasource);
      },
    );

    test(
      'updateProduct calls datasource.updateProduct with converted model',
      () async {
        when(
          () => mockDatasource.updateProduct(any()),
        ).thenAnswer((_) async {});

        await repository.updateProduct(tProductEntity);

        verify(() => mockDatasource.updateProduct(any())).called(1);
        verifyNoMoreInteractions(mockDatasource);
      },
    );

    test(
      'softDeleteProduct calls datasource.softDeleteProduct with id',
      () async {
        when(
          () => mockDatasource.softDeleteProduct(any()),
        ).thenAnswer((_) async {});

        await repository.softDeleteProduct('PROD-001');

        verify(() => mockDatasource.softDeleteProduct('PROD-001')).called(1);
        verifyNoMoreInteractions(mockDatasource);
      },
    );

    test('restoreProduct calls datasource.restoreProduct with id', () async {
      when(() => mockDatasource.restoreProduct(any())).thenAnswer((_) async {});

      await repository.restoreProduct('PROD-001');

      verify(() => mockDatasource.restoreProduct('PROD-001')).called(1);
      verifyNoMoreInteractions(mockDatasource);
    });

    test(
      'updateStock calls datasource.updateStock with correct params',
      () async {
        when(
          () => mockDatasource.updateStock(
            productId: any(named: 'productId'),
            designId: any(named: 'designId'),
            sizeName: any(named: 'sizeName'),
            newStock: any(named: 'newStock'),
          ),
        ).thenAnswer((_) async {});

        await repository.updateStock(
          productId: 'PROD-001',
          designId: 'DES-001',
          sizeName: 'M',
          newStock: 10,
        );

        verify(
          () => mockDatasource.updateStock(
            productId: 'PROD-001',
            designId: 'DES-001',
            sizeName: 'M',
            newStock: 10,
          ),
        ).called(1);
        verifyNoMoreInteractions(mockDatasource);
      },
    );
  });
}
