import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:marcos_malaga_app/app/core/utils/app_logger.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/checkout_config_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/ubigeo_model.dart';

class LocalCheckoutConfigDatasource {
  final AssetBundle _bundle;
  static const String _ubigeoPath = 'assets/json/ubigeo.json';
  static const String _checkoutConfigPath = 'assets/json/checkout_config.json';

  LocalCheckoutConfigDatasource({AssetBundle? bundle})
    : _bundle = bundle ?? rootBundle;

  Future<UbigeoModel> getUbigeo() async {
    try {
      final jsonString = await _bundle.loadString(_ubigeoPath);
      final jsonDecoded = jsonDecode(jsonString) as Map<String, dynamic>;
      return UbigeoModel.fromJson(jsonDecoded);
    } catch (e, stackTrace) {
      AppLogger.e(
        'An error occurred loading "$_ubigeoPath" at $stackTrace with error: $e',
      );
      return const UbigeoModel();
    }
  }

  Future<CheckoutConfigModel> getCheckoutConfig() async {
    try {
      final jsonString = await _bundle.loadString(_checkoutConfigPath);
      final jsonDecoded = jsonDecode(jsonString) as Map<String, dynamic>;
      return CheckoutConfigModel.fromJson(jsonDecoded);
    } catch (e, stackTrace) {
      AppLogger.e(
        'An error occurred loading "$_checkoutConfigPath" at $stackTrace with error: $e',
      );
      return const CheckoutConfigModel();
    }
  }
}
