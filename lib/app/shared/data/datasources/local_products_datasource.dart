import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:marcos_malaga_app/app/core/utils/app_logger.dart';
import 'package:marcos_malaga_app/features/catalog/data/models/product_model.dart';

class LocalProductsDatasource {
  static const String _jsonRoute = 'assets/json/products.json';

  Future<List<ProductModel>> fetchProducts() async {
    final List<ProductModel> products = [];
    late final String jsonString;
    try {
      jsonString = await rootBundle.loadString(_jsonRoute);
      final jsonDecoded = jsonDecode(jsonString) as List<dynamic>;
      for (final entry in jsonDecoded) {
        products.add(ProductModel.fromJson(entry));
      }
      return products;
    } catch (e, stackTrace) {
      AppLogger.e(
        'A error has ocurred in opening "$_jsonRoute" at $stackTrace with error: $e',
      );
      return products;
    }
  }

  Future<ProductModel?> fetchProductById(String id) async {
    final ProductModel? product;
    final String? jsonString;
    try {
      jsonString = await rootBundle.loadString(_jsonRoute);
      final jsonDecoded = jsonDecode(jsonString) as List<dynamic>;
      final Map<String, dynamic>? productMap = jsonDecoded.firstWhere(
        (product) => product['id'] == id,
        orElse: () => null,
      );
      if (productMap == null) return null;
      product = ProductModel.fromJson(productMap);
      return product;
    } catch (e, stackTrace) {
      AppLogger.e(
        'A error has ocurred in opening "$_jsonRoute" at $stackTrace with error: $e',
      );
      return null;
    }
  }
}
