import '../entities/ubigeo_entities.dart';
import '../repositories/checkout_config_repository.dart';

class GetUbigeoUseCase {
  final CheckoutConfigRepository repository;

  GetUbigeoUseCase(this.repository);

  Future<UbigeoEntity> call() {
    return repository.getUbigeo();
  }
}
