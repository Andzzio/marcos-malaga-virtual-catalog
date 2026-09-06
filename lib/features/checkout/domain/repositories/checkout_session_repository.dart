import 'package:marcos_malaga_app/features/checkout/domain/entities/checkout_session.dart';
import 'package:marcos_malaga_app/app/shared/domain/entities/order/order_item.dart';

abstract class CheckoutSessionRepository {
  Future<CheckoutSession> createSession({
    required List<OrderItem> items,
    required bool clearCartOnSuccess,
  });

  Future<CheckoutSession?> getSession(String id);

  Future<void> deleteSession(String id);
}
