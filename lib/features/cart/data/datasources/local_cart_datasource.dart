import 'dart:convert';
import 'package:marcos_malaga_app/features/cart/data/models/cart_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalCartDatasource {
  final SharedPreferences prefs;
  static const String _cartKey = 'CART_DATA';

  LocalCartDatasource({required this.prefs});

  Future<CartModel> getCart() async {
    final cartString = prefs.getString(_cartKey);
    if (cartString != null && cartString.isNotEmpty) {
      try {
        final Map<String, dynamic> json = jsonDecode(cartString);
        return CartModel.fromJson(json);
      } catch (e) {
        return const CartModel();
      }
    }
    return const CartModel();
  }

  Future<void> saveCart(CartModel cart) async {
    final jsonString = jsonEncode(cart.toJson());
    await prefs.setString(_cartKey, jsonString);
  }
}
