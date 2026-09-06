import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:marcos_malaga_app/app/core/utils/app_logger.dart';
import 'package:marcos_malaga_app/features/catalog/data/models/product_model.dart';
import 'package:marcos_malaga_app/features/catalog/data/models/product_design_model.dart';
import 'package:marcos_malaga_app/features/catalog/data/models/product_size_model.dart';

class LocalProductsDatasource {
  static const String _jsonRoute = 'assets/json/products.json';

  List<ProductModel>? _cache;

  Future<List<ProductModel>> fetchProducts() async {
    if (_cache != null) return _cache!;
    final List<ProductModel> products = [];
    try {
      final jsonString = await rootBundle.loadString(_jsonRoute);
      final jsonDecoded = jsonDecode(jsonString) as List<dynamic>;
      for (final entry in jsonDecoded) {
        products.add(ProductModel.fromJson(entry as Map<String, dynamic>));
      }
      _cache = products;
      return _cache!;
    } catch (e, stackTrace) {
      AppLogger.e('Error loading "$_jsonRoute" at $stackTrace with error: $e');
      return products;
    }
  }

  Future<ProductModel?> fetchProductById(String id) async {
    final products = await fetchProducts();
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<ProductDesignModel?> fetchDesignById(
    String productId,
    String designId,
  ) async {
    final product = await fetchProductById(productId);
    if (product == null) return null;

    try {
      return product.designs.firstWhere((d) => d.id == designId);
    } catch (_) {
      return null;
    }
  }

  Future<ProductSizeModel?> fetchSizeByName(
    String productId,
    String designId,
    String sizeName,
  ) async {
    final design = await fetchDesignById(productId, designId);
    if (design == null) return null;

    try {
      return design.sizes.firstWhere((s) => s.size == sizeName);
    } catch (_) {
      return null;
    }
  }

  Future<void> createProduct(ProductModel product) async {
    final products = await fetchProducts();
    _cache = [...products, product];
  }

  Future<void> updateProduct(ProductModel product) async {
    final products = await fetchProducts();
    _cache = products.map((p) => p.id == product.id ? product : p).toList();
  }

  Future<void> softDeleteProduct(String productId) async {
    final products = await fetchProducts();
    _cache = products.map((p) {
      if (p.id != productId) return p;
      return ProductModel(
        id: p.id,
        name: p.name,
        description: p.description,
        basePrice: p.basePrice,
        discountPrice: p.discountPrice,
        categoryIds: p.categoryIds,
        designs: p.designs,
        isVisible: p.isVisible,
        sizeChartImageUrl: p.sizeChartImageUrl,
        createdAt: p.createdAt,
        deletedAt: DateTime.now(),
      );
    }).toList();
  }

  Future<void> restoreProduct(String productId) async {
    final products = await fetchProducts();
    _cache = products.map((p) {
      if (p.id != productId) return p;
      return ProductModel(
        id: p.id,
        name: p.name,
        description: p.description,
        basePrice: p.basePrice,
        discountPrice: p.discountPrice,
        categoryIds: p.categoryIds,
        designs: p.designs,
        isVisible: p.isVisible,
        sizeChartImageUrl: p.sizeChartImageUrl,
        createdAt: p.createdAt,
        deletedAt: null,
      );
    }).toList();
  }

  Future<void> updateStock({
    required String productId,
    required String designId,
    required String sizeName,
    required int newStock,
  }) async {
    final products = await fetchProducts();
    _cache = products.map((p) {
      if (p.id != productId) return p;
      final updatedDesigns = p.designs.map((d) {
        if (d.id != designId) return d;
        final updatedSizes = d.sizes.map((s) {
          if (s.size != sizeName) return s;
          return ProductSizeModel(size: s.size, stock: newStock, sku: s.sku);
        }).toList();
        return ProductDesignModel(
          id: d.id,
          name: d.name,
          hexCode: d.hexCode,
          swatchImageUrl: d.swatchImageUrl,
          imageUrls: d.imageUrls,
          sizes: updatedSizes,
        );
      }).toList();
      return ProductModel(
        id: p.id,
        name: p.name,
        description: p.description,
        basePrice: p.basePrice,
        discountPrice: p.discountPrice,
        categoryIds: p.categoryIds,
        designs: updatedDesigns,
        isVisible: p.isVisible,
        sizeChartImageUrl: p.sizeChartImageUrl,
        createdAt: p.createdAt,
        deletedAt: p.deletedAt,
      );
    }).toList();
  }
}
