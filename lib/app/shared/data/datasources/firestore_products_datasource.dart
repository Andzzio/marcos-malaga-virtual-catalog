import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marcos_malaga_app/app/shared/data/models/firestore/firestore_product_model.dart';
import 'package:marcos_malaga_app/app/shared/data/models/firestore/firestore_product_design_model.dart';
import 'package:marcos_malaga_app/app/shared/data/models/firestore/firestore_product_size_model.dart';

class FirestoreProductsDatasource {
  final FirebaseFirestore _firestore;

  FirestoreProductsDatasource(this._firestore);

  Future<List<FirestoreProductModel>> fetchProducts() async {
    final snapshot = await _firestore.collection('products').get();
    return snapshot.docs
        .map((doc) => FirestoreProductModel.fromFirestore(doc.data()))
        .toList();
  }

  Future<FirestoreProductModel?> fetchProductById(String id) async {
    final doc = await _firestore.collection('products').doc(id).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return FirestoreProductModel.fromFirestore(doc.data()!);
  }

  Future<FirestoreProductDesignModel?> fetchDesignById(
    String productId,
    String designId,
  ) async {
    final product = await fetchProductById(productId);
    if (product == null) {
      return null;
    }
    try {
      return product.designs.firstWhere((design) => design.id == designId);
    } catch (_) {
      return null;
    }
  }

  Future<FirestoreProductSizeModel?> fetchSizeByName(
    String productId,
    String designId,
    String sizeName,
  ) async {
    final design = await fetchDesignById(productId, designId);
    if (design == null) {
      return null;
    }
    try {
      return design.sizes.firstWhere((size) => size.size == sizeName);
    } catch (_) {
      return null;
    }
  }

  Future<void> createProduct(FirestoreProductModel product) async {
    await _firestore
        .collection('products')
        .doc(product.id)
        .set(product.toFirestore());
  }

  Future<void> updateProduct(FirestoreProductModel product) async {
    await _firestore
        .collection('products')
        .doc(product.id)
        .update(product.toFirestore());
  }

  Future<void> softDeleteProduct(String productId) async {
    await _firestore.collection('products').doc(productId).update({
      'deletedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> restoreProduct(String productId) async {
    await _firestore.collection('products').doc(productId).update({
      'deletedAt': null,
    });
  }

  Future<void> updateStock({
    required String productId,
    required String designId,
    required String sizeName,
    required int newStock,
  }) async {
    final docRef = _firestore.collection('products').doc(productId);

    await _firestore.runTransaction((transaction) async {
      final docSnapshot = await transaction.get(docRef);
      if (!docSnapshot.exists || docSnapshot.data() == null) {
        throw Exception('Product not found');
      }

      final product = FirestoreProductModel.fromFirestore(docSnapshot.data()!);

      final updatedDesigns = product.designs.map((design) {
        if (design.id != designId) {
          return design.toFirestore();
        }

        final updatedSizes = design.sizes.map((size) {
          if (size.size != sizeName) {
            return size.toFirestore();
          }

          final updatedSize = FirestoreProductSizeModel(
            size: size.size,
            sku: size.sku,
            stock: newStock,
          );
          return updatedSize.toFirestore();
        }).toList();

        return FirestoreProductDesignModel(
          id: design.id,
          name: design.name,
          hexCode: design.hexCode,
          imageUrls: design.imageUrls,
          swatchImageUrl: design.swatchImageUrl,
          sizes: [],
        ).toFirestore()..['sizes'] = updatedSizes;
      }).toList();

      transaction.update(docRef, {'designs': updatedDesigns});
    });
  }
}
