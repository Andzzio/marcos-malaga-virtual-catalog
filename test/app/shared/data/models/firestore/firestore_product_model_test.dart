import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/app/shared/data/models/firestore/firestore_product_design_model.dart';
import 'package:marcos_malaga_app/app/shared/data/models/firestore/firestore_product_model.dart';
import 'package:marcos_malaga_app/app/shared/data/models/firestore/firestore_product_size_model.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_design_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_entity.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_size_entity.dart';

void main() {
  final tDate = DateTime(2026, 9, 4);
  final tTimestamp = Timestamp.fromDate(tDate);

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

  const tDesignModel = FirestoreProductDesignModel(
    id: 'd1',
    name: 'Red',
    hexCode: 'FFFF0000',
    imageUrls: ['url1', 'url2'],
    swatchImageUrl: 'swatch1',
    sizes: [tSizeModel],
  );

  const tDesignEntity = ProductDesignEntity(
    id: 'd1',
    name: 'Red',
    colorValue: 0xFFFF0000,
    swatchImageUrl: 'swatch1',
    imageUrls: ['url1', 'url2'],
    sizes: [tSizeEntity],
  );

  final tModel = FirestoreProductModel(
    id: 'p1',
    name: 'Dress',
    description: 'Nice dress',
    basePrice: 99.9,
    discountPrice: 79.9,
    categoryIds: const ['cat1'],
    designs: const [tDesignModel],
    isVisible: true,
    sizeChartImageUrl: 'chart1',
    createdAt: tTimestamp,
    deletedAt: null,
  );

  final tEntity = ProductEntity(
    id: 'p1',
    name: 'Dress',
    description: 'Nice dress',
    basePrice: 99.9,
    discountPrice: 79.9,
    categoryIds: const ['cat1'],
    designs: const [tDesignEntity],
    isVisible: true,
    sizeChartImageUrl: 'chart1',
    createdAt: tDate,
    deletedAt: null,
  );

  final tJson = {
    'id': 'p1',
    'name': 'Dress',
    'description': 'Nice dress',
    'basePrice': 99.9,
    'discountPrice': 79.9,
    'categoryIds': ['cat1'],
    'designs': [
      {
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
      }
    ],
    'isVisible': true,
    'sizeChartImageUrl': 'chart1',
    'createdAt': tTimestamp,
  };

  test('fromFirestore returns a valid model', () {
    final result = FirestoreProductModel.fromFirestore(tJson);
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
    final result = FirestoreProductModel.fromEntity(tEntity);
    expect(result, tModel);
  });
}
