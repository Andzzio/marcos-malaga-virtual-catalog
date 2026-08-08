import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/catalog/data/models/product_design_model.dart';
import 'package:marcos_malaga_app/features/catalog/data/models/product_model.dart';
import 'package:marcos_malaga_app/features/catalog/data/models/product_size_model.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/product_design_entity.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/product_size_entity.dart';

void main() {
  const tProductSizeModel = ProductSizeModel(
    size: 'S',
    stock: 5,
    sku: 'PAL-VIN-S',
  );

  const tProductDesignModel = ProductDesignModel(
    id: 'DES-123',
    name: 'Vino',
    hexCode: '#800020',
    swatchImageUrl: null,
    imageUrls: ['img1.jpg'],
    sizes: [tProductSizeModel],
  );

  final tProductModel = ProductModel(
    id: 'PROD-001',
    name: 'Pantalón Palazzo',
    description: 'Bello pantalón',
    basePrice: 120.0,
    discountPrice: 100.0,
    categoryIds: ['pantalones'],
    designs: [tProductDesignModel],
    isVisible: true,
    sizeChartImageUrl: null,
    createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
  );

  const tProductSizeEntity = ProductSizeEntity(
    size: 'S',
    stock: 5,
    sku: 'PAL-VIN-S',
  );

  const tProductDesignEntity = ProductDesignEntity(
    id: 'DES-123',
    name: 'Vino',
    colorValue: 0xFF800020,
    swatchImageUrl: null,
    imageUrls: ['img1.jpg'],
    sizes: [tProductSizeEntity],
  );

  final tProductEntity = ProductEntity(
    id: 'PROD-001',
    name: 'Pantalón Palazzo',
    description: 'Bello pantalón',
    basePrice: 120.0,
    discountPrice: 100.0,
    categoryIds: ['pantalones'],
    designs: [tProductDesignEntity],
    isVisible: true,
    sizeChartImageUrl: null,
    createdAt: DateTime.parse('2024-01-01T00:00:00Z'),
  );

  final tJson = {
    'id': 'PROD-001',
    'name': 'Pantalón Palazzo',
    'description': 'Bello pantalón',
    'basePrice': 120.0,
    'discountPrice': 100.0,
    'categoryIds': ['pantalones'],
    'designs': [
      {
        'id': 'DES-123',
        'name': 'Vino',
        'hexCode': '#800020',
        'swatchImageUrl': null,
        'imageUrls': ['img1.jpg'],
        'sizes': [
          {'size': 'S', 'stock': 5, 'sku': 'PAL-VIN-S'},
        ],
      },
    ],
    'isVisible': true,
    'sizeChartImageUrl': null,
    'createdAt': '2024-01-01T00:00:00.000Z',
  };

  group('ProductModel Tests', () {
    test('fromJson should return a valid model', () {
      final result = ProductModel.fromJson(tJson);
      expect(result.id, 'PROD-001');
      expect(result.name, 'Pantalón Palazzo');
      expect(result.basePrice, 120.0);
      expect(result.designs.length, 1);
      expect(result.designs.first.sizes.first.size, 'S');
    });

    test('toJson should return a JSON map containing proper data', () {
      final result = tProductModel.toJson();
      expect(result, tJson);
    });

    test('toEntity should convert model to entity correctly', () {
      final result = tProductModel.toEntity();
      expect(result, equals(tProductEntity));
    });

    test('fromEntity should convert entity to model correctly', () {
      final result = ProductModel.fromEntity(tProductEntity);
      expect(result.id, tProductModel.id);
      expect(result.basePrice, tProductModel.basePrice);
      expect(result.designs.first.id, tProductModel.designs.first.id);
    });
  });
}
