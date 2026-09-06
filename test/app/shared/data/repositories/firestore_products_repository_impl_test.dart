import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:marcos_malaga_app/app/shared/data/datasources/firestore_products_datasource.dart';
import 'package:marcos_malaga_app/app/shared/data/models/firestore/firestore_product_model.dart';
import 'package:marcos_malaga_app/app/shared/data/models/firestore/firestore_product_design_model.dart';
import 'package:marcos_malaga_app/app/shared/data/models/firestore/firestore_product_size_model.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_design_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_size_entity.dart';
import 'package:marcos_malaga_app/app/shared/data/repositories/firestore_products_repository_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MockFirestoreProductsDatasource extends Mock implements FirestoreProductsDatasource {}
class FakeFirestoreProductModel extends Fake implements FirestoreProductModel {}

void main() {
  late MockFirestoreProductsDatasource datasource;
  late FirestoreProductsRepositoryImpl repository;
  
  setUpAll(() {
    registerFallbackValue(FakeFirestoreProductModel());
  });

  setUp(() {
    datasource = MockFirestoreProductsDatasource();
    repository = FirestoreProductsRepositoryImpl(datasource);
  });

  final date = DateTime(2023, 1, 1);
  final timestamp = Timestamp.fromDate(date);

  final sizeModel = FirestoreProductSizeModel(
    size: 'M',
    sku: 'SKU123',
    stock: 10,
  );

  final designModel = FirestoreProductDesignModel(
    id: 'design1',
    name: 'Red',
    hexCode: 'FF0000',
    imageUrls: const ['url1'],
    swatchImageUrl: 'swatch1',
    sizes: [sizeModel],
  );

  final productModel = FirestoreProductModel(
    id: 'prod1',
    name: 'Dress',
    description: 'A dress',
    basePrice: 100,
    categoryIds: const ['cat1'],
    designs: [designModel],
    isVisible: true,
    createdAt: timestamp,
  );

  final productEntity = productModel.toEntity();

  group('FirestoreProductsRepositoryImpl', () {
    test('getProducts returns entities from datasource', () async {
      when(() => datasource.fetchProducts()).thenAnswer((_) async => [productModel]);

      final result = await repository.getProducts();

      expect(result, [productEntity]);
      verify(() => datasource.fetchProducts()).called(1);
    });

    test('getProductById returns entity from datasource', () async {
      when(() => datasource.fetchProductById('prod1')).thenAnswer((_) async => productModel);

      final result = await repository.getProductById('prod1');

      expect(result, productEntity);
      verify(() => datasource.fetchProductById('prod1')).called(1);
    });

    test('getProductById returns null if datasource returns null', () async {
      when(() => datasource.fetchProductById('prod1')).thenAnswer((_) async => null);

      final result = await repository.getProductById('prod1');

      expect(result, isNull);
      verify(() => datasource.fetchProductById('prod1')).called(1);
    });

    test('getDesignById returns entity from datasource', () async {
      when(() => datasource.fetchDesignById('prod1', 'design1')).thenAnswer((_) async => designModel);

      final result = await repository.getDesignById('prod1', 'design1');

      expect(result, productEntity.designs.first);
      verify(() => datasource.fetchDesignById('prod1', 'design1')).called(1);
    });

    test('getDesignById returns null if not found', () async {
      when(() => datasource.fetchDesignById('prod1', 'design1')).thenAnswer((_) async => null);

      final result = await repository.getDesignById('prod1', 'design1');

      expect(result, isNull);
      verify(() => datasource.fetchDesignById('prod1', 'design1')).called(1);
    });

    test('getSizeByName returns entity from datasource', () async {
      when(() => datasource.fetchSizeByName('prod1', 'design1', 'M')).thenAnswer((_) async => sizeModel);

      final result = await repository.getSizeByName('prod1', 'design1', 'M');

      expect(result, productEntity.designs.first.sizes.first);
      verify(() => datasource.fetchSizeByName('prod1', 'design1', 'M')).called(1);
    });

    test('createProduct calls datasource with correct model', () async {
      when(() => datasource.createProduct(any())).thenAnswer((_) async {});

      await repository.createProduct(productEntity);

      verify(() => datasource.createProduct(productModel)).called(1);
    });

    test('updateProduct calls datasource with correct model', () async {
      when(() => datasource.updateProduct(any())).thenAnswer((_) async {});

      await repository.updateProduct(productEntity);

      verify(() => datasource.updateProduct(productModel)).called(1);
    });

    test('softDeleteProduct calls datasource', () async {
      when(() => datasource.softDeleteProduct('prod1')).thenAnswer((_) async {});

      await repository.softDeleteProduct('prod1');

      verify(() => datasource.softDeleteProduct('prod1')).called(1);
    });

    test('restoreProduct calls datasource', () async {
      when(() => datasource.restoreProduct('prod1')).thenAnswer((_) async {});

      await repository.restoreProduct('prod1');

      verify(() => datasource.restoreProduct('prod1')).called(1);
    });

    test('updateStock calls datasource', () async {
      when(() => datasource.updateStock(
        productId: 'prod1',
        designId: 'design1',
        sizeName: 'M',
        newStock: 5,
      )).thenAnswer((_) async {});

      await repository.updateStock(
        productId: 'prod1',
        designId: 'design1',
        sizeName: 'M',
        newStock: 5,
      );

      verify(() => datasource.updateStock(
        productId: 'prod1',
        designId: 'design1',
        sizeName: 'M',
        newStock: 5,
      )).called(1);
    });
  });
}
