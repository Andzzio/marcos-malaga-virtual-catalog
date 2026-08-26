import '../entities/checkout_config_entity.dart';
import '../entities/ubigeo_entities.dart';

abstract class CheckoutConfigRepository {
  Future<UbigeoEntity> getUbigeo();
  Future<CheckoutConfigEntity> getCheckoutConfig();
}
