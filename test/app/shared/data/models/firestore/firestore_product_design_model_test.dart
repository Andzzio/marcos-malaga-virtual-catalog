import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/app/shared/data/models/firestore/firestore_product_design_model.dart';
import 'package:marcos_malaga_app/app/shared/data/models/firestore/firestore_product_size_model.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_design_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_size_entity.dart';

void main() {
  const tSizeModel = FirestoreProductSizeModel(
    size: 'M',
    sku: 'SKU-M',
    stock: 10,
  );

  const tSizeEntity = ProductSizeEntity(
    size: 'M',
    sku: 'SKU-M',
    stock: 10,
  );

  const tModel = FirestoreProductDesignModel(
    id: 'd1',
    name: 'Red',
    hexCode: 'FFFF0000',
    imageUrls: ['url1', 'url2'],
    swatchImageUrl: 'swatch1',
    sizes: [tSizeModel],
  );

  const tEntity = ProductDesignEntity(
    id: 'd1',
    name: 'Red',
    colorValue: 0xFFFF0000,
    swatchImageUrl: 'swatch1',
    imageUrls: ['url1', 'url2'],
    sizes: [tSizeEntity],
  );

  final tJson = {
    'id': 'd1',
    'name': 'Red',
    'hexCode': 'FFFF0000',
    'imageUrls': ['url1', 'url2'],
    'swatchImageUrl': 'swatch1',
    'sizes': [
      {
        'size': 'M',
        'sku': 'SKU-M',
        'stock': 10,
      }
    ],
  };

  test('fromFirestore returns a valid model', () {
    final result = FirestoreProductDesignModel.fromFirestore(tJson);
    expect(result, tModel);
  });

  test('toFirestore returns a valid map', () {
    final result = tModel.toFirestore();
    expect(result, tJson);
  });

  test('toEntity returns a valid entity', () {
    final result = tModel.toEntity();
    expect(result, tEntity);
  });

  test('fromEntity returns a valid model', () {
    final result = FirestoreProductDesignModel.fromEntity(tEntity);
    expect(result, tModel);
  });
}
