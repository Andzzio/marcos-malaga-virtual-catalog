import '../entities/checkout_config_entity.dart';
import '../repositories/checkout_config_repository.dart';

class GetCheckoutConfigUseCase {
  final CheckoutConfigRepository repository;

  GetCheckoutConfigUseCase(this.repository);

  Future<CheckoutConfigEntity> call() {
    return repository.getCheckoutConfig();
  }
}
