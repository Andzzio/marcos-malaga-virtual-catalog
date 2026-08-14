import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/features/catalog/data/models/product_size_model.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_size_entity.dart';

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

  final tJson = {'size': 'S', 'stock': 5, 'sku': 'PAL-VIN-S'};

  group('ProductSizeModel Tests', () {
    test('fromJson should return a valid model', () {
      final result = ProductSizeModel.fromJson(tJson);
      expect(result.size, 'S');
      expect(result.stock, 5);
      expect(result.sku, 'PAL-VIN-S');
    });

    test('toJson should return a JSON map containing proper data', () {
      final result = tProductSizeModel.toJson();
      expect(result, tJson);
    });

    test('toEntity should convert model to entity correctly', () {
      final result = tProductSizeModel.toEntity();
      expect(result, equals(tProductSizeEntity));
    });

    test('fromEntity should convert entity to model correctly', () {
      final result = ProductSizeModel.fromEntity(tProductSizeEntity);
      expect(result.size, tProductSizeModel.size);
      expect(result.stock, tProductSizeModel.stock);
      expect(result.sku, tProductSizeModel.sku);
    });
  });
}
