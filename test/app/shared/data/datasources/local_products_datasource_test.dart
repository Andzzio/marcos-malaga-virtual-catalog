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
}
