import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marcos_malaga_app/app/shared/data/datasources/firestore_products_datasource.dart';
import 'package:marcos_malaga_app/app/shared/data/models/firestore/firestore_product_model.dart';
import 'package:marcos_malaga_app/app/shared/data/models/firestore/firestore_product_design_model.dart';
import 'package:marcos_malaga_app/app/shared/data/models/firestore/firestore_product_size_model.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late FirestoreProductsDatasource datasource;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    datasource = FirestoreProductsDatasource(firestore);
  });

  final sampleProduct = FirestoreProductModel(
    id: 'prod1',
    name: 'Vestido',
    description: 'Vestido elegante',
    basePrice: 100.0,
    categoryIds: const ['cat1'],
    isVisible: true,
    createdAt: Timestamp.fromDate(DateTime(2023, 1, 1)),
    designs: const [
      FirestoreProductDesignModel(
        id: 'des1',
        name: 'Rojo',
        hexCode: '#FF0000',
        imageUrls: ['url1'],
        sizes: [
          FirestoreProductSizeModel(size: 'S', sku: 'S1', stock: 10),
          FirestoreProductSizeModel(size: 'M', sku: 'M1', stock: 5),
        ],
      ),
      FirestoreProductDesignModel(
        id: 'des2',
        name: 'Azul',
        hexCode: '#0000FF',
        imageUrls: ['url2'],
        sizes: [
          FirestoreProductSizeModel(size: 'L', sku: 'L1', stock: 2),
        ],
      )
    ],
  );

  test('createProduct inserts a document in products collection', () async {
    await datasource.createProduct(sampleProduct);
    final doc = await firestore.collection('products').doc('prod1').get();
    expect(doc.exists, isTrue);
    expect(doc.data()?['name'], 'Vestido');
  });

  test('fetchProducts returns a list of products', () async {
    await firestore.collection('products').doc(sampleProduct.id).set(sampleProduct.toFirestore());
    final products = await datasource.fetchProducts();
    expect(products.length, 1);
    expect(products.first.id, 'prod1');
  });

  test('fetchProductById returns correct product or null', () async {
    await firestore.collection('products').doc(sampleProduct.id).set(sampleProduct.toFirestore());
    final product = await datasource.fetchProductById('prod1');
    expect(product, isNotNull);
    expect(product?.name, 'Vestido');
    final notFound = await datasource.fetchProductById('prod2');
    expect(notFound, isNull);
  });

  test('fetchDesignById returns design if it exists', () async {
    await firestore.collection('products').doc(sampleProduct.id).set(sampleProduct.toFirestore());
    final design = await datasource.fetchDesignById('prod1', 'des1');
    expect(design, isNotNull);
    expect(design?.name, 'Rojo');
    final missingDesign = await datasource.fetchDesignById('prod1', 'des99');
    expect(missingDesign, isNull);
  });

  test('fetchSizeByName returns size if it exists', () async {
    await firestore.collection('products').doc(sampleProduct.id).set(sampleProduct.toFirestore());
    final size = await datasource.fetchSizeByName('prod1', 'des1', 'M');
    expect(size, isNotNull);
    expect(size?.stock, 5);
    final missingSize = await datasource.fetchSizeByName('prod1', 'des1', 'XL');
    expect(missingSize, isNull);
  });

  test('updateProduct updates fields', () async {
    await firestore.collection('products').doc(sampleProduct.id).set(sampleProduct.toFirestore());
    final updatedProduct = FirestoreProductModel(
      id: 'prod1',
      name: 'Vestido Modificado',
      description: sampleProduct.description,
      basePrice: 120.0,
      categoryIds: sampleProduct.categoryIds,
      isVisible: sampleProduct.isVisible,
      createdAt: sampleProduct.createdAt,
      designs: sampleProduct.designs,
    );
    await datasource.updateProduct(updatedProduct);
    final doc = await firestore.collection('products').doc('prod1').get();
    expect(doc.data()?['name'], 'Vestido Modificado');
    expect(doc.data()?['basePrice'], 120.0);
  });

  test('softDeleteProduct sets deletedAt field', () async {
    await firestore.collection('products').doc(sampleProduct.id).set(sampleProduct.toFirestore());
    await datasource.softDeleteProduct('prod1');
    final doc = await firestore.collection('products').doc('prod1').get();
    expect(doc.data()?['deletedAt'], isNotNull);
  });

  test('restoreProduct clears deletedAt field', () async {
    final deletedProduct = FirestoreProductModel(
      id: 'prod1',
      name: 'Vestido',
      description: 'Vestido elegante',
      basePrice: 100.0,
      categoryIds: const ['cat1'],
      isVisible: true,
      createdAt: Timestamp.fromDate(DateTime(2023, 1, 1)),
      deletedAt: Timestamp.now(),
      designs: const [],
    );
    await firestore.collection('products').doc(deletedProduct.id).set(deletedProduct.toFirestore());
    await datasource.restoreProduct('prod1');
    final doc = await firestore.collection('products').doc('prod1').get();
    expect(doc.data()?['deletedAt'], isNull);
  });

  test('updateStock uses transaction to update deeply nested stock', () async {
    await firestore.collection('products').doc(sampleProduct.id).set(sampleProduct.toFirestore());
    await datasource.updateStock(
      productId: 'prod1',
      designId: 'des1',
      sizeName: 'M',
      newStock: 25,
    );
    final doc = await firestore.collection('products').doc('prod1').get();
    final data = doc.data()!;
    final parsed = FirestoreProductModel.fromFirestore(data);
    final updatedDesign = parsed.designs.firstWhere((d) => d.id == 'des1');
    final updatedSize = updatedDesign.sizes.firstWhere((s) => s.size == 'M');
    expect(updatedSize.stock, 25);
    final otherSize = updatedDesign.sizes.firstWhere((s) => s.size == 'S');
    expect(otherSize.stock, 10);
    final otherDesign = parsed.designs.firstWhere((d) => d.id == 'des2');
    expect(otherDesign.sizes.first.stock, 2);
  });
}
