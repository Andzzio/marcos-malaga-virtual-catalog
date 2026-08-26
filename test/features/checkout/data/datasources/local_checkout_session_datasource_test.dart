import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marcos_malaga_app/features/checkout/data/datasources/local_checkout_session_datasource.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/checkout_session_model.dart';
import 'package:marcos_malaga_app/features/checkout/data/models/order_item_model.dart';

void main() {
  late SharedPreferences prefs;
  late LocalCheckoutSessionDatasource datasource;

  const tOrderItem = OrderItemModel(
    productId: 'prod-001',
    designId: 'des-001',
    sizeName: 'M',
    quantity: 1,
    productName: 'Vestido Floreado',
    designName: 'Floral',
    imageUrl: 'https://example.com/img.png',
    unitPrice: 120.0,
  );

  final tSession = CheckoutSessionModel(
    id: 'cs_test123',
    items: const [tOrderItem],
    clearCartOnSuccess: true,
    createdAt: DateTime(2026, 8, 19, 20, 0, 0),
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    datasource = LocalCheckoutSessionDatasource(prefs: prefs);
  });

  group('LocalCheckoutSessionDatasource', () {
    group('createSession', () {
      test('should create a session, save it to SharedPreferences and return model',
          () async {
        final session = await datasource.createSession(
          items: const [tOrderItem],
          clearCartOnSuccess: true,
        );

        expect(session.id, startsWith('cs_'));
        expect(session.items.length, 1);
        expect(session.clearCartOnSuccess, isTrue);

        final storedString = prefs.getString('checkout_sessions');
        expect(storedString, isNotNull);

        final decodedMap = jsonDecode(storedString!) as Map<String, dynamic>;
        expect(decodedMap.containsKey(session.id), isTrue);
        expect(decodedMap[session.id]['clearCartOnSuccess'], isTrue);
      });
    });

    group('getSession', () {
      test('should return CheckoutSessionModel when session exists in SharedPreferences',
          () async {
        final sessionsMap = {tSession.id: tSession.toJson()};
        await prefs.setString('checkout_sessions', jsonEncode(sessionsMap));

        final result = await datasource.getSession(tSession.id);

        expect(result, isNotNull);
        expect(result!.id, equals(tSession.id));
        expect(result.clearCartOnSuccess, equals(tSession.clearCartOnSuccess));
        expect(result.items.first.productId, equals('prod-001'));
      });

      test('should return null when session does not exist in SharedPreferences',
          () async {
        final result = await datasource.getSession('non_existent_id');

        expect(result, isNull);
      });

      test('should return null when json is invalid/corrupted', () async {
        await prefs.setString('checkout_sessions', 'invalid_json_string');

        final result = await datasource.getSession('any_id');

        expect(result, isNull);
      });
    });

    group('saveSession', () {
      test('should save session to SharedPreferences', () async {
        await datasource.saveSession(tSession);

        final storedString = prefs.getString('checkout_sessions');
        expect(storedString, isNotNull);

        final decodedMap = jsonDecode(storedString!) as Map<String, dynamic>;
        expect(decodedMap[tSession.id]['id'], equals(tSession.id));
      });
    });

    group('deleteSession', () {
      test('should remove session from SharedPreferences if it exists',
          () async {
        final sessionsMap = {tSession.id: tSession.toJson()};
        await prefs.setString('checkout_sessions', jsonEncode(sessionsMap));

        await datasource.deleteSession(tSession.id);

        final storedString = prefs.getString('checkout_sessions');
        final decodedMap = jsonDecode(storedString!) as Map<String, dynamic>;
        expect(decodedMap.containsKey(tSession.id), isFalse);
      });

      test('should do nothing if session does not exist in SharedPreferences',
          () async {
        await datasource.deleteSession('non_existent_id');

        final storedString = prefs.getString('checkout_sessions');
        expect(storedString, isNull);
      });
    });
  });
}
