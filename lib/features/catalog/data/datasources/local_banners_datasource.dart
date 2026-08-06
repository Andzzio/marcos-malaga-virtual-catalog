import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:marcos_malaga_app/app/core/utils/app_logger.dart';
import 'package:marcos_malaga_app/features/catalog/data/models/banner_model.dart';

class LocalBannersDatasource {
  static const String _jsonRoute = 'assets/json/banners.json';
  Future<List<BannerModel>> fetchBanners() async {
    try {
      final String jsonString = await rootBundle.loadString(_jsonRoute);
      final List<dynamic> jsonList = jsonDecode(jsonString);

      return jsonList.map((json) => BannerModel.fromJson(json)).toList();
    } catch (e, stackTrace) {
      AppLogger.e('Error loading banners from local JSON', e, stackTrace);
      return [];
    }
  }
}
