import 'dart:convert';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/checkout_session_model.dart';

import 'package:marcos_malaga_app/app/shared/domain/entities/order/order_item.dart';

class LocalCheckoutSessionDatasource {
  final SharedPreferences prefs;
  static const String _sessionsKey = 'checkout_sessions';

  LocalCheckoutSessionDatasource({required this.prefs});

  String _generateSessionId() {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final randomString = List.generate(
      8,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
    return 'cs_$randomString';
  }

  Map<String, dynamic> _getSessionsMap() {
    final sessionsString = prefs.getString(_sessionsKey);
    if (sessionsString == null || sessionsString.isEmpty) {
      return <String, dynamic>{};
    }
    try {
      final decoded = jsonDecode(sessionsString);
      if (decoded is Map<String, dynamic>) {
        return Map<String, dynamic>.from(decoded);
      }
      return <String, dynamic>{};
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  Future<CheckoutSessionModel> createSession({
    required List<OrderItem> items,
    required bool clearCartOnSuccess,
  }) async {
    final session = CheckoutSessionModel(
      id: _generateSessionId(),
      items: items,
      clearCartOnSuccess: clearCartOnSuccess,
      createdAt: DateTime.now(),
    );

    final sessionsMap = _getSessionsMap();
    sessionsMap[session.id] = session.toJson();
    await prefs.setString(_sessionsKey, jsonEncode(sessionsMap));

    return session;
  }

  Future<CheckoutSessionModel?> getSession(String id) async {
    final sessionsMap = _getSessionsMap();
    final sessionJson = sessionsMap[id];
    if (sessionJson == null) {
      return null;
    }
    try {
      return CheckoutSessionModel.fromJson(
        Map<String, dynamic>.from(sessionJson as Map),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> saveSession(CheckoutSessionModel session) async {
    final sessionsMap = _getSessionsMap();
    sessionsMap[session.id] = session.toJson();
    await prefs.setString(_sessionsKey, jsonEncode(sessionsMap));
  }

  Future<void> deleteSession(String id) async {
    final sessionsMap = _getSessionsMap();
    if (sessionsMap.containsKey(id)) {
      sessionsMap.remove(id);
      await prefs.setString(_sessionsKey, jsonEncode(sessionsMap));
    }
  }
}
