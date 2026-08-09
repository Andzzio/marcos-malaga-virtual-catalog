import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:marcos_malaga_app/app/core/utils/app_logger.dart';
import 'package:marcos_malaga_app/app/core/data/models/store_info_model.dart';

class LocalStoreInfoDatasource {
  static const String _jsonRoute = 'assets/json/store_info.json';

  Future<StoreInfoModel?> fetchStoreInfo() async {
    try {
      final jsonString = await rootBundle.loadString(_jsonRoute);
      final jsonDecoded = jsonDecode(jsonString) as Map<String, dynamic>;
      return StoreInfoModel.fromJson(jsonDecoded);
    } catch (e, stackTrace) {
      AppLogger.e(
        'A error has ocurred in opening "$_jsonRoute" at $stackTrace with error: $e',
      );
      return null;
    }
  }
}
