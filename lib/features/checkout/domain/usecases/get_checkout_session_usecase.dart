import 'package:marcos_malaga_app/features/checkout/domain/entities/checkout_session.dart';
import 'package:marcos_malaga_app/features/checkout/domain/repositories/checkout_session_repository.dart';

class GetCheckoutSessionUseCase {
  final CheckoutSessionRepository repository;

  GetCheckoutSessionUseCase(this.repository);

  Future<CheckoutSession?> call(String id) {
    return repository.getSession(id);
  }
}
