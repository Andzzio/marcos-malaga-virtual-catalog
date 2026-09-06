import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/app/shared/data/models/firestore/firestore_product_size_model.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/product_size_entity.dart';

void main() {
  const tModel = FirestoreProductSizeModel(
    size: 'M',
    sku: 'SKU-M',
    stock: 10,
  );

  const tEntity = ProductSizeEntity(
    size: 'M',
    sku: 'SKU-M',
    stock: 10,
  );

  final tJson = {
    'size': 'M',
    'sku': 'SKU-M',
    'stock': 10,
  };

  test('fromFirestore returns a valid model', () {
    final result = FirestoreProductSizeModel.fromFirestore(tJson);
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
    final result = FirestoreProductSizeModel.fromEntity(tEntity);
    expect(result, tModel);
  });
}
