import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:marcos_malaga_app/app/shared/data/models/order/order_model.dart';

class LocalOrderDatasource {
  final SharedPreferences prefs;
  static const String _ordersKey = 'local_orders';

  LocalOrderDatasource({required this.prefs});

  Future<void> saveOrder(OrderModel order) async {
    final existingOrdersString = prefs.getString(_ordersKey);
    List<dynamic> ordersList = [];
    if (existingOrdersString != null && existingOrdersString.isNotEmpty) {
      try {
        ordersList = jsonDecode(existingOrdersString) as List<dynamic>;
      } catch (_) {
        ordersList = [];
      }
    }

    ordersList.add(order.toJson());
    await prefs.setString(_ordersKey, jsonEncode(ordersList));
  }

  Future<List<OrderModel>> getOrders() async {
    final ordersString = prefs.getString(_ordersKey);
    if (ordersString == null || ordersString.isEmpty) {
      return const [];
    }
    try {
      final decoded = jsonDecode(ordersString) as List<dynamic>;
      return decoded
          .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return const [];
    }
  }
}
