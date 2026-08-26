import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:marcos_malaga_app/app/shared/data/datasources/local_products_datasource.dart';
import 'package:marcos_malaga_app/features/catalog/data/models/product_model.dart';

void main() {
  Logger.level = Level.off;
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalProductsDatasource datasource;

  setUp(() {
    datasource = LocalProductsDatasource();
    rootBundle.evict('assets/json/products.json');
  });

  group('LocalProductsDatasource Tests', () {
    final tJsonString = jsonEncode([
      {
        'id': 'PROD-001',
        'name': 'Pantalón Palazzo',
        'description': 'Bello pantalón',
        'basePrice': 120.0,
        'categoryIds': ['pantalones'],
        'designs': [],
        'isVisible': true,
      },
    ]);

    test(
      'should return a List<ProductModel> when JSON is loaded successfully',
      () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMessageHandler('flutter/assets', (ByteData? message) async {
              final String key = utf8.decode(message!.buffer.asUint8List());
              if (key == 'assets/json/products.json') {
                return ByteData.view(utf8.encoder.convert(tJsonString).buffer);
              }
              return null;
            });

        final result = await datasource.fetchProducts();

        expect(result, isA<List<ProductModel>>());
        expect(result.length, 1);
        expect(result.first.id, 'PROD-001');
        expect(result.first.name, 'Pantalón Palazzo');
      },
    );

    test('should return an empty list when an exception occurs', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
            return null;
          });

      final result = await datasource.fetchProducts();

      expect(result, isA<List<ProductModel>>());
      expect(result, isEmpty);
    });

    test(
      'should return a ProductModel when the product is found by ID',
      () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMessageHandler('flutter/assets', (ByteData? message) async {
              return ByteData.view(utf8.encoder.convert(tJsonString).buffer);
            });

        final result = await datasource.fetchProductById('PROD-001');

        expect(result, isNotNull);
        expect(result?.id, 'PROD-001');
      },
    );

    test('should return null when the product is not found by ID', () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
            return ByteData.view(utf8.encoder.convert(tJsonString).buffer);
          });

      final result = await datasource.fetchProductById('NON-EXISTENT-ID');

      expect(result, isNull);
    });

    test(
      'should return null when an exception occurs in fetchProductById',
      () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMessageHandler('flutter/assets', (ByteData? message) async {
              return null;
            });

        final result = await datasource.fetchProductById('PROD-001');

        expect(result, isNull);
      },
    );
  });

  group('LocalProductsDatasource Write Tests', () {
    // Helper para inyectar el mock del asset con 1 producto
    void mockAsset(String jsonString) {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (ByteData? message) async {
        return ByteData.view(utf8.encoder.convert(jsonString).buffer);
      });
    }

    final tProductJson = jsonEncode([
      {
        'id': 'PROD-001',
        'name': 'Pantalón Palazzo',
        'description': 'Bello pantalón',
        'basePrice': 120.0,
        'categoryIds': ['pantalones'],
        'designs': [
          {
            'id': 'DES-001',
            'name': 'Vino',
            'hexCode': '#800020',
            'swatchImageUrl': null,
            'imageUrls': [],
            'sizes': [
              {'size': 'M', 'stock': 5, 'sku': null},
            ],
          }
        ],
        'isVisible': true,
        'deletedAt': null,
      },
    ]);

    test('createProduct adds a new product to the cache', () async {
      mockAsset(tProductJson);
      await datasource.fetchProducts(); // poblar cache

      final newProduct = ProductModel(
        id: 'PROD-NEW',
        name: 'Vestido Nuevo',
        description: 'Desc',
        basePrice: 80.0,
        categoryIds: [],
        designs: [],
        isVisible: true,
        createdAt: DateTime.parse('2025-01-01T00:00:00Z'),
      );

      await datasource.createProduct(newProduct);
      final result = await datasource.fetchProducts();

      expect(result.length, 2);
      expect(result.any((p) => p.id == 'PROD-NEW'), isTrue);
    });

    test('updateProduct replaces the existing product in cache', () async {
      mockAsset(tProductJson);
      await datasource.fetchProducts();

      final updated = ProductModel(
        id: 'PROD-001',
        name: 'Palazzo Actualizado',
        description: 'Desc',
        basePrice: 999.0,
        categoryIds: [],
        designs: [],
        isVisible: true,
        createdAt: DateTime.parse('2025-01-01T00:00:00Z'),
      );

      await datasource.updateProduct(updated);
      final result = await datasource.fetchProducts();

      expect(result.length, 1);
      expect(result.first.name, 'Palazzo Actualizado');
      expect(result.first.basePrice, 999.0);
    });

    test('softDeleteProduct sets deletedAt on the target product', () async {
      mockAsset(tProductJson);
      await datasource.fetchProducts();

      await datasource.softDeleteProduct('PROD-001');
      final result = await datasource.fetchProducts();

      expect(result.first.deletedAt, isNotNull);
    });

    test('restoreProduct sets deletedAt to null on the target product', () async {
      mockAsset(tProductJson);
      await datasource.fetchProducts();

      await datasource.softDeleteProduct('PROD-001');
      await datasource.restoreProduct('PROD-001');
      final result = await datasource.fetchProducts();

      expect(result.first.deletedAt, isNull);
    });

    test('updateStock modifies the stock of the correct size', () async {
      mockAsset(tProductJson);
      await datasource.fetchProducts();

      await datasource.updateStock(
        productId: 'PROD-001',
        designId: 'DES-001',
        sizeName: 'M',
        newStock: 99,
      );
      final result = await datasource.fetchProducts();
      final size = result.first.designs.first.sizes.first;

      expect(size.stock, 99);
    });
  });
}
