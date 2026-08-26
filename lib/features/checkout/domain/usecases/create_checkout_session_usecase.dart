import 'package:marcos_malaga_app/features/checkout/domain/entities/checkout_session.dart';
import 'package:marcos_malaga_app/features/checkout/domain/entities/order_item.dart';
import 'package:marcos_malaga_app/features/checkout/domain/repositories/checkout_session_repository.dart';

class CreateCheckoutSessionUseCase {
  final CheckoutSessionRepository repository;

  CreateCheckoutSessionUseCase(this.repository);

  Future<CheckoutSession> call({
    required List<OrderItem> items,
    required bool clearCartOnSuccess,
  }) {
    return repository.createSession(
      items: items,
      clearCartOnSuccess: clearCartOnSuccess,
    );
  }
}
