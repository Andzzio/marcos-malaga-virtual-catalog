import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/catalog/data/models/product_design_model.dart';
import 'package:marcos_malaga_app/features/catalog/data/models/product_size_model.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/product_design_entity.dart';
import 'package:marcos_malaga_app/features/catalog/domain/entities/product_size_entity.dart';

void main() {
  const tProductSizeModel = ProductSizeModel(
    size: 'S',
    stock: 5,
    sku: 'PAL-VIN-S',
  );

  const tProductSizeEntity = ProductSizeEntity(
    size: 'S',
    stock: 5,
    sku: 'PAL-VIN-S',
  );

  const tProductDesignModel = ProductDesignModel(
    id: 'DES-123',
    name: 'Vino',
    hexCode: '#800020',
    swatchImageUrl: null,
    imageUrls: ['img1.jpg', 'img2.jpg'],
    sizes: [tProductSizeModel],
  );

  const tProductDesignEntity = ProductDesignEntity(
    id: 'DES-123',
    name: 'Vino',
    colorValue: 0xFF800020,
    swatchImageUrl: null,
    imageUrls: ['img1.jpg', 'img2.jpg'],
    sizes: [tProductSizeEntity],
  );

  final tJson = {
    'id': 'DES-123',
    'name': 'Vino',
    'hexCode': '#800020',
    'swatchImageUrl': null,
    'imageUrls': ['img1.jpg', 'img2.jpg'],
    'sizes': [
      {'size': 'S', 'stock': 5, 'sku': 'PAL-VIN-S'},
    ],
  };

  group('ProductDesignModel Tests', () {
    test('fromJson should return a valid model', () {
      final result = ProductDesignModel.fromJson(tJson);
      expect(result.id, 'DES-123');
      expect(result.name, 'Vino');
      expect(result.hexCode, '#800020');
      expect(result.imageUrls.length, 2);
      expect(result.sizes.first.size, 'S');
    });

    test('toJson should return a JSON map containing proper data', () {
      final result = tProductDesignModel.toJson();
      expect(result, tJson);
    });

    test('toEntity should convert model to entity correctly', () {
      final result = tProductDesignModel.toEntity();
      expect(result, equals(tProductDesignEntity));
    });

    test('fromEntity should convert entity to model correctly', () {
      final result = ProductDesignModel.fromEntity(tProductDesignEntity);
      expect(result.id, tProductDesignModel.id);
      expect(result.name, tProductDesignModel.name);
      expect(result.imageUrls, tProductDesignModel.imageUrls);
      expect(result.sizes.first.size, tProductDesignModel.sizes.first.size);
    });
  });
}
